//
//  SQLConnect.h
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