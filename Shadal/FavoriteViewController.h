//
//  FavoriteTableViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 8/12/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Restaurant.h"
#import "RestaurantCell.h"

@interface FavoriteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableDictionary * favoriteRes;

@property (strong, nonatomic) IBOutlet UITableView * tableView;
@end
