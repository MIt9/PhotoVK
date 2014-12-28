//
//  MITPhoto.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/28/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITPhoto.h"

@implementation MITPhoto

@synthesize pid, width, height, src, src_big, src_xbig, src_xxbig;


-(id) initWithTitle:(NSString *)title Pid:(NSNumber*)pid Width:(NSNumber*)width Height:(NSNumber*)height Src:(NSString *)src Src_big:(NSString *)src_big Src_xbig:(NSString *)src_xbig Src_xxbig:(NSString *)src_xxbig {
    
    self = [super initWithTitle:title thumbnailURL:src];
    self.pid = pid;
    self.width = width;
    self.height = height;
    self.src = src;
    self.src_big = src_big;
    self.src_xbig = src_xbig;
    self.src_xxbig = src_xxbig;
    self.linkTo = src_big;
    return self;
}
@end
