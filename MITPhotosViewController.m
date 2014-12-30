//
//  MITPhotosViewControlerViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#define VKQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "MITPhotosViewController.h"
#import "MITViewPhotoController.h"
#import "MITPhotoCell.h"
@interface MITPhotosViewController ()

@end

@implementation MITPhotosViewController

@synthesize currentAlbum;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = currentAlbum.title;

    //set cell and row height
    self.tableView.rowHeight =150;
    
}

- (void)reloadArray{
    //NSLog(@"DataReloaded");
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPhotoViewer"])
    {
        
        MITViewPhotoController* vpc = [segue destinationViewController];
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        MITPhoto* currentPhoto = [[currentAlbum photos] objectAtIndex:[path row]];
        [vpc setCurrentPhoto:currentPhoto];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentAlbum.photos count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    MITPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //customized cell inserting biggest image and indicator
    MITPhoto* photo = [[currentAlbum photos] objectAtIndex:indexPath.row];
    
    [photoCell.photoIndicatorA startAnimating];

    if ( photo.thumbnail == nil ){
        dispatch_async(VKQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:photo.thumbnailURL];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MITPhotoCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            [photo setThumbnail:image];
                        [photoCell.photoIndicatorA stopAnimating];
                        photoCell.photoIndicatorA.hidden =YES;
                        updateCell.photoThumbnail.image = image;
                    });
                }
            }
        });
        
    }else{
        photoCell.photoThumbnail.image = photo.thumbnail;
        //when thumbnail loaded turn of activity indicator
        [photoCell.photoIndicatorA stopAnimating];
        photoCell.photoIndicatorA.hidden =YES;
    }
    
    return photoCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
