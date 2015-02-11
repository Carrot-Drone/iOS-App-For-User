//
//  SelectCampusViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 2/10/15.
//  Copyright (c) 2015 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCampusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * indicatorView;

@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UITableView * campusTableView;

@property (nonatomic, strong) IBOutlet UIButton * selectCampusButton;
@property (nonatomic, strong) IBOutlet UIButton * startButton;

@end
