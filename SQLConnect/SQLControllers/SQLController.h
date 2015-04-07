//
//  SQLController.h
//  Attachment Wizard
//
//  Created by Ability585 on 4/2/14.
//  Copyright (c) 2014 Ability585. All rights reserved.
//

@import UIKit.UIViewController;
#import "SQLConnect.h"

@interface SQLController : UIViewController <SQLConnectionDelegate>

- (void)viewDidLoad NS_REQUIRES_SUPER;
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidDisappear:(BOOL)animated NS_REQUIRES_SUPER;

- (void)sqlConnection:(SQLConnection *)connection didReceiveServerMessage:(NSString *)message NS_REQUIRES_SUPER;
- (void)sqlConnection:(SQLConnection *)connection didReceiveServerError:(NSString *)error code:(int)code severity:(int)severity NS_REQUIRES_SUPER;
- (void)sqlConnection:(SQLConnection *)connection executeDidFailWithError:(NSError *)error NS_REQUIRES_SUPER;

@end
