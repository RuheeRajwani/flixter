//
//  MovieViewController.m
//  Flixter
//
//  Created by Ruhee Rajwani on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movieArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController


//ADD COMMENT
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

//ADD COMMENT
- (void)fetchMovies{
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=3936a31f61adbb8965840fb14ad1ca82"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               [self errorHandling: error];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               self.movieArray = dataDictionary[@"results"];
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

-(void)errorHandling:(nonnull NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
                        }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:tryAgain];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Navigation

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *movieIndexPath = [self.tableView indexPathForCell:sender];
     NSDictionary *dataToPass = self.movieArray[movieIndexPath.row];
     DetailsViewController *detailVC = [segue destinationViewController];
     detailVC.detailDict = dataToPass;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movieArray[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString =[baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    cell.movieImage.image = nil;
    [cell.movieImage setImageWithURL:posterURL];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieArray.count;
}

@end
