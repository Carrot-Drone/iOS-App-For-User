//
//  CustomNavigationBarTitleView.m
//  Shadal
//
//  Created by Sukwon Choi on 8/13/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "CustomTitleView.h"

@implementation CustomTitleView
@synthesize titleLabel, subTitleLabel;
@synthesize categoryLabel, categoryImageView;


- (void)awakeFromNib
{
    // set default font
    UIFont * customFont = [UIFont fontWithName:@"SeN-CEB" size:30.5];
    if(customFont == nil) NSLog(@"Font not exist");
    [titleLabel setFont:customFont];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    customFont = [UIFont fontWithName:@"SeN-CEB" size:12.5];
    if(customFont == nil) NSLog(@"Font not exist");
    [subTitleLabel setFont:customFont];
    [subTitleLabel setTextColor:[UIColor whiteColor]];
    
    customFont = [UIFont fontWithName:@"SeN-CEB" size:23.0];
    if(customFont == nil) NSLog(@"Font not exist");
    [categoryLabel setFont:customFont];
    [categoryLabel setTextColor:[UIColor whiteColor]];
    
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end