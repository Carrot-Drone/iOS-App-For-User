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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // set default font
        UIFont * customFont = [UIFont fontWithName:@"SeN-CEB" size:5];
        if(customFont == nil) NSLog(@"Font not exist");
        
        [restaurantLabel setFont:customFont];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
