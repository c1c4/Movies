//
//  Genres.m
//  Movies
//
//  Created by Felipe Arado Pompeu on 01/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import "Genres.h"

@implementation Genres

-(instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.id = [[dictionary valueForKey:@"id"] integerValue];
        self.name = [dictionary valueForKey:@"name"];
    }
    return self;
}

@end
