//
//  AlbumListViewController.h
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/21/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITRequest.h"

@interface MITAlbumListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

@property (nonatomic, strong) MITRequest * vkRequest;
@end
