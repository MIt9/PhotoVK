//
//  MITThumbnail.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/26/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITThumbnail : NSObject{
    UIImage* m_thumbnail;
}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSURL* thumbnailURL;
@property (nonatomic, readonly) UIImage* thumbnail;
@property (nonatomic, strong) NSString* linkTo;

-(id) initWithTitle:(NSString*)title;
-(id) initWithTitle:(NSString *)title thumbnailURL:(NSString*)thumbnailURL;

-(void) loadThumbnail;

@end
