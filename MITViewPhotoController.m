//
//  MITViewPhotoControllerViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITViewPhotoController.h"

@interface MITViewPhotoController ()

@end

@implementation MITViewPhotoController

@synthesize photoView, currentPhoto, isLoading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = currentPhoto.title;
    [isLoading startAnimating];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    NSString* link;
    //find link to biggest picture
    if (currentPhoto.src_xxbig != nil) {
        link = currentPhoto.src_xxbig;
    }else if (currentPhoto.src_xbig != nil){
        link = currentPhoto.src_xbig;
    }else if (currentPhoto.src_big != nil){
        link = currentPhoto.src_big;
    }
    //loading image and show it in full screen
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.photoView.image = [UIImage imageWithData:data];
        [isLoading stopAnimating];
        isLoading.hidden = YES;
    }];
    
    //[self.photoView setImage:image];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
