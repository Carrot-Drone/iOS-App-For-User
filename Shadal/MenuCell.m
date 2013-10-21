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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
