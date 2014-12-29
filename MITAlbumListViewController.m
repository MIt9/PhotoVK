//
//  AlbumListViewController.m
//  PhotoViewerVK
//
//  Created by dmitii bilukha on 12/21/14.
//  Copyright (c) 2014 Dmitii Bilukha. All rights reserved.
//

#import "MITAlbumListViewController.h"
#import "MITPhotoAlbum.h"
#import "MITPhotosViewController.h"
@interface MITAlbumListViewController ()

@end

@implementation MITAlbumListViewController
@synthesize vkRequest;

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
    [vkRequest setAlbumsTableId:self];
    self.tableView.rowHeight =100;
    //add observer hwo listen did album array loaded
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadArray)
                                                 name:@"AlbumIsLoaded"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoadedNotification:)
                                                 name:@"imageLoaded" object:nil];
    

}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

// listen notification. if find album were changed thumbnail and reload it
-(void) imageLoadedNotification:(NSNotification*)notification {
     if ( notification.object == nil )
        return;
    MITPhotoAlbum* album = (MITPhotoAlbum*)notification.object;
    __block NSIndexPath* indexPath = nil;
    [[vkRequest albums]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ( obj == album ) {
             indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
             *stop = YES;
         }
     }];
    if ( indexPath != nil ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });

    }
}

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
        MITPhotoAlbum* currentAlbum = [[vkRequest albums] objectAtIndex:[path row]];
        //check if current album have array with photo. If not loaded there will load in main thread
        if ([currentAlbum.photos count] <= 0) {
            [currentAlbum loadPhotosArrayInBackground];
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

    return [vkRequest.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //make custom cell with bigger image, activity indicator and label for two line
    MITPhotoAlbum * currentAlbom = [[vkRequest albums] objectAtIndex:indexPath.row];
    UIImageView *albumPreview = (UIImageView *)[cell viewWithTag:105];
    UIActivityIndicatorView *actInd = (UIActivityIndicatorView *) [cell viewWithTag:106];
    UILabel *cellTitle = (UILabel *) [cell viewWithTag:107];
    cellTitle.text= currentAlbom.title;
    albumPreview.contentMode = UIViewContentModeScaleAspectFit;
    [actInd startAnimating];
    //check if we have not thumbnail loaded and if not, will load it
    if ( currentAlbom.thumbnail == nil ){
        [currentAlbom loadThumbnail];
        
    }else{
        albumPreview.image = currentAlbom.thumbnail;
        //when thumbnail loaded turn of activity indicator
        [actInd stopAnimating];
        actInd.hidden =YES;
    }
    return cell;
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
