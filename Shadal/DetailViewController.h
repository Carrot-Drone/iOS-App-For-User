//
//  DetailViewController.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantViewController.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * resArray;
@property (nonatomic, strong) NSString * category;

@property (nonatomic, strong) IBOutlet UITableView * tableView;
- (void)setDetailItem:(id)detailItem;

@end
