//
//  CategoryCell.m
//  Shadal
//
//  Created by Sukwon Choi on 8/13/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize categoryLabel;
- (void)awakeFromNib
{
    // Initialization code
    // set default font
    UIFont * customFont = [UIFont fontWithName:@"SeN-CL" size:19.5];
    if(customFont == nil) NSLog(@"Font not exist");
    
    [categoryLabel setFont:customFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
