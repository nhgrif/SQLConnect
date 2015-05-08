//
//  SQLManager.m
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

#import <Foundation/Foundation.h>
#import "SQLManager.h"
#import "sybdb.h"

@interface NSMutableArray (WeakReferences) @end

@implementation NSMutableArray (WeakReferences)

+ (instancetype)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    
    return (__bridge id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

@end

@implementation SQLManager {
    NSMutableArray *_managedConnections;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _managedConnections = [NSMutableArray mutableArrayUsingWeakReferences];
    }
    return self;
}

+ (instancetype)manager {
    static SQLManager *manager;
    @synchronized(self) {
        if (!manager) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (BOOL)addConnection:(SQLConnection *)connection {
    if ([_managedConnections count] == 0) {
        if (dbinit() == FAIL) {
            return NO;
        }
    }
    
    [_managedConnections addObject:connection];
    return YES;
}

- (void)removeConnection:(SQLConnection *)connection {
    [_managedConnections removeObject:connection];
    
    if ([_managedConnections count] == 0) {
        dbexit();
    }
}

- (NSInteger)connectionCount {
    return _managedConnections == nil ? 0 : [_managedConnections count];
}

@end
