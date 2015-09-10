//
//  SelectCampusViewController.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <UIKit/UIKit.h>

#import "CustomTableViewFooter.h"

@interface SelectCampusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * headerHeightConstraint;
@property (nonatomic, strong) IBOutlet UITableView * headerTableView;

@property (nonatomic, strong) IBOutlet CustomTableViewFooter * startButtonView;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityIndicator;

- (void)setDetailItem:(BOOL)isFromRSV;
@end
