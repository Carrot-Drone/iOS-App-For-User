//
//  RestaurantViewController.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <UIKit/UIKit.h>

#import "Restaurant.h"
#import "RestaurantFooterView.h"

@interface RestaurantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet RestaurantFooterView * footerView;

@property (nonatomic, strong) NSString * campusNameForKakaoShare;

- (void)setDetailItem:(Restaurant * )restaurant;
- (IBAction)restaurantCorrectionButtonClicked:(id)sender;

@end
