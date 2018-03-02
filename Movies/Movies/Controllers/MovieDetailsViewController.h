//
//  MovieDetailsViewController.h
//  Movies
//
//  Created by Felipe Arado Pompeu on 01/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) Movie *movie;
@end
