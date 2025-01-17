//
//  RestaurantViewController.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) Restaurant * restaurant;
@property (nonatomic) BOOL isFromRandom;

@property (nonatomic, strong) IBOutlet UIButton * favorite;

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UIButton * phoneNumber;
@property (nonatomic, strong) IBOutlet UILabel * openingTimeLabel;

@property (nonatomic, strong) UIBarButtonItem * barButton;

- (IBAction)call:(id)sender;
- (IBAction)favoriteButtonClicked:(id)sender;
- (void)setDetailItem:(id)detailItem;
- (void)updateUI;



@end
