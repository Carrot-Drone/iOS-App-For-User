//
//  FlyerViewController.h
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "FlyerFooterView.h"
#import "Restaurant.h"

@interface FlyerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl * pageControl;

@property (nonatomic, strong) IBOutlet FlyerFooterView * footerView;

- (void)setDetailItem:(Restaurant *)restaurant;

- (IBAction)backButtonClicked:(id)sender;

@end
