//
//  FlyerViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "FlyerViewController.h"
#import "UIImage+UIImage_Customized.h"
#import "Constants.h"

@interface FlyerViewController ()

@end

@implementation FlyerViewController
@synthesize restaurant;
@synthesize title;

- (void)setDetailItem:(id)detailItem{
    restaurant = (Restaurant *)detailItem;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init navigation bar
    navItem.title = restaurant.name;
    navBar.barTintColor = MAIN_COLOR;
    navBar.translucent = NO;
    navBar.tintColor = [UIColor whiteColor];
    
    // Status bar color
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 25)];
    view.backgroundColor=MAIN_COLOR;
    [self.view addSubview:view];
    
    // set scrollview delegate
    scrollView.delegate = self;
    
    // Set Navigation bar title
    [navItem setTitle:restaurant.name];
    
    // init Page control
    pageControl.numberOfPages =[restaurant.flyers_url count];
    if(pageControl.numberOfPages != 0){
        pageControl.hidesForSinglePage = NO;
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        pageControl.tintColor = [UIColor orangeColor];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    float bottom_offset = 37;
    float content_width = [UIScreen mainScreen].bounds.size.width;
    float content_height = [UIScreen mainScreen].bounds.size.height - scrollView.frame.origin.y - bottom_offset;
    
    for(int i=0; i<[restaurant.flyers_url count]; i++){
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + i*content_width, [UIScreen mainScreen].bounds.size.height/2, 20, 20);
        [indicator startAnimating];
        [scrollView addSubview:indicator];
    }
    scrollView.contentSize = CGSizeMake(content_width*pageControl.numberOfPages, content_height);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0; i<[restaurant.flyers_url count]; i++){
            NSString * imageURL = [NSString stringWithFormat:@"%@%@", WEB_BASE_URL, [restaurant.flyers_url objectAtIndex:i]];
        
            UIImage * image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(content_width*i, 0, content_width, content_height);
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [scrollView addSubview:imageView];
            });
        }
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageNum = nearbyintf((scrollView.contentOffset.x / scrollView.frame.size.width));
    pageControl.currentPage = pageNum;
}


- (IBAction)backButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
