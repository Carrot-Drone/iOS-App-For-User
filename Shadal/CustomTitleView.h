//
//  CustomNavigationBarTitleView.h
//  Shadal
//
//  Created by Sukwon Choi on 8/13/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTitleView : UIView
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * subTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel * categoryLabel;
@property (nonatomic, strong) IBOutlet UIImageView * categoryImageView;
@end
