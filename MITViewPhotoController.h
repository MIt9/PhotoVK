//
//  MITViewPhotoControllerViewController.h
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITPhoto.h"
@interface MITViewPhotoController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
//- (IBAction)pinching:(UIGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isLoading;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) MITPhoto* currentPhoto;
@end
