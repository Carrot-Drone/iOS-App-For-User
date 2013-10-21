//
//  DetailViewController.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantViewController.h"

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) NSArray * resArray;

- (void)setDetailItem:(id)detailItem;

@end
