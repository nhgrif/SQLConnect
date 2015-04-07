//
//  SQLSettings.m
//  SQLConnect
//
//  Created by Nick Griffith on 3/16/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//

#import "SQLSettings.h"

@implementation SQLSettings

- (id)init {
    self = [super init];
    if (self) {
        _server = @"";
        _username = @"";
        _password = @"";
        _database = @"";
    }
    return self;
}

+ (instancetype)settings {
    return [[self alloc] init];
}

+ (instancetype)defaultSettings {
    static SQLSettings *defaultSettings;
    @synchronized(self) {
        if (!defaultSettings) {
            defaultSettings = [SQLSettings settings];
        }
    }
    return defaultSettings;
}

@end
