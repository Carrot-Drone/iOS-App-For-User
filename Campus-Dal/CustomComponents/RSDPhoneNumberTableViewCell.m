//
//  RSDPhoneNumberTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RSDPhoneNumberTableViewCell.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RSDPhoneNumberTableViewCell

- (void)awakeFromNib {
    [[self textField] setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    [[self textField] setTextColor:[UIColor colorWithRGBHex:0x333333]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
