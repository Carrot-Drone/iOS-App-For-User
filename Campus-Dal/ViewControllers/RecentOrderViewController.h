//
//  FirstViewController.h
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecentOrderTableViewHeader.h"

@interface RecentOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UILabel * placeHolderLabel;

@property (nonatomic, strong) IBOutlet RecentOrderTableViewHeader * fixedTableViewHeader;

@end

