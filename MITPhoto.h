//
//  MITPhoto.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/28/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITThumbnail.h"

@interface MITPhoto : MITThumbnail

@property (nonatomic, strong) NSNumber* pid;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, strong) NSString* src;
@property (nonatomic, strong) NSString* src_big;
@property (nonatomic, strong) NSString* src_xbig;
@property (nonatomic, strong) NSString* src_xxbig;

-(id) initWithTitle:(NSString *)title Pid:(NSNumber*)pid Width:(NSNumber*)width Height:(NSNumber*)height Src:(NSString *)src Src_big:(NSString *)src_big Src_xbig:(NSString *)src_xbig Src_xxbig:(NSString *)src_xxbig;
@end
