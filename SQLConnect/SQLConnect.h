//
//  SQLConnect.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//

@import Foundation;

extern NSString * const SQLCONNECTION_VERSION_NUM;

#import "SQLConnection.h"
#import "SQLSettings.h"

BOOL isNull(id obj);
id nullReplace(id obj, id replacement);

/*
 *  SQLConnect is an Objective-C wrapper for FreeTDS that will allow your iOS app
 *      to Microsoft SQL Server or Sybase ASE without the need of going through a web service.
 */