//
//  RandomRestaurantViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 8/12/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Restaurant.h"
#import "RestaurantCell.h"
#import "Constants.h"
#import "MenuCell.h"

@interface RandomRestaurantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Restaurant * restaurant;

@property (nonatomic, strong) IBOutlet UIButton * favorite;

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UIButton * phoneNumber;


- (IBAction)call:(id)sender;
- (IBAction)favoriteButtonClicked:(id)sender;

@end
