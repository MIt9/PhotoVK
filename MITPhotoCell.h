//
//  MITPhotoCell.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/30/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MITPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *photoIndicatorA;
@property (weak, nonatomic) IBOutlet UIImageView *photoThumbnail;

@end
