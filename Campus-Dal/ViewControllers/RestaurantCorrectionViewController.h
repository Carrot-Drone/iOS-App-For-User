//
//  RestaurantCorrectionViewController.h
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import <UIKit/UIKit.h>

#import "CustomTableViewFooter.h"
#import "Restaurant.h"

@interface RestaurantCorrectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet CustomTableViewFooter * footerView;

- (IBAction)cancelButtonClicked:(id)sender;
- (void)setDetailItem:(Restaurant *)restaurant;
@end
