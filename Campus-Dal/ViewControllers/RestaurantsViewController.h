//
//  RestaurantsViewController.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <UIKit/UIKit.h>

#import "RestaurantsTableViewHeader.h"

#import "CategoryModel.h"

@interface RestaurantsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet RestaurantsTableViewHeader * headerView;
@property (nonatomic, strong) IBOutlet UIView * placeholderView;
- (void)setDetailItem:(CategoryModel * )category;

@end
