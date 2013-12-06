//
//  FlyerViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "FlyerViewController.h"

@interface FlyerViewController ()

@end

@implementation FlyerViewController
@synthesize restaurant;
@synthesize imageView;

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
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", restaurant.phoneNumber]];
	// Do any additional setup after loading the view.
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
