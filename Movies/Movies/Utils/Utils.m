//
//  Utils.m
//  Movies
//
//  Created by Felipe Arado Pompeu on 02/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"

@implementation Utils

+(UIImage *)recoverImageFromUrl:(NSString *)url
{
    __block NSData *imageData = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return [UIImage imageWithData:imageData];
}

+(void)showAlertOk:(id)delegate msg:(NSString *)msg {
    UIAlertController *editarItens = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    
    [editarItens addAction:actionOK];
    [delegate presentViewController:editarItens animated:YES completion:nil];
}

@end
