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
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 25)];
    view.backgroundColor=MAIN_COLOR;
    [self.view addSubview:view];
    
    // set scrollview delegate
    scrollView.delegate = self;
    
    // Set Navigation bar title
    [navItem setTitle:restaurant.name];
    
    // init Page control
    pageControl.numberOfPages =[restaurant.flyers_url count];
    pageControl.hidesForSinglePage = NO;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.tintColor = [UIColor orangeColor];
    pageControl.currentPage = 0;
    
    float bottom_offset = 37;
    float content_width = [UIScreen mainScreen].bounds.size.width;
    float content_height = [UIScreen mainScreen].bounds.size.height - scrollView.frame.origin.y - bottom_offset;
    
    scrollView.contentSize = CGSizeMake(content_width*pageControl.numberOfPages, content_height);
    for(int i=0; i<[restaurant.flyers_url count]; i++){
        NSString * imageURL = [NSString stringWithFormat:@"%@%@", WEB_BASE_URL, [restaurant.flyers_url objectAtIndex:i]];
        
        UIImage * image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(content_width*i, 0, content_width, content_height);
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [scrollView addSubview:imageView];
    }
    /*
    // If there's only one image
    if([UIImage imageNamed_advanced:restaurant.phoneNumber]){
        scrollView.contentSize = CGSizeMake(content_width, content_height);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_advanced:restaurant.phoneNumber]];
        imageView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [scrollView addSubview:imageView];
    }else{
        UIImage * image = [UIImage imageNamed_advanced:restaurant.phoneNumber option:1];
        int numberOfImg = 0;
        while(image != nil){
            numberOfImg++;
            scrollView.contentSize = CGSizeMake(content_width*numberOfImg, content_height);
            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(content_width*(numberOfImg-1), 0, content_width, content_height);
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [scrollView addSubview:imageView];
            
            image = [UIImage imageNamed_advanced:restaurant.phoneNumber option:numberOfImg+1];
        }
        if(numberOfImg == 0) NSLog(@"Image not exist %@", restaurant.name);
    }
    */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageNum = nearbyintf((scrollView.contentOffset.x / scrollView.frame.size.width));
    pageControl.currentPage = pageNum;
}


- (IBAction)backButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
