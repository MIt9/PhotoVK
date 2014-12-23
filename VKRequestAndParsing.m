//
//  VKRequestAndParsing.m
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/21/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#import "VKRequestAndParsing.h"

@implementation VKRequestAndParsing

-(void)getAlbumRequestWithUserId:(NSString *)userId andToken:(NSString *)token{
    NSString *link = [NSString stringWithFormat:@"http://api.vk.com/method/photos.getAlbums?uid=%@&access_token=%@", userId, token];
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(responseData){
        
    }
}
@end
