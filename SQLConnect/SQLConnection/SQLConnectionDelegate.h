//
//  SQLConnectionDelegate.h
//  SQLConnect
//
/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Nick Griffith
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

@import Foundation.NSError;
@import Foundation.NSObject;
@import Foundation.NSString;
@import Foundation.NSArray;

NS_ASSUME_NONNULL_BEGIN

@class SQLConnection;

@protocol SQLConnection <NSObject>

/*
 *  Required delegate method to handle successful connection completion
 *  
 *  @param  connection  The SQLConnection instance which completed connection successfully
 */
@required - (void)sqlConnectionDidSucceed:(SQLConnection *)connection;

/*
 *  Required delegate method to handle connection failure
 *
 *  @param  connection  The SQLConnection instance which failed to connect
 *  @param  error       An error describing the connection problem
 */
@required - (void)sqlConnection:(SQLConnection *)connection connectionDidFailWithError:(NSError *)error;

@end

@protocol SQLQuery <NSObject>

/*
 *  Required delegate method to handle successful execution of a SQL command on the server
 *
 *  @param  connection  The SQLConnection instance which handled the execution
 *  @param  results     The results, if any, returned from the database
 */
@required - (void)sqlConnection:(SQLConnection *)connection executeDidCompleteWithResults:(NSArray *)results;

/*
 *  Required delegate method to handle unsuccessful execution of a SQL command on the server
 *
 *  @param  connection  The SQLConnection instance which handled the execution
 *  @param  error       An error describing the execution problem
 */
@required - (void)sqlConnection:(SQLConnection *)connection executeDidFailWithError:(NSError *)error;

@end

@protocol SQLConnectionDelegate <SQLConnection, SQLQuery, NSObject>

/*
 *  Optional delegate method to handle message notifications from the server
 *
 *  @param  connection  The SQLConnection instance which received the message
 *  @param  message     The message from the server
 */
@optional - (void)sqlConnection:(SQLConnection *)connection didReceiveServerMessage:(NSString *)message;

/*
 *  Optional delegate method to handle error notifications from the server
 *
 *  @param  connection  The SQLConnection instance which received the message
 *  @param  error       The error message from the server
 *  @param  code        The error code from the server
 *  @param  severity    The error severity from the server
 */
@optional - (void)sqlConnection:(SQLConnection *)connection didReceiveServerError:(NSString*)error code:(int)code severity:(int)severity;

@end

NS_ASSUME_NONNULL_END