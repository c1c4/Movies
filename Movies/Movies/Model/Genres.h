//
//  Genres.h
//  Movies
//
//  Created by Felipe Arado Pompeu on 01/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genres : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString  *name;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
