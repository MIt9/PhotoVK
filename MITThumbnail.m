//
//  MITThumbnail.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/26/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITThumbnail.h"

@implementation MITThumbnail

@synthesize title, thumbnailURL, linkTo;

-(UIImage*) thumbnail {
    return m_thumbnail;
}

-(id) initWithTitle:(NSString*)title {
    return [self initWithTitle:title thumbnailURL:nil];
}

-(id) initWithTitle:(NSString *)title thumbnailURL:(NSString*)thumbnailURL {
    self = [super init];
    self.title = title;
    self.thumbnailURL = [NSURL URLWithString:[thumbnailURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return self;
}

-(void) loadThumbnail{
    // запускам загружаться изображение асинхронно
    [self performSelectorInBackground:@selector(loadThumbnailInBackground)
                           withObject:nil];
}

-(void) loadThumbnailInBackground {

    
    // готовим и выполняем запрос
    NSURLRequest* request = [NSURLRequest requestWithURL:self.thumbnailURL];
    NSError* error = nil;
    NSData* data =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:nil error:&error];
    
    if ( error == nil ) {
        //изображение загрузилось
        
        m_thumbnail = [UIImage imageWithData:data] ;
        
        // сообщаем, что изображение загрузилось
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"imageLoadet"
         object:self];
    }
    

}
@end
