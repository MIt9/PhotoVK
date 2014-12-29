//
//  MITRequest.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/24/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#define NO_REQUEST -1
#define GET_ALBUMS 1
#define GET_CURRENT_PHOTO 2
#define GET_CURRENT_ALBUM 3

#define ALL_ALBUMS @"photos.getAlbums"
#define CURRENT_ALBUM @"photos.get"
#define NEED_COVERS @"need_covers=1"
#define SECRET @"CGHzlBbVch1VG5bt6c98"

#import "MITRequest.h"
#import "MITPhotoAlbum.h"
#import "StringBetween.h"

@implementation MITRequest
@synthesize albumsTableId,albums;

int userID;
NSString* token;
//NSString* secret =@"CGHzlBbVch1VG5bt6c98";
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
    
    NSString* getRequest =[NSString stringWithFormat:@"/method/%@?uid=%id&access_token=%@",method, userID, token];
    NSString* requestString =[NSString stringWithFormat:@"%@%@",getRequest,SECRET];
    NSString* md5 = [NSString md5String:requestString]; 
    NSString* link =[NSString stringWithFormat:@"https://api.vk.com%@&sig=%@",getRequest,md5];
    
    return link;
}
//Formatting string with one parameter and cover
-(NSString *)getLinkWithParameter:(NSString *)parametr withCovers:(BOOL) covers{
    NSString* method;
    
    if (covers) {
        method = [NSString stringWithFormat:@"%@?need_covers=1&",parametr];
    }else{
        method = [NSString stringWithFormat:@"%@?",parametr];
    }
    NSString* getRequest =[NSString stringWithFormat:@"/method/%@uid=%i&access_token=%@",method, userID, token];
    NSString* link =[NSString stringWithFormat:@"https://api.vk.com%@",getRequest];
    return link;
}

//Formatting link with parameter and three methods
-(NSString *)getLinkWithParameter:(NSString *)parametr methodOne:(NSString *)mOne methodTwo:(NSString *)mTwo methodThree:(NSString *)mThree{
    NSMutableString* base = [NSMutableString stringWithString:@"https://api.vk.com/method/"];
    [base appendString:parametr];
    [base appendString:@"?"];
    if (mOne != nil) {
        [base appendString:mOne];
        [base appendString:@"&"];
    }
    if (mTwo != nil) {
        [base appendString:mTwo];
        [base appendString:@"&"];
    }
    if (mThree != nil) {
        [base appendString:mThree];
        [base appendString:@"&"];
    }
    
    NSString* uid = [NSString stringWithFormat:@"uid=%i&",userID];
    [base appendString:uid];
    NSString* aToken = [NSString stringWithFormat:@"access_token=%@",token];
    [base appendString:aToken];
    return [NSString stringWithFormat:@"%@",base];
}

// Get link for all albums
-(void)getAlbumList{

    [self getVKJSONList:GET_ALBUMS otherInfo:nil];

}

// Get current album with its id (now not used)
-(void)getCurrentAlbum:(NSString *)idAlbum{
    [self getVKJSONList:GET_CURRENT_ALBUM otherInfo:idAlbum];
}

// Make request and parsing info in main thread
-(void)getVKJSONList:(int)param otherInfo:(NSString *)info{
    
    NSString* tmp;
    NSString *link;
    switch (param) {
        case GET_ALBUMS:
            curentRequest = GET_ALBUMS;
            albums = [[NSMutableArray alloc]init];
            link = [self getLinkWithParameter:ALL_ALBUMS
                                    methodOne:NEED_COVERS
                                    methodTwo:nil
                                  methodThree:nil];
            break;
        case GET_CURRENT_ALBUM:
            curentRequest = GET_CURRENT_ALBUM;
            tmp = [NSString stringWithFormat:@"album_id=%@",info] ;
            link = [self getLinkWithParameter:CURRENT_ALBUM
                                    methodOne:NEED_COVERS
                                    methodTwo:tmp
                                  methodThree:nil];
            break;
        default:
            NSLog(@"Unknown param");
            return;
            break;
    }

    
    NSLog(@"%@",link);

    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    
    // send the async request (note that the completion block will be called on the main thread)
    [NSURLConnection sendAsynchronousRequest:request
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
                                       NSDictionary* allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       if (curentRequest == GET_ALBUMS) {
                                           [self albumsParsing:allData];
                                           curentRequest = NO_REQUEST;
                                       }
                                   
                                                                         
                                   }else {
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

}
//Parsing request
-(void)albumsParsing:(NSDictionary*) allData{
    
    NSArray* responseArray = [allData objectForKey:@"response"];
    for (NSDictionary* diction in responseArray) {
        NSNumber* aid = [diction objectForKey:@"aid"];
        NSString* title = [diction objectForKey:@"title"];
        NSString* linkThumbSrc = [diction objectForKey:@"thumb_src"];
        //formatting long for load photos to array
        NSString* link = [self getLinkWithParameter:CURRENT_ALBUM
                                          methodOne:NEED_COVERS
                                          methodTwo:[NSString stringWithFormat:@"album_id=%@",aid]
                                        methodThree:nil];
                          
        MITPhotoAlbum* cAlbum =[[MITPhotoAlbum alloc]initWithTitle:title
                                                      thumbnailURL:linkThumbSrc
                                                               aid:aid
                                           requestLinkforPhotoList:link];
        
        //loading current album photos array in background
        [cAlbum loadPhotosArray];
        //add to albums array
        [albums addObject:cAlbum];
        
        
    }
    NSLog(@"after all %@",albums);
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"AlbumIsLoading"
//     object:albumsTableId];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AlbumIsLoaded"
     object:self];

}
- (void)handleError:(NSError *)error {
    
    NSString *errorMessage = [error localizedDescription];
    NSString *alertTitle = NSLocalizedString(@"Error", @"Title for alert displayed when download or parse error occurs.");
    NSString *okTitle = NSLocalizedString(@"OK ", @"OK Title for alert displayed when download or parse error occurs.");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:okTitle
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
