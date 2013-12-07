//
//  FlyerViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "FlyerViewController.h"
#import "UIImage+UIImage_Customized.h"

@interface FlyerViewController ()

@end

@implementation FlyerViewController
@synthesize restaurant;
@synthesize scrollView;

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
    self.navigationItem.title = restaurant.name;
    
    // If there's only one image
    if([UIImage imageNamed_advanced:restaurant.phoneNumber]){
        scrollView.contentSize = CGSizeMake(320, 503);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_advanced:restaurant.phoneNumber]];
        imageView.frame = CGRectMake(0, 0, 320, 503);
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [scrollView addSubview:imageView];
    }else{
        UIImage * image = [UIImage imageNamed_advanced:restaurant.phoneNumber option:1];
        int numberOfImg = 0;
        while(image != nil){
            numberOfImg++;
            scrollView.contentSize = CGSizeMake(320*numberOfImg, 503);
            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(320*(numberOfImg-1), 0, 320, 503);
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [scrollView addSubview:imageView];
            
            image = [UIImage imageNamed_advanced:restaurant.phoneNumber option:numberOfImg+1];
        }
        if(numberOfImg == 0) NSLog(@"Image not exist %@", restaurant.name);
    }
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
