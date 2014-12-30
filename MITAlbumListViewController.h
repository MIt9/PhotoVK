//
//  AlbumListViewController.h
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/21/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITPhotoAlbum.h"

@interface MITAlbumListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* albumList;
@end
