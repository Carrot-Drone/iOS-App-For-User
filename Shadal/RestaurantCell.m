//
//  RestaurantCell.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell
@synthesize restaurantLabel;

- (void)awakeFromNib
{
    // set default font
    UIFont * customFont = [UIFont fontWithName:@"SeN-CL" size:19.5];
    if(customFont == nil) NSLog(@"Font not exist");
    
    [restaurantLabel setFont:customFont];
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
