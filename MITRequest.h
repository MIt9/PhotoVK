//
//  MITRequest.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/24/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringBetween.h"

@interface MITRequest : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property(nonatomic) int userID;
@property(nonatomic, strong) NSString* token;

-(MITRequest *)initWithUserID:(int) userID andToken:(NSString*)token;
-(MITRequest *)initFromNSUserDefaults;
-(NSString *)md5LinkFormaterWithMetod:(NSString *)method;
-(NSString *)getLinkWithParameter:(NSString *)parametr;
-(void)getAlbumList;
@end
