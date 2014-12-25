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
#import "StringBetween.h"

@implementation MITRequest

@synthesize userID, token;

NSString* secret =@"CGHzlBbVch1VG5bt6c98";
int curentRequest =NO_REQUEST;
NSMutableData* webData;
NSURLConnection *conection;
NSMutableArray *alboms;

-(MITRequest *)initWithUserID:(int) userID andToken:(NSString*)token{
    self.userID =userID;
    self.token = token;
    return self;
}
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    webData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [webData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSDictionary* allData = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSArray* responseArray = [allData objectForKey:@"response"];
    for (NSDictionary* diction in responseArray) {
        NSString* title = [diction objectForKey:@"title"];
        [alboms addObject:title];
    }
    NSLog(@"%@",alboms);

    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"ERORR : %@",error);
}


-(MITRequest *)initFromNSUserDefaults{
    
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"];
    self.userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"];
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
-(NSString *)getLinkWithParameter:(NSString *)parametr{
    NSString* getRequest =[NSString stringWithFormat:@"/method/%@?uid=%i&access_token=%@",parametr, userID, token];
    NSString* link =[NSString stringWithFormat:@"https://api.vk.com%@",getRequest];
    return link;
}
//getAlbumList
-(void)getAlbumList{
    [self getVKJSONList:GET_ALBUMS];
    alboms = [[NSMutableArray alloc]init];
   
}

-(void)getVKJSONList:(int)param{
    
    NSString * getRequest;
    switch (param) {
        case GET_ALBUMS:
            curentRequest = GET_ALBUMS;
            getRequest = @"photos.getAlbums";
            break;
        case GET_CURENT_PHOTO:
            curentRequest = GET_CURENT_PHOTO;
            getRequest = @"photos.getAlbums";
            break;
        default:
            NSLog(@"Unknown param");
            return;
            break;
    }

    NSString *link = [self getLinkWithParameter:getRequest];
    NSLog(@"%@",link);
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request  delegate:self];
   // NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(conn){
        NSLog(@"connect is live");
    }
}
@end