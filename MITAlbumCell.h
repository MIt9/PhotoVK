//
//  MITAlbumCell.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/30/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *albumIndicatorA;
@property (weak, nonatomic) IBOutlet UIImageView *albumThumbnailView;

@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;

@end
