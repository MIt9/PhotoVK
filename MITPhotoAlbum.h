//
//  MITPhotoAlbom.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/24/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITThumbnail.h"
#import "MITPhoto.h"
@interface MITPhotoAlbum : MITThumbnail

@property (nonatomic,strong)NSString* aid;
@property (nonatomic,strong)NSMutableArray* photos;
-(id) initWithTitle:(NSString *)title thumbnailURL:(NSString*)thumbnailURL aid:(NSString*)aid  requestLinkforPhotoList:(NSString*)link;
-(void) loadPhotosArray;

@end
