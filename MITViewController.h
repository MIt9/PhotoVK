//
//  MITViewController.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/22/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *authView;
@property (nonatomic) BOOL isAuth;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, retain) NSString *secret;
- (IBAction)login:(id)sender;
- (IBAction)logOut:(id)sender;

@end
