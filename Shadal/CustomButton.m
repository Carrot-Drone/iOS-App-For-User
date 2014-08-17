//
//  CustomButton.m
//  Shadal
//
//  Created by Sukwon Choi on 8/17/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;
    
    labelFrame.origin.x +=10;
    
    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
