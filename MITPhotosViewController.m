//
//  MITPhotosViewControlerViewController.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/27/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITPhotosViewController.h"
#import "MITViewPhotoController.h"

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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoadedNotification:)
                                                 name:@"imageLoaded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadArray)
                                                 name:@"baseLoaded"
                                               object:nil];
    //set cell and row height
    self.tableView.rowHeight =150;
    
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
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

// listen notification. if find photo were changed thumbnail and reload it
-(void) imageLoadedNotification:(NSNotification*)notification {
    if ( notification.object == nil )
        return;
    MITPhoto* photo = (MITPhoto*)notification.object;
    __block NSIndexPath* indexPath = nil;
    [[currentAlbum photos]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ( obj == photo ) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //customized cell inserting biggest image and indicator
    MITPhoto* photo = [[currentAlbum photos] objectAtIndex:indexPath.row];
    UIImageView *photoPreview = (UIImageView *)[cell viewWithTag:100];
    UIActivityIndicatorView *actInd = (UIActivityIndicatorView *) [cell viewWithTag:101];
    photoPreview.contentMode = UIViewContentModeScaleAspectFit;
    [actInd startAnimating];
    if ( photo.thumbnail == nil ){
       [photo loadThumbnail];
        
    }else{
        photoPreview.image = photo.thumbnail;
        [actInd stopAnimating];
        actInd.hidden =YES;
    }
    
    
    
    
//    photoPreview.image = [photo imageByCropping:photo.thumbnail toRect:CGRectMake(85, 83, 285, 80)];
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
