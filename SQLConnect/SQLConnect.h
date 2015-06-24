//
//  SQLConnect.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

#import <Foundation/Foundation.h>

extern NSString * __nonnull const SQLCONNECTION_VERSION_NUM;

#import "SQLConnection.h"
#import "SQLSettings.h"

BOOL isNull(id __nullable obj);
id __nullable nullReplace(id __nullable obj, id __nullable replacement);

/*
 *  SQLConnect is an Objective-C wrapper for FreeTDS that will allow your iOS app
 *      to Microsoft SQL Server or Sybase ASE without the need of going through a web service.
 */