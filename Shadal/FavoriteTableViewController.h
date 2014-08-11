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

@interface FavoriteTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary * favoriteRes;
@end
