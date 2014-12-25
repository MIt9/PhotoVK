//
//  NSString+StringBetween.h
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/20/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (StringBetween)
- (NSString *)getStringBetweenString:(NSString *)first andString:(NSString *)second;
+ (NSString *) md5String:(NSString*)concat;
@end
