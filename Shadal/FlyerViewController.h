//
//  FlyerViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface FlyerViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView * scrollView;
    
    IBOutlet UINavigationItem * navItem;
    IBOutlet UINavigationBar * navBar;
    IBOutlet UIPageControl * pageControl;
}

@property (nonatomic, strong) Restaurant * restaurant;

- (void)setDetailItem:(id)detailItem;
- (IBAction)backButtonClicked:(id)sender;

@end
