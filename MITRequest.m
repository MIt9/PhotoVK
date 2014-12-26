//
//  MITRequest.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/24/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#define NO_REQUEST -1
#define GET_ALBUMS 1
#define GET_CURENT_PHOTO 2

#import "MITRequest.h"
#import "MITPhotoAlbom.h"
#import "StringBetween.h"

@implementation MITRequest
@synthesize albumId,albums;

int userID;
NSString* token;
NSString* secret =@"CGHzlBbVch1VG5bt6c98";
int curentRequest =NO_REQUEST;
NSMutableData* webData;
NSURLConnection *conection;
NSMutableArray *albums;
NSMutableArray *curentAlbum;


-(MITRequest *)initFromNSUserDefaults{
    
    token = [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"];
    userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"];
    [self getAlbumList];
    return self;
}


//http request with md5 info taken from http://vk.com/dev/api_nohttps
-(NSString *)md5LinkFormaterWithMetod:(NSString *)method{
    
    NSString* getRequest =[NSString stringWithFormat:@"/method/%@?uid=%i&access_token=%@",method, userID, token];
    NSString* requestString =[NSString stringWithFormat:@"%@%@",getRequest,secret];
    NSString* md5 = [NSString md5String:requestString]; 
    NSString* link =[NSString stringWithFormat:@"https://api.vk.com%@&sig=%@",getRequest,md5];
    
    return link;
}
-(NSString *)getLinkWithParameter:(NSString *)parametr withCovers:(BOOL) covers{
    NSString* metod;
    
    if (covers) {
        metod = [NSString stringWithFormat:@"%@?need_covers=1&",parametr];
    }else{
        metod = [NSString stringWithFormat:@"%@?",parametr];
    }
    NSString* getRequest =[NSString stringWithFormat:@"/method/%@uid=%i&access_token=%@",metod, userID, token];
    NSString* link =[NSString stringWithFormat:@"https://api.vk.com%@",getRequest];
    return link;
}
//getAlbumList
-(void)getAlbumList{
    
    [self getVKJSONList:GET_ALBUMS];
   
}

-(void)getVKJSONList:(int)param{
    
    NSString * parametr;
    switch (param) {
        case GET_ALBUMS:
            curentRequest = GET_ALBUMS;
            albums = [[NSMutableArray alloc]init];
            parametr = @"photos.getAlbums";
            break;
        case GET_CURENT_PHOTO:
            curentRequest = GET_CURENT_PHOTO;
            parametr = @"photos.getAlbums";
            break;
        default:
            NSLog(@"Unknown param");
            return;
            break;
    }

    NSString *link = [self getLinkWithParameter:parametr withCovers:YES];
    NSLog(@"%@",link);
//    NSURL *url = [NSURL URLWithString:link];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    
    // send the async request (note that the completion block will be called on the main thread)
    //
    // note: using the block-based "sendAsynchronousRequest" is preferred, and useful for
    // small data transfers that are likely to succeed. If you doing large data transfers,
    // consider using the NSURLConnectionDelegate-based APIs.
    //
    [NSURLConnection sendAsynchronousRequest:request
     // the NSOperationQueue upon which the handler block will be dispatched:
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // back on the main thread, check for errors, if no errors start the parsing
                               //
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               
                               // here we check for any returned NSError from the server, "and" we also check for any http response errors
                               if (error != nil) {
                                  // NSLog(@"%@",error);
                                   [self handleError:error];
                               }
                               else {
                                   // check for any response errors
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if ((([httpResponse statusCode]/100) == 2)) {
                                       
                                       // Update the UI and start parsing the data,
                                       // Spawn an NSOperation to parse the earthquake data so that the UI is not
                                       // blocked while the application parses the XML data.
                                       //
                                       NSDictionary* allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       
                                       NSArray* responseArray = [allData objectForKey:@"response"];
                                       for (NSDictionary* diction in responseArray) {
                                           NSString* title = [diction objectForKey:@"title"];
                                           MITPhotoAlbom* cAlbum =[[MITPhotoAlbom alloc]init];
                                           cAlbum.title = title;
                                           [albums addObject:cAlbum];
                                           
                                       }
                                       NSLog(@"after all %@",albums);
                                       [[NSNotificationCenter defaultCenter]
                                        postNotificationName:@"AlbumIsLoading"
                                        object:albumId];
                                   }
                                   else {
                                       NSString *errorString =
                                       NSLocalizedString(@"HTTP Error", @"Error message displayed when receving a connection error.");
                                       NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorString};
                                       NSError *reportError = [NSError errorWithDomain:@"HTTP"
                                                                                  code:[httpResponse statusCode]
                                                                              userInfo:userInfo];
                                       [self handleError:reportError];
                                   }
                               }
                           }];
    
//    if(conn){
//        NSLog(@"connect is live");
//    }
}
- (void)handleError:(NSError *)error {
    
    NSString *errorMessage = [error localizedDescription];
    NSString *alertTitle = NSLocalizedString(@"Error", @"Title for alert displayed when download or parse error occurs.");
    NSString *okTitle = NSLocalizedString(@"OK ", @"OK Title for alert displayed when download or parse error occurs.");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:errorMessage delegate:nil cancelButtonTitle:okTitle otherButtonTitles:nil];
    [alertView show];
}

@end
