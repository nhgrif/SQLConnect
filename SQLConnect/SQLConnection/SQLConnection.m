//
//  SQLConnection.m
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

#import "SQLConnection.h"
#import "SQLManager.h"
#import "SQLErrorCodes.h"
#import "sybdb.h"

int const SQLConnectDefaultLoginTimeout = 5;
int const SQLConnectDefaultExecuteTimeout = 5;

NSString * const SQLConnectDefaultCharset = @"UTF-8";
NSString * const SQLConnectWorkerQueueName = @"com.importblogkit.sqlconnect";

NSString * const SQLConnectRowIgnoreMessage = @"Ignoring unknown row type";

typedef struct COL {
    char    *columnName;
    char    *dataBuffer;
    int     dataType;
    int     dataSize;
    int     columnStatus;
} SQLColumn;

@interface SQLConnection()

- (void)message:(NSString*)message;
- (void)error:(NSString*)error code:(int)code severity:(int)severity;

@property (nonatomic,strong) NSString *originalDelegate;

@end


//Handles error callback from FreeTDS library.
int err_handler(DBPROCESS* dbproc, int severity, int dberr, int oserr, char* dberrstr, char* oserrstr) {
    if (dbproc) {
        __weak SQLConnection *sqlConnection = (__bridge SQLConnection*)(void*)dbgetuserdata(dbproc);
        [sqlConnection error:[NSString stringWithUTF8String:dberrstr] code:dberr severity:severity];
    }
    return INT_CANCEL;
}

//Handles message callback from FreeTDS library.
int msg_handler(DBPROCESS* dbproc, DBINT msgno, int msgstate, int severity, char* msgtext, char* srvname, char* procname, int line) {
    if (dbproc) {
        __weak SQLConnection *sqlConnection = (__bridge SQLConnection*)(void*)dbgetuserdata(dbproc);
        [sqlConnection message:[NSString stringWithUTF8String:msgtext]];
    }
    return 0;
}

@implementation SQLConnection {
    LOGINREC    *_login;
    DBPROCESS   *_connection;

    char        *_tempServer;
    char        *_tempUsername;
    char        *_tempPassword;
    char        *_tempDatabase;
    char        *_tempCharSet;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<SQLConnection %p> delegated by: %@", self, self.delegate ?:
                [NSString stringWithFormat:@"NIL (%@)", [self respondsToSelector:@selector(originalDelegate)] ? self.originalDelegate : @"nil"]
            ];
}

#pragma mark dealloc
- (void)dealloc {
    [[SQLManager manager] removeConnection:self];
}

#pragma mark Initializer methods
// designated initializer
- (instancetype)initWithServer:(NSString *)server
            username:(NSString *)username
            password:(NSString *)password
            database:(NSString *)database
            delegate:(NSObject<SQLConnectionDelegate>*)delegate {
    self = [super init];
    if (self) {
        if ([[SQLManager manager] addConnection:self]) {
            _login = NULL;
            _connection = NULL;
            
            _delegate = delegate;
            _originalDelegate = [delegate description];
            
            _server   = server;
            _username = username;
            _password = password;
            _database = database;
            _charset = SQLConnectDefaultCharset;
            
            _loginTimeout = SQLConnectDefaultLoginTimeout;
            _executeTimeout = SQLConnectDefaultExecuteTimeout;
            
            _callbackQueue = [NSOperationQueue currentQueue];
            _workerQueue = [[NSOperationQueue alloc] init];
            _workerQueue.name = SQLConnectWorkerQueueName;
            
            dberrhandle(err_handler);
            dbmsghandle(msg_handler);
        } else {
            return nil;
        }
    }
    return self;
}

+ (instancetype)sqlConnectionWithDelegate:(NSObject<SQLConnectionDelegate>*)delegate {
    SQLSettings *defaultSettings = [SQLSettings defaultSettings];
    return [self sqlConnectionWithServer:defaultSettings.server
                                username:defaultSettings.username
                                password:defaultSettings.password
                                database:defaultSettings.database
                                delegate:delegate];
}

+ (instancetype)sqlConnectionWithServer:(NSString *)server
                               username:(NSString *)username
                               password:(NSString *)password
                               database:(NSString *)database
                               delegate:(NSObject<SQLConnectionDelegate>*)delegate {
    return [[self alloc] initWithServer:server
                               username:username
                               password:password
                               database:database
                               delegate:delegate];
}

- (instancetype)initWithSettings:(SQLSettings *)settings delegate:(NSObject<SQLConnectionDelegate>*)delegate {
    return [self initWithServer:settings.server
                       username:settings.username
                       password:settings.password
                       database:settings.database
                       delegate:delegate];
}

+ (instancetype)sqlConnectionWithSettings:(SQLSettings *)settings delegate:(NSObject<SQLConnectionDelegate>*)delegate {
    return [[self alloc] initWithSettings:settings delegate:delegate];
}

#pragma mark Connect methods
- (void)connect {
    [self connectToServer:self.server withUsername:self.username password:self.password usingDatabase:self.database charset:self.charset];
}
 
- (void)connectToServer:(NSString *)server
           withUsername:(NSString *)username
               password:(NSString *)password
          usingDatabase:(NSString *)database
                charset:(NSString *)charset {
    
    // work on background queue
    [self.workerQueue addOperationWithBlock:^{
        
        // set login time
        dbsetlogintime(self.loginTimeout);
        
        // initialize the _login struct
        _login = dblogin();
        
        // handle failure
        if (_login == FAIL) {

            NSError *error = [NSError errorWithDomain:kSQL_LoginStructFailedToInitialize
                                                 code:SQL_LoginStructFailedToInitialize
                                             userInfo:nil];
            [self connectionFailure:error];
            return;
        }
        
        // create C-strings that can be released
        _tempServer = strdup([server UTF8String]);
        _tempUsername = strdup([username UTF8String]);
        _tempPassword = strdup([password UTF8String]);
        _tempDatabase = strdup([database UTF8String]);
        
        if (charset) {
            _tempCharSet = strdup([charset UTF8String]);
        } else {
            _tempCharSet = strdup([self.charset UTF8String]);
        }
        
        // populate login struct
        DBSETLUSER(_login, _tempUsername);
        DBSETLPWD(_login, _tempPassword);
        DBSETLHOST(_login, _tempServer);
        DBSETLCHARSET(_login, _tempCharSet);
        
        // attempt connection
        _connection = dbopen(_login, _tempServer);
        
        // handle connection failure
        if (_connection == NULL) {
            NSError *error = [NSError errorWithDomain:kSQL_ConnectionError
                                                 code:SQL_ConnectionError
                                             userInfo:nil];
            [self connectionFailure:error];
            return;
        } else {
            // set user data so we can call back to correct object
            dbsetuserdata(_connection, (BYTE*)CFBridgingRetain(self));
            //dbsetuserdata(_connection, (__bridge void*)self);
        }
        
        // attempt to switch database
        if (dbuse(_connection, _tempDatabase) == FAIL) {
            NSError *error = [NSError errorWithDomain:kSQL_DatabaseChangeError
                                                 code:SQL_DatabaseChangeError
                                             userInfo:nil];
            [self connectionFailure:error];
            return;
        }

        [self connectionSuccess];
    }];
}

- (void)connectionSuccess {
    // invoke delegate method on calling queue
    [self.callbackQueue addOperationWithBlock:^{
        if (self.delegate) {
            [self.delegate sqlConnectionDidSucceed:self];
        } else {
            [self disconnect];
        }
    }];
    
    // cleanup C-struct
    dbloginfree(_login);
    
    // free login data
    free(_tempServer);
    free(_tempUsername);
    free(_tempPassword);
    free(_tempDatabase);
    free(_tempCharSet);
}

- (void)connectionFailure:(NSError*)error {
    // invoke delegate method on calling queue
    [self.callbackQueue addOperationWithBlock:^{
        if (self.delegate) {
            [self.delegate sqlConnection:self connectionDidFailWithError:error];
        } else {
            [self disconnect];
        }
    }];
    
    // cleanup C-structs
    if (_login) {
        dbloginfree(_login);
    }
    
    if (_connection) {
        //CFRelease(dbgetuserdata(_connection));
        dbfreebuf(_connection);
    }
    
    // free login data
    free(_tempServer);
    free(_tempUsername);
    free(_tempPassword);
    free(_tempDatabase);
    free(_tempCharSet);
}

#pragma mark Execute:
- (void)execute:(NSString *)statement {
    void(^cleanUp)(SQLColumn *, SQLColumn *, int numCols) = ^(SQLColumn *pcol, SQLColumn *columns, int numCols) {
        for (pcol = columns; pcol - columns < numCols; ++pcol) {
            free(pcol->dataBuffer);
        }
        free(columns);
    };
    
    // work on background queue
    [self.workerQueue addOperationWithBlock:^{

        // set execute timeout
        dbsettime(self.executeTimeout);
        
        // prepare the SQL statement
        dbcmd(_connection, [statement UTF8String]);
        
        // attempt to execute the statement
        if (dbsqlexec(_connection) == FAIL) {
            NSError *error = [NSError errorWithDomain:kSQL_ExecutionError
                                                 code:SQL_ExecutionError
                                             userInfo:@{@"Executing":statement}];
            
            [self executionFailure:error];
            return;
        }
        
        // create an array to contain the result tables
        NSMutableArray *result = [NSMutableArray array];
        
        SQLColumn *columns;
        SQLColumn *pcol;
        int statusCode;
        
        // loop through each table
        while ((statusCode = dbresults(_connection)) != NO_MORE_RESULTS) {
            int numCols;
            int row_code;
            
            // create an array to contain the result rows for this table
            NSMutableArray *table = [NSMutableArray array];
            
            // get number of columns
            numCols = dbnumcols(_connection);
            
            // allocate C-style array of COL structs
            columns = calloc(numCols, sizeof(SQLColumn));
            
            // handle allocation error
            if (columns == NULL) {
                NSError *error = [NSError errorWithDomain:kSQL_ColumnStructFailedToInitialize
                                                     code:SQL_ColumnsStructFailedToInitialize
                                                 userInfo:@{@"Executing":statement}];
                
                [self executionFailure:error];
                return;
            }
            
            // bind the column info
            for (pcol = columns; pcol - columns < numCols; ++pcol) {
                // get current column number
                int c = (int)(pcol - columns + 1);
                
                // get column metadata
                pcol->columnName = dbcolname(_connection, c);
                pcol->dataType = dbcoltype(_connection, c);
                pcol->dataSize = dbcollen(_connection, c);
                
                // if the column is varchar or text, we want defined size.
                // otherwise, we want max size when represented as a string
                if (pcol->dataType != SYBCHAR && pcol->dataType != SYBTEXT) {
                    pcol->dataSize = dbwillconvert(pcol->dataType, SYBCHAR);
                }
                
                // allocate memory in the current pcol struct for a buffer
                pcol->dataBuffer = calloc(1, pcol->dataSize + 1);
                
                // handle allocation error
                if (pcol->dataBuffer == NULL) {
                    NSError *error = [NSError errorWithDomain:kSQL_BufferFailedToAllocate
                                                         code:SQL_BufferFailedToAllocate
                                                     userInfo:@{@"Executing":statement}];
                    [self executionFailure:error];
                    
                    // clean up
                    cleanUp(pcol, columns, numCols);
                    
                    return;
                }
                
                // bind column name
                statusCode = dbbind(_connection, c, NTBSTRINGBIND, pcol->dataSize + 1, (BYTE*)pcol->dataBuffer);
                if (statusCode == FAIL) {
                    NSError *error = [NSError errorWithDomain:kSQL_ErrorBindingColumnName
                                                         code:SQL_ErrorBindingColumnName
                                                     userInfo:@{@"Executing":statement}];
                    [self executionFailure:error];
                    
                    // clean up
                    cleanUp(pcol, columns, numCols);
                    
                    return;
                }
                
                // bind column status
                statusCode = dbnullbind(_connection, c, &pcol->columnStatus);
                if (statusCode == FAIL) {
                    NSError *error = [NSError errorWithDomain:kSQL_ErrorBindingColumnStatus
                                                         code:SQL_ErrorBindingColumnStatus
                                                     userInfo:@{@"Executing":statement}];
                    [self executionFailure:error];
                    
                    // clean up
                    cleanUp(pcol, columns, numCols);
                    
                    return;
                }
            }
            // done binding column info
            
            // loop through each row
            while ((row_code = dbnextrow(_connection)) != NO_MORE_ROWS) {
                // check row type
                switch (row_code) {
                    // regular row
                    case REG_ROW: {
                        // create a dictionary to contain the column names and values
                        NSMutableDictionary *row = [NSMutableDictionary dictionaryWithCapacity:numCols];

                        // loop through each column, creating an entry in row where dictionary[columnName] = columnValue
                        for (pcol = columns; pcol - columns < numCols; ++pcol) {
                            NSString *columnName = [NSString stringWithUTF8String:pcol->columnName];
                            
                            id columnValue;
                            // check if column has NULL value
                            if (pcol->columnStatus == -1) {
                                columnValue = [NSNull null];
                            } else {
                                // TODO: type checking
                                columnValue = [NSString stringWithUTF8String:pcol->dataBuffer];
                            }
                            
                            // insert the value into the dictionary
                            row[columnName] = columnValue;
                        }
                        
                        // add an immutable copy of the row to the table
                        [table addObject:[row copy]];
                        
                        break;
                    }
                    // buffer full
                    case BUF_FULL: {
                        NSError *error = [NSError errorWithDomain:kSQL_BufferFull
                                                             code:SQL_BufferFull
                                                         userInfo:@{@"Executing":statement}];
                        [self executionFailure:error];
                        
                        // clean up
                        cleanUp(pcol, columns, numCols);
                        
                        return;
                    }
                    // error
                    case FAIL: {
                        NSError *error = [NSError errorWithDomain:kSQL_RowReadError
                                                             code:SQL_RowReadError
                                                         userInfo:@{@"Executing":statement}];
                        [self executionFailure:error];
                        
                        // clean up
                        cleanUp(pcol, columns, numCols);
                        
                        return;
                    }
                    // unknown row type
                    default: {
                        [self message:SQLConnectRowIgnoreMessage];
                        break;
                    }
                }
            }
            
            // clean up
            cleanUp(pcol, columns, numCols);
            
            // add immutable copy of table to result
            [result addObject:[table copy]];
            
        }
        
        // parsing results complete, return immutable copy of results
        [self executionSuccess:result];
    }];
}

- (void)executionSuccess:(NSArray*)results {
    // invoke delegate method on calling queue
    [self.callbackQueue addOperationWithBlock:^{
        if (self.delegate) {
            [self.delegate sqlConnection:self executeDidCompleteWithResults:results];
        } else {
            [self disconnect];
        }
    }];
}

- (void)executionFailure:(NSError*)error {
    // invoke delegate method on calling queue
    [self.callbackQueue addOperationWithBlock:^{
        if (self.delegate) {
            [self.delegate sqlConnection:self executeDidFailWithError:error];
        } else {
            [self disconnect];
        }
    }];
}

- (void)message:(NSString*)message {
    if ([self.delegate respondsToSelector:@selector(sqlConnection:didReceiveServerMessage:)]) {
        // invoke delegate method on calling queue
        [self.callbackQueue addOperationWithBlock:^{
            if (self.delegate) {
                [self.delegate sqlConnection:self didReceiveServerMessage:message];
            } else {
                [self disconnect];
            }
        }];
    } else if (!self.delegate) {
        [self disconnect];
    }
}

- (void)error:(NSString*)error code:(int)code severity:(int)severity {
    if ([self.delegate respondsToSelector:@selector(sqlConnection:didReceiveServerError:code:severity:)]) {
        // invoke delegate method on calling queue
        [self.callbackQueue addOperationWithBlock:^{
            if (self.delegate) {
                [self.delegate sqlConnection:self didReceiveServerError:error code:code severity:severity];
            } else {
                [self disconnect];
            }
        }];
    } else if (!self.delegate) {
        [self disconnect];
    }
}

#pragma mark Disconnect
- (void)disconnect {
    @synchronized(self) {
        if (_connection) {
            dbclose(_connection);
            CFRelease(dbgetuserdata(_connection));
            _connection = NULL;
        }
    }
}

#pragma mark Connected
- (BOOL)connected {
    if (_connection) {
        return !dbdead(_connection);
    } else {
        return NO;
    }
}

@end
