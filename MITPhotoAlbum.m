//
//  MITPhotoAlbom.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/24/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITPhotoAlbum.h"

@implementation MITPhotoAlbum

@synthesize aid, photos;

-(id) initWithTitle:(NSString *)title thumbnailURL:(NSString*)thumbnailURL aid:(NSNumber*)_aid requestLinkforPhotoList:(NSString*)link{
    
    self = [super initWithTitle:title thumbnailURL:thumbnailURL];
    self.aid = _aid;
    self.linkTo = link;
    
//    [self loadPhotoList:observer requestLinkforPhotoList:link];
    return self;
}
-(void) loadPhotosArray{
    // запускам загружаться изображение асинхронно
    [self performSelectorInBackground:@selector(loadPhotosArrayInBackground)
                           withObject:nil];
}

-(void) loadPhotosArrayInBackground {
    
    
    // готовим и выполняем запрос
    NSLog(@"link to %@",self.linkTo);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkTo]];
    NSError* error = nil;
    NSData* data =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:nil error:&error];
    
    if ( error == nil ) {
        //изображение загрузилось
        photos = [[NSMutableArray alloc]init];
        NSDictionary* allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray* responseArray = [allData objectForKey:@"response"];
        //NSLog(@"responseArray %@",responseArray);
        for (NSDictionary* diction in responseArray) {
            NSNumber* pid = [diction objectForKey:@"pid"];
            NSString* title = [diction objectForKey:@"text"];
            NSNumber* height = [diction objectForKey:@"height"];
            NSNumber* width = [diction objectForKey:@"width"];
            NSString* src = [diction objectForKey:@"src"];
            NSString* src_big = [diction objectForKey:@"src_big"];
            NSString* src_xbig = [diction objectForKey:@"src_xbig"];
            NSString* src_xxbig = [diction objectForKey:@"src_xxbig"];
            MITPhoto* photo = [[MITPhoto alloc]initWithTitle:title Pid:pid Width:width Height:height Src:src Src_big:src_big Src_xbig:src_xbig Src_xxbig:src_xxbig];
            [photos addObject:photo];
            
            

        }
        //m_thumbnail = [UIImage imageWithData:data] ;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"baseLoadet"
         object:self];

    }
    
    
}
@end
