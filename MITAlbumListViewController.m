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
                                                 name:@"AlbumIsLoading"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoadedNotification:)
                                                 name:@"imageLoadet" object:nil];
    

}
- (void)viewDidUnload
{
    // отменяем "прослушку"
    [[NSNotificationCenter defaultCenter] removeObserver:vkRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

// "слушаем" notification
-(void) imageLoadedNotification:(NSNotification*)notification {
    // если не пришла страна,
    // для которой загрузился флаг - ничего не делаем
    if ( notification.object == nil )
        return;
    
    // достаем страну, для которой загрузился флаг
    MITPhotoAlbum* album = (MITPhotoAlbum*)notification.object;
    
    // помечаем переменную, чтобы мы ее могли изменить в блоке
    __block NSIndexPath* indexPath = nil;
    
    // перебираем массив со странами и ищем ту,
    // для которой загрузился флаг
    [[vkRequest albums]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         // здесь мы сравниваем адрес объекта!
         // т.к. они берутся из одной коллекции - этого достаточно
         if ( obj == album ) {
             // нашли! запомним положение в tableView
             indexPath
             = [NSIndexPath indexPathForRow:idx inSection:0];
             // остановим "перебор"
             *stop = YES;
         }
     }];
    
    // если нашли страну - обновим ячейку, в которой она показывается
    if ( indexPath != nil ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });

    }
}

- (void)reloadArray{
    NSLog(@"DataReloadet");
    [self.tableView reloadData];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toSelectedAlbum"])
    {

        MITPhotosViewController* selectedAlbum = [segue destinationViewController];
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        MITPhotoAlbum* currentAlbum = [[vkRequest albums] objectAtIndex:[path row]];
        if ([currentAlbum.photos count] <= 0) {
            [currentAlbum loadPhotosArrayInBackground];
        }
        [selectedAlbum setCurentAlbum:currentAlbum];
        [selectedAlbum setVkRequest:vkRequest];
        
        
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
    
    MITPhotoAlbum * currentAlbom = [[vkRequest albums] objectAtIndex:indexPath.row];
    UIImageView *albumPreview = (UIImageView *)[cell viewWithTag:105];
    UIActivityIndicatorView *actInd = (UIActivityIndicatorView *) [cell viewWithTag:106];
    UILabel *cellTitle = (UILabel *) [cell viewWithTag:107];
    cellTitle.text= currentAlbom.title;
    albumPreview.contentMode = UIViewContentModeScaleAspectFit;
    [actInd startAnimating];
    if ( currentAlbom.thumbnail == nil ){
        [currentAlbom loadThumbnail];
        
    }else{
        albumPreview.image = currentAlbom.thumbnail;
        [actInd stopAnimating];
        actInd.hidden =YES;
    }
//    MITPhotoAlbum * currentAlbom = [[vkRequest albums] objectAtIndex:indexPath.row];
//        
//        [cell.textLabel setText:[currentAlbom title]];
//    
//    if ( currentAlbom.thumbnail == nil )
//        [currentAlbom loadThumbnail];
//    
//    // назначим картинку
//    cell.imageView.image = currentAlbom.thumbnail;
//    
//
//    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
