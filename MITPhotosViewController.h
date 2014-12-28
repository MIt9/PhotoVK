//
//  MITPhotosViewControlerViewController.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITRequest.h"
#import "MITPhotoAlbum.h"
#import "MITPhoto.h"

@interface MITPhotosViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MITRequest* vkRequest;
@property (nonatomic,strong) MITPhotoAlbum* curentAlbum;

@end
