typedef NS_ENUM (NSInteger, SQLErrorCodes) {
    SQL_LoginStructFailedToInitialize = 100,
    SQL_ConnectionError = 101,
    SQL_DatabaseChangeError = 102,
    SQL_ExecutionError = 200,
    SQL_ColumnsStructFailedToInitialize = 201,
    SQL_BufferFailedToAllocate = 202,
    SQL_ErrorBindingColumnName = 203,
    SQL_ErrorBindingColumnStatus = 204,
    SQL_BufferFull = 205,
    SQL_RowReadError = 206
};

#define kSQL_LoginStructFailedToInitialize  (@"Login struct failed to initialize")
#define kSQL_ConnectionError                (@"An error occurred while attempting to connect to the server")
#define kSQL_DatabaseChangeError            (@"An error occurred while attempting to change databases")
#define kSQL_ExecutionError                 (@"An error occurred while attempting to execute the SQL statement")
#define kSQL_ColumnStructFailedToInitialize (@"Column struct failed to initialize")
#define kSQL_BufferFailedToAllocate         (@"Data buffer failed to allocate")
#define kSQL_ErrorBindingColumnName         (@"An error occurred while attempting to bind a column name")
#define kSQL_ErrorBindingColumnStatus       (@"An error occurred while attempting to bind a column status")
#define kSQL_BufferFull                     (@"Buffer full")
#define kSQL_RowReadError                   (@"An error occurred while attempting to read a row")