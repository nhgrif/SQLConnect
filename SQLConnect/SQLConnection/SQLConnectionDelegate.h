//
//  SQLConnectionDelegate.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
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