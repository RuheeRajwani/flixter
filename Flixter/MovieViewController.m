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

@end

@implementation MovieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=3936a31f61adbb8965840fb14ad1ca82"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Get the array of movies
               NSLog(@"%@", dataDictionary);
               // TODO: Store the movies in a property to use elsewhere
               self.movieArray = dataDictionary[@"results"];
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
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
    //where do we find the base url
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString =[baseURLString stringByAppendingString:posterURLString];
    //how do you concatenate two strings
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    cell.movieImage.image = nil;
    [cell.movieImage setImageWithURL:posterURL];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieArray.count;
}

@end
