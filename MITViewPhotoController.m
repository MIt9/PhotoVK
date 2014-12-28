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

@synthesize photoView, currentPhoto;


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
    NSString *imageUrl = [currentPhoto linkTo];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.photoView.image = [UIImage imageWithData:data];
    }];
    
    //[self.photoView setImage:image];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
