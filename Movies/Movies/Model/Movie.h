//
//  Movie.h
//  Movies
//
//  Created by Felipe Arado Pompeu on 28/02/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger voteCount;
@property (nonatomic) NSInteger voteAverage;
@property (nonatomic) NSString  *title;
@property (nonatomic) double    popularity;
@property (nonatomic) UIImage   *poster;
@property (nonatomic) NSString  *originalLanguage;
@property (nonatomic) NSString  *originalTitle;
@property (nonatomic) NSArray   *genresList;
@property (nonatomic) UIImage   *backdrop;
@property (nonatomic) BOOL      adult;
@property (nonatomic) NSString  *overview;
@property (nonatomic) NSString  *releaseDate;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary genres:(NSMutableArray *)genres;
-(NSString *)genresByName:(NSArray *)genres;
@end
