//
//  SQLTableController.h
//  SQLConnect
//
//  Created by Nick Griffith on 3/17/14.
//  Copyright (c) 2014 nhg. All rights reserved.
//  https://github.com/nhgrif/SQLConnect
//  http://importBlogKit.com
//

#import <UIKit/UIKit.h>
#import "SQLConnect.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLTableController : UITableViewController <SQLConnectionDelegate>

- (void)viewDidLoad NS_REQUIRES_SUPER;
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidDisappear:(BOOL)animated NS_REQUIRES_SUPER;

- (void)sqlConnection:(SQLConnection *)connection didReceiveServerMessage:(NSString *)message NS_REQUIRES_SUPER;
- (void)sqlConnection:(SQLConnection *)connection didReceiveServerError:(NSString *)error code:(int)code severity:(int)severity NS_REQUIRES_SUPER;
- (void)sqlConnection:(SQLConnection *)connection executeDidFailWithError:(NSError *)error NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END