//
//  MovieDetailsViewController.m
//  Movies
//
//  Created by Felipe Arado Pompeu on 01/03/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>

@interface MovieDetailsViewController ()
@property (nonatomic) NSMutableArray *videoList;
@end

@implementation MovieDetailsViewController

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoList = [NSMutableArray arrayWithCapacity:0];
    [self performSelectorOnMainThread:@selector(getTrailerHash) withObject:nil waitUntilDone:YES];
    
    //Poster
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    [imgView setImage:self.movie.poster];
    
    //Title
    UILabel *lbl = (UILabel *)[self.view viewWithTag:10];
    [lbl setText:self.movie.title];
    
    //OverView
    lbl = (UILabel *)[self.view viewWithTag:11];
    [lbl setText:self.movie.overview];
    
    //Release Date
    lbl = (UILabel *)[self.view viewWithTag:12];
    [lbl setText:[NSString stringWithFormat:@"Release Date: %@", self.movie.releaseDate]];
    
    //Genres
    lbl = (UILabel *)[self.view viewWithTag:13];
    [lbl setText:[NSString stringWithFormat:@"Genre(s): %@", [self.movie genresByName:self.movie.genresList]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBActions
- (IBAction)backToMovieList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)watchTrailer:(id)sender {
    NSString *hashCodeVideo = @"";
    for (NSDictionary *dicVideo in self.videoList) {
        if ([[dicVideo valueForKey:@"site"] isEqualToString:@"YouTube"] && [[dicVideo valueForKey:@"name"] isEqualToString:@"Official Trailer"]) {
            hashCodeVideo = [dicVideo valueForKey:@"key"];
            break;
        } else if ([[dicVideo valueForKey:@"site"] isEqualToString:@"YouTube"]) {
            hashCodeVideo = [dicVideo valueForKey:@"key"];
            break;
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", hashCodeVideo]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

#pragma mark -
#pragma mark methods
-(void)getTrailerHash {
    NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US", (int)self.movie.id] ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([[responseObject allKeys] count] >= 1)
            [self.videoList addObjectsFromArray:[responseObject valueForKey:@"results"]];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
