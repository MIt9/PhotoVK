//
//  MITViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/22/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITViewController.h"
#import "MITRequest.h"
#import "MITAlbumListViewController.h"

@interface MITViewController ()

@end

@implementation MITViewController

@synthesize authView, indicator, secret, isAuth, logOutButton;

MITRequest *vkRequst;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBG.png"]];
    authView.hidden = YES;
    indicator.hidden = YES;

    [self isLogin];
    
    
}

// making http request for autorithation
- (void)linkFormAndRequestWithAppId:(NSString *)appID andScope:(NSString *)scope{
    NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=%@&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", appID, scope];
    NSURL *url = [NSURL URLWithString:authLink];
    NSURLRequest *authRequest = [[NSURLRequest alloc] initWithURL:url];
    
    [authView loadRequest:authRequest];
    [authView setDelegate:self];  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
    indicator.hidden = YES;
    [self logInRequest:webView];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self isAuth];
}

    


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toAlbumList"])
    {
        MITAlbumListViewController* albumList = [segue destinationViewController];
        [albumList setVkRequest:vkRequst];
        
        
    }
}

- (void)isLogin{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessToken"] == 0){
        isAuth = NO;
        logOutButton.hidden = YES;
    }else{
        vkRequst = [[MITRequest alloc]initFromNSUserDefaults];
        logOutButton.hidden = NO;

    }
}

- (IBAction)login:(id)sender {
   
    if (isAuth == NO) {
        indicator.hidden = NO;
        [indicator startAnimating];
        [self linkFormAndRequestWithAppId:@"4683729" andScope:@"photos"];
        authView.hidden = NO;
    }else{
        [self performSegueWithIdentifier:@"toAlbumList" sender:self];
    }
    NSLog(@"VKAccessToken = %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"]);
    NSLog(@"VKAccessUserId = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);

}

- (IBAction)logOut:(id)sender {
    [self logOutRequest];
    isAuth = NO;
    logOutButton.hidden = YES;
}
-(void)logInRequest:(UIWebView *)webView{
    if ([webView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        
        //geting token
        NSString *accessToken = [webView.request.URL.absoluteString getStringBetweenString:@"access_token=" andString:@"&"];
        // geting userID
        NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *user_id = [userAr lastObject];

        if(user_id){
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
        }
        
        if(accessToken){
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"VKAccessToken"];
            //[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"VKAccessTokenDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self sendSuccessWithMessage:@"Login fine"];
     
            vkRequst = [[MITRequest alloc]initFromNSUserDefaults];
        }
        

        NSLog(@"VKAccessToken = %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"]);
        NSLog(@"VKAccessUserId = %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessUserId"]);
        
        webView.hidden = YES;
        logOutButton.hidden = NO;
        //Go to next screen AlbumList
        [self performSegueWithIdentifier:@"toAlbumList" sender:self];
        
    } else if ([webView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"Error: %@", webView.request.URL.absoluteString);
        webView.hidden = YES;
    }
    
    
    
}
//logOut request
-(void)logOutRequest{
    // Delate all cookie
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessToken"];
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessTokenDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSLog(@"VKAccessToken = %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"]);
        NSLog(@"VKAccessUserId = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);
        
        
        [self sendSuccessWithMessage:@"You logout fine!"];
    
}
- (void) sendFailedWithError:(NSString *)error {
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                          message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlertView show];
    
}

- (void) sendSuccessWithMessage:(NSString *)message {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Successfully!"
                                                          message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlertView show];
    
}



@end
