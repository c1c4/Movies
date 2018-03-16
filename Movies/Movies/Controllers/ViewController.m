//
//  ViewController.m
//  Movies
//
//  Created by Felipe Arado Pompeu on 28/02/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//
#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "ViewController.h"
#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "Utils.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *listMovies;
@property (nonatomic) NSMutableArray *listGenres;
@property (nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) IBOutlet UITableView *tblViewMovies;

@property (nonatomic) int page;
@property (nonatomic) int totalPages;

@property (nonatomic) Movie *movie;

@property (nonatomic) BOOL connected;
@end

@implementation ViewController

#pragma mark -
#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.connected = YES;
    self.listGenres = [NSMutableArray arrayWithCapacity:0];
    self.listMovies = [NSMutableArray arrayWithCapacity:0];
    self.searchResults = [NSMutableArray arrayWithCapacity:0];
    [self.tblViewMovies setDelegate:self];
    [self.tblViewMovies setDataSource:self];
    self.page = 1;
    [self performSelectorOnMainThread:@selector(moviesList) withObject:nil waitUntilDone:YES];
    for (int i = 2; i < self.totalPages; i++) {
        self.page = i;
        [self performSelectorOnMainThread:@selector(moviesList) withObject:nil waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(genresList) withObject:nil waitUntilDone:YES];
    
    if (!self.connected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils showAlertOk:self msg:@"This app need internet. Please connect to wifi or other source!"];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.searchResults count] > 0) {
        return [self.searchResults count];
    }
    else {
        return [self.listMovies count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tblViewMovies dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    Movie *movie = [self recoverObjectMovie:indexPath];
    
    //poster
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView setImage:movie.poster];
    
    //Movie Title
    UILabel *lbl = (UILabel *)[cell viewWithTag:10];
    [lbl setText:movie.title];
    
    //Release Date
    lbl = (UILabel *)[cell viewWithTag:12];
    [lbl setText:[NSString stringWithFormat:@"Release Date: %@", movie.releaseDate]];
    
    //Genres
    lbl = (UILabel *)[cell viewWithTag:13];
    [lbl setText:[NSString stringWithFormat:@"Genre(s): %@", [movie genresByName:movie.genresList]]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"segueMovieDetails" sender:[self recoverObjectMovie:indexPath]];
}

#pragma mark -
#pragma mark methods
-(void)moviesList {
    
    NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&page=%d", self.page];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([[responseObject allKeys] count] >= 1)
        {
            self.totalPages = [[responseObject valueForKey:@"total_pages"] intValue];
            [self.listMovies addObjectsFromArray:[responseObject valueForKey:@"results"]];
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        self.connected = NO;
        NSLog(@"Error: %@", error);
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)genresList {
    NSString *url = @"https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([[responseObject allKeys] count] >= 1)
            [self.listGenres addObjectsFromArray:[responseObject valueForKey:@"genres"]];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        self.connected = NO;
        NSLog(@"Error: %@", error);
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(Movie *)recoverObjectMovie:(NSIndexPath *)indexPath {
    NSDictionary *dicMovie = self.searchResults.count > 0 ? [self.searchResults objectAtIndex:indexPath.row] : [self.listMovies objectAtIndex:indexPath.row];
    return [[Movie alloc] initWithDictionary:dicMovie genres:self.listGenres];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieDetailsViewController *movieDVC = segue.destinationViewController;
    movieDVC.movie = sender;
}

#pragma mark -
#pragma mark SearchDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [self.searchResults removeAllObjects];
    [self.tblViewMovies reloadData];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        [searchBar setText:@""];
        [self.searchResults removeAllObjects];
        [self.tblViewMovies reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchResults.count != 0) {
        [self.searchResults removeAllObjects];
    }
    for (int i=0; i< [self.listMovies count]; i++)
    {
        NSString *string = [[self.listMovies objectAtIndex:i] valueForKey:@"title"];
        NSRange rangeValue = [string rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if (rangeValue.length > 0)
        {
            [self.searchResults addObject:[self.listMovies objectAtIndex:i]];
        }
    }
    
    [self.tblViewMovies reloadData];
}

@end
