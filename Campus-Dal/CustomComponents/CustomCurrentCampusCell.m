//
//  AboutTableViewCurrentCampusCell.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "CustomCurrentCampusCell.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation CustomCurrentCampusCell
@synthesize currentCampus=_currentCampus;

- (void)awakeFromNib {
    [_currentCampus setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:20]];
    [_currentCampus setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
