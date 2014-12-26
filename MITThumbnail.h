//
//  MITThumbnail.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/26/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MITThumbnail : NSObject{
    UIImage* m_image;
}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSURL* thumbnailURL;
@property (nonatomic, readonly) UIImage* image;

-(id) initWithName:(NSString*)title;
-(id) initWithName:(NSString *)title thumbnailURL:(NSURL*)thumbnailURL;

-(void) loadThumbnail;

@end
