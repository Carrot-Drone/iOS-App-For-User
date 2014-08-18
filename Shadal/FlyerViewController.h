//
//  FlyerViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface FlyerViewController : UIViewController

@property (nonatomic, strong) Restaurant * restaurant;
@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;

@property (nonatomic, strong) IBOutlet UINavigationItem * navItem;
@property (nonatomic, strong) IBOutlet UINavigationBar * navBar;

- (void)setDetailItem:(id)detailItem;
- (IBAction)backButtonClicked:(id)sender;

@end
