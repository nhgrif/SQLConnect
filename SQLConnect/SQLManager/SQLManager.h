//
//  SQLManager.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/16/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//

// The class is not publicly visible outside the library.  It is used internally only.
// This class manages when dbinit() and dbexit() need to be called.

@import Foundation.NSObject;

@class SQLConnection;

@interface SQLManager : NSObject

@property (nonatomic,assign,readonly) NSInteger connections;

- (void)logOpenConnectionDelegates;

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
