//
//  Utils.h
//  Movies
//
//  Created by Felipe Arado Pompeu on 02/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(UIImage *)recoverImageFromUrl:(NSString *)url;
+(void)showAlertOk:(id)delegate msg:(NSString *)msg;
@end
