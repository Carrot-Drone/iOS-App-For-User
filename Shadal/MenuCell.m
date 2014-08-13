//
//  MenuCell.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 15..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize menuLabel, priceLabel;

- (void)awakeFromNib
{
    // set default font
    UIFont * customFont = [UIFont fontWithName:@"SeN-CL" size:18];
    if(customFont == nil) NSLog(@"Font not exist");
    [menuLabel setFont:customFont];
    
    customFont = [UIFont fontWithName:@"SeN-CL" size:14];
    if(customFont == nil) NSLog(@"Font not exist");
    [priceLabel setFont:customFont];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
