//
//  SQLManager.m
//  SQLConnect
//
//  Created by Nick Griffith on 3/16/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLManager.h"
#import "sybdb.h"

@interface NSMutableArray (WeakReferences) @end

@implementation NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
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

- (id)init {
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
//#if DEBUG
//    printf("--> Open connections: %ld\n",(long)[SQLManager manager].connections);
//#endif
    return YES;
}

- (void)removeConnection:(SQLConnection *)connection {
    [_managedConnections removeObject:connection];
    
    if ([_managedConnections count] == 0) {
//#if DEBUG
//        printf("*** SQLManager exiting...\n");
//#endif
        dbexit();
    }
    [self logOpenConnectionDelegates];
}

- (NSInteger)connections {
    return _managedConnections == nil ? 0 : [_managedConnections count];
}

- (void)logOpenConnectionDelegates {
//#if DEBUG
//    printf("*** Logging %ld connections...\n",(long)[self connections]);
//    NSArray *printArray = [_managedConnections copy];
//    for (id obj in printArray) {
//        if ([obj isKindOfClass:[NSObject class]]) {
//            NSString *desc = [(NSObject *)obj description];
//            printf("    --> Open SQL connection: %s\n", [desc UTF8String]);
//        }
//    }
//    printf("*** End connection log...\n");
//#endif
}

@end
