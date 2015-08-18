//
//  CustomCampusTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import "CustomCampusCell.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation CustomCampusCell
@synthesize campusLabel=_campusLabel;
@synthesize checkImageView=_checkImageView;


- (void)awakeFromNib {
    [_campusLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    [_campusLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_checkImageView setImage:[UIImage imageNamed:@"Icon_list_check"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
