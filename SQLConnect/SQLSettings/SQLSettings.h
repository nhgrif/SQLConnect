//
//  SQLSettings.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

@import Foundation.NSObject;
@import Foundation.NSString;

@interface SQLSettings : NSObject

/*
 *  Returns a SQLSettings instance
 *
 *  @return SLQSettings object
 */
+ (instancetype)settings;

/*
 *  Returns a shared SQLSettings instance. This object can be used to specify default settings that SQLConnection objects will use when initialized without settings parameters.
 *
 *  @return Default settings object
 */
+ (instancetype)defaultSettings;

/**
 *  The database server to use.  Supports server, server:port, or server\instance (be sure to escape the backslash)
 */
@property (nonatomic,strong) NSString *server;

/**
 *  The database username
 */
@property (nonatomic,strong) NSString *username;

/**
 *  The database password
 */
@property (nonatomic,strong) NSString *password;

/**
 *  The database name to use
 */
@property (nonatomic,strong) NSString *database;

@end
