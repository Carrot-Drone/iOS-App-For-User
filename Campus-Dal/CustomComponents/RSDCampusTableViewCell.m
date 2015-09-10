//
//  RSCampusTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RSDCampusTableViewCell.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RSDCampusTableViewCell
@synthesize titleLabel=_titleLabel;

- (void)awakeFromNib {
    [_titleLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
