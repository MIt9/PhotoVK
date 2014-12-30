//
//  MITThumbnail.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/26/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITThumbnail.h"

@implementation MITThumbnail

@synthesize title, thumbnailURL, linkTo, thumbnail;


-(id) initWithTitle:(NSString*)_title {
    return [self initWithTitle:_title thumbnailURL:nil];
}

-(id) initWithTitle:(NSString *)_title thumbnailURL:(NSString*)_thumbnailURL {
    self = [super init];
    self.title = _title;
    self.thumbnailURL = [NSURL URLWithString:[_thumbnailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return self;
}


@end
