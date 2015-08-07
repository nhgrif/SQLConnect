//
//  SQLTableController.m
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

#import "SQLTableController.h"
#import "SQLManager.h"


@interface SQLTableController ()

@end

@implementation SQLTableController {
    NSMutableString *__error_string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)sqlConnectionDidSucceed:(SQLConnection *)connection {
#if DEBUG
    NSLog(@"SQL Connection (tag:%ld) did succeed",(long)connection.tag);
#endif
}

- (void)sqlConnection:(SQLConnection *)connection executeDidCompleteWithResults:(NSArray *)results {
    [connection disconnect];
#if DEBUG
    NSLog(@"SQL Connection (tag:%ld) did execute...",(long)connection.tag);
    NSLog(@"...with results: %@", results);
#endif
}

- (void)sqlConnection:(SQLConnection *)connection didReceiveServerMessage:(NSString *)message {
#if DEBUG
    if (![message hasPrefix:@"Changed database context to "]) {
        NSLog(@"SQL Message: %@", message);
    }
#endif
    if (!__error_string) {
        __error_string = [NSMutableString string];
    }
    if (![message hasPrefix:@"Changed database context to"]) {
        [__error_string appendFormat:@"%@ \n\r", message];
    }
}

- (void)sqlConnection:(SQLConnection *)connection didReceiveServerError:(NSString *)error code:(int)code severity:(int)severity {
#if DEBUG
    NSLog(@"SQL Error (%d): %@ - Severity: %d", code, error, severity);
    NSLog(@"SQLController %@ - Open Connections: %ld", self, (long)[SQLManager manager].connectionCount);
#endif
    if (!__error_string) {
        __error_string = [NSMutableString string];
    }
    [__error_string appendFormat:@"SQL Error (%d): %@ \r\n", code, error];
}

- (void)sqlConnection:(SQLConnection *)connection connectionDidFailWithError:(NSError *)error {
    [connection disconnect];
#if DEBUG
    NSLog(@"SQL Connection (tag:%ld) did fail with error: %@",(long)connection.tag, error);
#endif
}

- (void)sqlConnection:(SQLConnection *)connection executeDidFailWithError:(NSError *)error {
    [connection disconnect];
#if DEBUG
    NSLog(@"SQL Connection (tag:%ld) execute did fail with error: %@", (long)connection.tag, error);
#endif
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
