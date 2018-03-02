//
//  Movie.m
//  Movies
//
//  Created by Felipe Arado Pompeu on 28/02/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import "Utils.h"
#import "Movie.h"
#import "Genres.h"


@implementation Movie

-(instancetype)initWithDictionary:(NSDictionary*)dictionary genres:(NSMutableArray *)genres {
    if (self = [super init]) {
        self.id = [[dictionary valueForKey:@"id"] integerValue];
        self.voteCount = [[dictionary valueForKey:@"vote_count"] integerValue];
        self.voteAverage = [[dictionary valueForKey:@"vote_average"] integerValue];
        self.title = [dictionary valueForKey:@"title"];
        self.popularity = [[dictionary valueForKey:@"popularity"] doubleValue];
        self.poster = [Utils recoverImageFromUrl:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w300%@",[dictionary valueForKey:@"poster_path"]]];
        self.backdrop = [Utils recoverImageFromUrl:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w300%@",[dictionary valueForKey:@"backdrop_path"]]];
        self.originalLanguage = [dictionary valueForKey:@"original_language"];
        self.originalTitle = [dictionary valueForKey:@"original_title"];
        self.genresList = [self recoverGenres:genres genresIds:[dictionary valueForKey:@"genre_ids"]];
        self.adult = [[dictionary valueForKey:@"adult"] boolValue];
        self.overview = [dictionary valueForKey:@"overview"];
        self.releaseDate = [dictionary valueForKey:@"release_date"];
    }
    return self;
}

-(NSMutableArray *)recoverGenres:(NSMutableArray *)genres genresIds:(NSMutableArray *)genresId {
    NSMutableArray *listOfGenres = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *id in genresId) {
        for (int i = 0; i < [genres count]; i++) {
            NSMutableDictionary *dicGenres = [genres objectAtIndex:i];
            if ([[dicGenres valueForKey:@"id"] intValue] == [id intValue]) {
                Genres *genre = [[Genres alloc] initWithDictionary:dicGenres];
                [listOfGenres addObject:genre];
                break;
            }
        }
    }
    
    
    return listOfGenres;
}

-(NSString *)genresByName:(NSArray *)genres {
    NSMutableString *genresName = [NSMutableString stringWithCapacity:0];
    
    for (Genres *genre in genres) {
        if (genresName.length == 0)
            [genresName appendFormat:@"%@", genre.name];
        else
            [genresName appendFormat:@", %@", genre.name];
    }
    
    return genresName;
}
@end
