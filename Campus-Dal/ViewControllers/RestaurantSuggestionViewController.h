//
//  RestaurantSuggestionViewController.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantSuggestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

- (IBAction)cancelButtonClicked:(id)sender;

@end
