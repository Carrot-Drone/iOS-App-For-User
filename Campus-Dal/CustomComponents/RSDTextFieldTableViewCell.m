//
//  RSTextFieldTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RSDTextFieldTableViewCell.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RSDTextFieldTableViewCell
@synthesize textField=_textField;
- (void)awakeFromNib {
    [_textField setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    [_textField setTextColor:[UIColor colorWithRGBHex:0x333333]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
