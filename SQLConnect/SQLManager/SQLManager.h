//
//  SQLManager.h
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

// The class is not publicly visible outside the library.  It is used internally only.
// This class manages when dbinit() and dbexit() need to be called.

@import Foundation.NSObject;

NS_ASSUME_NONNULL_BEGIN

@class SQLConnection;

@interface SQLManager : NSObject

@property (nonatomic,assign,readonly) NSInteger connectionCount;

/**
 *  Returns a initialized SQLManager instance as a singleton
 *
 *  @return Shared SQLManager object
 */
+ (instancetype)manager NS_REQUIRES_SUPER;

/**
 *  Attempts to add a new connection to the SQLManager's management array. Returns YES/NO indicating whether connection was successfully added.
 *
 *  @return BOOL indicating success
 */
- (BOOL)addConnection:(SQLConnection*)connection NS_REQUIRES_SUPER;

/*
 *  Removes a connection from the SQLManager's management array.
 */
- (void)removeConnection:(SQLConnection*)connection NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END