//
//  MITViewController.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/22/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringBetween.h"

@interface MITViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *authView;
@property (nonatomic) BOOL isAuth;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, retain) NSString *secret;
- (IBAction)login:(id)sender;
- (IBAction)logOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end
