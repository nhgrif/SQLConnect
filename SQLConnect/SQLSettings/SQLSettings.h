//
//  SQLSettings.h
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

@import Foundation.NSObject;
@import Foundation.NSString;

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END