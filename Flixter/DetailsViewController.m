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

//ADD COMMENT
- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
