//
//  MITViewPhotoControllerViewController.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITPhoto.h"
@interface MITViewPhotoController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isLoading;
@property (nonatomic,strong) MITPhoto* currentPhoto;
@end
