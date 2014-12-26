//
//  MITThumbnail.m
//  PhotoVK
//
//  Created by Dmitrii Bilukha on 12/26/14.
//  Copyright (c) 2014 Dmitrii Bilukha. All rights reserved.
//

#import "MITThumbnail.h"

@implementation MITThumbnail

@synthesize title;
@synthesize thumbnailURL;

-(UIImage*) image {
    return m_image;
}

-(id) initWithName:(NSString*)title {
    return [self initWithName:title thumbnailURL:nil];
}

-(id) initWithName:(NSString *)title thumbnailURL:(NSURL*)thumbnailURL {
    self = [super init];
    self.title = title;
    self.thumbnailURL = thumbnailURL;
    return self;
}

-(void) loadThumbnail:(id) observer {
    // запускам загружаться изображение асинхронно
    [self performSelectorInBackground:@selector(loadImageInBackground:)
                           withObject:nil];
}

-(void) loadThumbnailInBackground:(id) observer{

    
    // готовим и выполняем запрос
    NSURLRequest* request = [NSURLRequest requestWithURL:self.thumbnailURL];
    NSError* error = nil;
    NSData* data =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:nil error:&error];
    
    if ( error == nil ) {
        //изображение загрузилось
        m_image = [UIImage imageWithData:data];
        
        // сообщаем, что изображение загрузилось
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ThumbnailIsLoading"
         object:observer];
    }
    

}
@end
