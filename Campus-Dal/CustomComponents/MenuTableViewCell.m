//
//  MenuTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/11/15.
//
//

#import "MenuTableViewCell.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation MenuTableViewCell

@synthesize menuNameLabel=_menuNameLabel;
@synthesize menuPriceLabel=_menuPriceLabel;
@synthesize menuDetailLabel=_menuDetailLabel;
@synthesize detailLabelHeight=_detailLabelHeight;
@synthesize detailLabelTop=_detailLabelTop;

- (void)awakeFromNib {
    [_menuNameLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:14]];
    [_menuNameLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_menuPriceLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_menuPriceLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    
    
    
    [_menuDetailLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_menuDetailLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
