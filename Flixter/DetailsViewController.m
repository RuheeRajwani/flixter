//
//  DetailsViewController.m
//  Flixter
//
//  Created by Ruhee Rajwani on 6/17/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailMovieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *detailMovieImage;
@property (weak, nonatomic) IBOutlet UILabel *detailMovieSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *detailMoviePopularityValue;
@property (weak, nonatomic) IBOutlet UILabel *detailMovieReleaseDateValue;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.detailDict);
    self.detailMovieTitle.text = self.detailDict[@"title"];
    self.detailMovieSynopsis.text = self.detailDict[@"overview"];
    self.detailMoviePopularityValue.text = [NSString stringWithFormat:@"%@", self.detailDict[@"popularity"]];
    self.detailMovieReleaseDateValue.text = self.detailDict[@"release_date"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *fullPosterURLString =[baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL =[NSURL URLWithString:fullPosterURLString];
    self.detailMovieImage.image = nil;
    [self.detailMovieImage setImageWithURL:posterURL];
    
    
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
