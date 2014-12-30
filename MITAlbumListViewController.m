//
//  AlbumListViewController.m
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/21/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#define VKQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "MITAlbumListViewController.h"
#import "MITPhotoAlbum.h"
#import "MITAlbumCell.h"
#import "MITPhotosViewController.h"


@interface MITAlbumListViewController ()

@end

@implementation MITAlbumListViewController
@synthesize albumList;

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
    
    self.tableView.rowHeight =100;

}


// listen notification. if find album were changed thumbnail and reload it
//-(void) imageLoadedNotification:(NSNotification*)notification {
//     if ( notification.object == nil )
//        return;
//    MITPhotoAlbum* album = (MITPhotoAlbum*)notification.object;
//    __block NSIndexPath* indexPath = nil;
//    [albumList
//     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         if ( obj == album ) {
//             indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
//             *stop = YES;
//         }
//     }];
//    if ( indexPath != nil ) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        });
//
//    }
//}

//reload all table
- (void)reloadArray{
    //NSLog(@"DataReloaded");
    [self.tableView reloadData];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toSelectedAlbum"])
    {

        MITPhotosViewController* selectedAlbum = [segue destinationViewController];
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        MITPhotoAlbum* currentAlbum = [albumList objectAtIndex:[path row]];
        //check if current album have array with photo. If not loaded there will load in main thread
        if ([currentAlbum.photos count] <= 0) {
            [currentAlbum loadPhotosArray];
        }
        //send current album to next screen
        [selectedAlbum setCurrentAlbum:currentAlbum];

        
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    return [albumList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumCell";
    MITAlbumCell *albumCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    // Configure the cell...
    if (albumCell == nil) {
        albumCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //make custom cell with bigger image, activity indicator and label for two line
    MITPhotoAlbum * currentAlbom = [albumList objectAtIndex:indexPath.row];

    albumCell.albumTitleLabel.text = currentAlbom.title;
    

    [albumCell.albumIndicatorA startAnimating];


    //check if we have not thumbnail loaded and if not, will load it
    //    if ( currentAlbom.thumbnail == nil ){
    //        [currentAlbom loadThumbnail];
    //
    //    }else{
    //        albumCell.albumThumbnailView.image = currentAlbom.thumbnail;
    //        //when thumbnail loaded turn of activity indicator
    //        [albumCell.albumIndicatorA stopAnimating];
    //        albumCell.albumIndicatorA.hidden =YES;
    //    }
    if ( currentAlbom.thumbnail == nil ){
        dispatch_async(VKQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:currentAlbom.thumbnailURL];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MITAlbumCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            [currentAlbom setThumbnail:image];
                            [albumCell.albumIndicatorA stopAnimating];
                            albumCell.albumIndicatorA.hidden =YES;
                            updateCell.albumThumbnailView.image = image;
                    });
                }
            }
        });
        
    }else{
        albumCell.albumThumbnailView.image = currentAlbom.thumbnail;
        //when thumbnail loaded turn of activity indicator
        [albumCell.albumIndicatorA stopAnimating];
        albumCell.albumIndicatorA.hidden =YES;
    }

    return albumCell;
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
