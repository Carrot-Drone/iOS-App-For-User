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
@synthesize scrollView;
@synthesize title;
@synthesize navItem, navBar;

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
    self.navItem.title = restaurant.name;
    self.navBar.barTintColor = MAIN_COLOR;
    self.navBar.translucent = NO;
    self.navBar.tintColor = [UIColor whiteColor];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 25)];
    view.backgroundColor=MAIN_COLOR;
    [self.view addSubview:view];
    
    float content_width = [UIScreen mainScreen].bounds.size.width;
    float content_height = [UIScreen mainScreen].bounds.size.height - self.scrollView.frame.origin.y;
    
    
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
    
    // Set Navigation bar title
    [self.navItem setTitle:restaurant.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
