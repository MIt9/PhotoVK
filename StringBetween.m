//
//  NSString+StringBetween.m
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/20/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#define USER_ID [[NSUserDefaults standardUserDefaults] integerForKey:@"VKAccessUserId"]
#define TOKEN [[NSUserDefaults standardUserDefaults] stringForKey:@"VKAccessToken"]

#define ALL_ALBUMS @"photos.getAlbums"
#define CURRENT_ALBUM @"photos.get"
#define NEED_COVERS @"need_covers=1"

#import "StringBetween.h"

@implementation NSString (StringBetween)
//find string between two other string
- (NSString *)getStringBetweenString:(NSString *)first andString:(NSString *)second {
    NSRange rangeofFirst = [(NSString *)self rangeOfString:first];
    NSRange rangeOfSecond = [(NSString *)self rangeOfString:second];
    if ((rangeofFirst.length == 0) || (rangeOfSecond.length == 0)) {
        return nil;
    }
    NSString *result = [[(NSString *)self substringFromIndex:rangeofFirst.location+rangeofFirst.length]
                        substringToIndex:
                        [[(NSString *)self substringFromIndex:rangeofFirst.location+rangeofFirst.length] rangeOfString:second].location];
    return result;
}
//converting string to md5
+ (NSString *) md5String:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//Formatting link with parameter and three methods
-(NSString *)getLinkWithParameter:(NSString *)parametr methodOne:(NSString *)mOne methodTwo:(NSString *)mTwo methodThree:(NSString *)mThree{
    
    if (USER_ID == 0 && TOKEN == nil) {
        return nil;
    }else{
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
        
        NSString* uid = [NSString stringWithFormat:@"uid=%i&",USER_ID];
        [base appendString:uid];
        NSString* aToken = [NSString stringWithFormat:@"access_token=%@",TOKEN];
        [base appendString:aToken];
        return [NSString stringWithFormat:@"%@",base];
    }
    
}
// Get link for all albums
-(NSString*)getAlbumList{
    NSString* link = [self getLinkWithParameter:ALL_ALBUMS
                                      methodOne:NEED_COVERS
                                      methodTwo:nil
                                    methodThree:nil];
    return link;

}
-(NSString*)getCurrentAlbum:(NSString *)idAlbum{
    
    NSString* link = [self getLinkWithParameter:CURRENT_ALBUM
                                      methodOne:NEED_COVERS
                                      methodTwo:[NSString stringWithFormat:@"album_id=%@",idAlbum]
                                    methodThree:nil];
    return link;
}
@end
