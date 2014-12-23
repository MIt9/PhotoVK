//
//  MITViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/22/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITViewController.h"
#import "StringBetween.h"

@interface MITViewController ()

@end

@implementation MITViewController

@synthesize authView, indicator, secret, isAuth;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    authView.hidden = YES;
    indicator.hidden = YES;
    isAuth = YES;
    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)linkFormAndRequestWithAppId:(NSString *)appID andScope:(NSString *)scope{
    NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=%@&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", appID, scope];
    NSURL *url = [NSURL URLWithString:authLink];
    NSURLRequest *authRequest = [[NSURLRequest alloc] initWithURL:url];
    
    
    [authView loadRequest:authRequest];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
    indicator.hidden = YES;
    if ([authView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        
        
        NSString *accessToken = [authView.request.URL.absoluteString getStringBetweenString:@"access_token=" andString:@"&"];
        
        // Получаем id пользователя, пригодится нам позднее
        NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        
        NSString *user_id = [userAr lastObject];
        NSLog(@"User id: %@", user_id);
        if(user_id){
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
        }
        
        if(accessToken){
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"VKAccessToken"];
            // Сохраняем дату получения токена. Параметр expires_in=86400 в ответе ВКонтакта, говорит сколько будет действовать токен.
            // В данном случае, это для примера, мы можем проверять позднее истек ли токен или нет
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"VKAccessTokenDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //Go to next screen AlbumList
            
            [self sendSuccessWithMessage:@"Login fine"];
            
            [self performSegueWithIdentifier:@"toAlbumList" sender:self];
        }
        
        NSLog(@"vkWebView response: %@",[[[webView request] URL] absoluteString]);
        
        NSLog(@"VKAccessToken = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessToken"]);
        NSLog(@"VKAccessUserId = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);
        NSLog(@"VKAccessTokenDate = %@", accessToken);
        
        authView.hidden = YES;
    } else if ([authView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"Error: %@", authView.request.URL.absoluteString);
        authView.hidden = YES;
    }
    
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toAlbumList"])
    {
        // AlbumListViewController *album = [segue destinationViewController];
        
    }
}
- (void)isLogin{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessToken"] == 0){
        isAuth = NO;
    }
}

- (IBAction)login:(id)sender {
    [self isLogin];
    
    if (isAuth == NO) {
        indicator.hidden = NO;
        [indicator startAnimating];
        [self linkFormAndRequestWithAppId:@"4683729" andScope:@"photos"];
        authView.hidden = NO;
    }else{
        [self performSegueWithIdentifier:@"toAlbumList" sender:self];
    }
    //    authView.hidden = NO;
    //    [[VKConnector sharedInstance] startWithAppID:@"4683729"
    //                                      permissons:@[@"photo"]
    //                                         webView:authView
    //                                        delegate:self];
}

- (IBAction)logOut:(id)sender {
    // Запрос на logout
    NSString *logout = @"http://api.vk.com/oauth/logout";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logout]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(responseData){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        //[[JSONDecoder decoder] parseJSONData:responseData];
        NSLog(@"Logout: %@", dict);
        
        // Приложение больше не авторизовано, можно удалить данные
        isAuth = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessTokenDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSLog(@"VKAccessToken = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessToken"]);
        NSLog(@"VKAccessUserId = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);
        NSLog(@"VKAccessTokenDate = %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]);
        
        [self sendSuccessWithMessage:@"Выход произведен успешно!"];
    }
}
- (void) sendFailedWithError:(NSString *)error {
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Ошибка!"
                                                          message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlertView show];
    
}

- (void) sendSuccessWithMessage:(NSString *)message {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Успешно!"
                                                          message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlertView show];
    
}


@end
