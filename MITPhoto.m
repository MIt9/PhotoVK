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

//init with all vars
-(id) initWithTitle:(NSString *)_title Pid:(NSNumber*)_pid Width:(NSNumber*)_width Height:(NSNumber*)_height Src:(NSString *)_src Src_big:(NSString *)_src_big Src_xbig:(NSString *)_src_xbig Src_xxbig:(NSString *)_src_xxbig {
    
    self = [super initWithTitle:_title thumbnailURL:_src_big];
    self.pid = _pid;
    self.width = _width;
    self.height = _height;
    self.src = _src;
    self.src_big = _src_big;
    self.src_xbig = _src_xbig;
    self.src_xxbig = _src_xxbig;
    self.linkTo = _src_big;
    return self;
}
@end
