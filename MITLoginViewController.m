//
//  MITViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/22/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#define APP_ID @"4683729"
#define SCOPE  @"photos"

#import "MITLoginViewController.h"
#import "MITAlbumListViewController.h"
#import "MITPhotoAlbum.h"

@interface MITLoginViewController ()

@end

@implementation MITLoginViewController

@synthesize authView, indicator, secret, logOutButton;

NSMutableArray *albumList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBG.png"]];
    authView.hidden = YES;
    indicator.hidden = YES;
}

// making http request for authorization
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

    


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toAlbumList"])
    {
        MITAlbumListViewController* alvc = [segue destinationViewController];
        [alvc setAlbumList:albumList];
        
        
    }
}



//Action on pressing button login
- (IBAction)login:(id)sender {
   

        indicator.hidden = NO;
        [indicator startAnimating];
        [self linkFormAndRequestWithAppId:APP_ID andScope:SCOPE];
        authView.hidden = NO;

    NSLog(@"VKAccessToken = %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"]);
    NSLog(@"VKAccessUserId = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);

}

- (IBAction)logOut:(id)sender {
    [self logOutRequest];

    logOutButton.hidden = YES;
}

//make request for authorization. Save user Id and token to default
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
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            albumList = [self getAlbumList];
        }
        

        webView.hidden = YES;
        logOutButton.hidden = NO;
        //Go to next screen AlbumList
        
        [self performSegueWithIdentifier:@"toAlbumList" sender:self];
        
    
        
    } else if ([webView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"Error: %@", webView.request.URL.absoluteString);
        webView.hidden = YES;
    }
    
    
    
}
//logOut request. Delete all cookie and user defaults
-(void)logOutRequest{
    // Delate all cookie
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      
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

-(NSMutableArray *)getAlbumList{
    NSString* link = [[NSString alloc] getAlbumList];
    NSMutableArray* array;
    
    NSLog(@"link for  getAlbumList %@",link);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    NSError* error = nil;
    NSData* data =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:nil error:&error];
    
    if ( error == nil ) {
        //parsing
        array = [[NSMutableArray alloc]init];
        NSDictionary* allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray* responseArray = [allData objectForKey:@"response"];
        for (NSDictionary* diction in responseArray) {
            NSString* aid = [diction objectForKey:@"aid"];
            NSString* title = [diction objectForKey:@"title"];
            NSString* linkThumbSrc = [diction objectForKey:@"thumb_src"];
            //formatting long for load photos to array
            NSString* link = [[NSString alloc] getCurrentAlbum:aid];
            
            MITPhotoAlbum* cAlbum =[[MITPhotoAlbum alloc]initWithTitle:title
                                                          thumbnailURL:linkThumbSrc
                                                                   aid:aid
                                               requestLinkforPhotoList:link];
           
            [array addObject:cAlbum];
            
            
        }
        
        
    }
    return array;
}

@end
