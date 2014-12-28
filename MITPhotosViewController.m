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

@synthesize vkRequest, curentAlbum;

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
    self.title = curentAlbum.title;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoadedNotification:)
                                                 name:@"imageLoadet" object:nil];
    
}
- (void)viewDidUnload
{
    // отменяем "прослушку"
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) imageLoadedNotification:(NSNotification*)notification {
    // если не пришла страна,
    // для которой загрузился флаг - ничего не делаем
    if ( notification.object == nil )
        return;
    
    // достаем страну, для которой загрузился флаг
    MITPhoto* photo = (MITPhoto*)notification.object;
    
    // помечаем переменную, чтобы мы ее могли изменить в блоке
    __block NSIndexPath* indexPath = nil;
    
    // перебираем массив со странами и ищем ту,
    // для которой загрузился флаг
    [[curentAlbum photos]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         // здесь мы сравниваем адрес объекта!
         // т.к. они берутся из одной коллекции - этого достаточно
         if ( obj == photo ) {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPhotoViewer"])
    {
        
        MITViewPhotoController* vpc = [segue destinationViewController];
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        MITPhoto* currentPhoto = [[curentAlbum photos] objectAtIndex:[path row]];
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
    return [curentAlbum.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MITPhoto* photo = [[curentAlbum photos] objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[photo title]];
    
    if ( photo.thumbnail == nil )
        [photo loadThumbnail];
    
    // назначим картинку
    cell.imageView.image = photo.thumbnail;
    
    
    
    
    
//    NSData *data = [NSData dataWithContentsOfURL:photo.thumbnailURL];
//    UIImage* image = [[UIImage alloc] initWithData:data];
    
//    cell.imageView.image = image;
    // Configure the cell...
    
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
