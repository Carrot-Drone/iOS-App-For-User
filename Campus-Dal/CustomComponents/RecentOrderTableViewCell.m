//
//  CustomTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RecentOrderTableViewCell.h"

#import "UIColor+COLORCategories.h"

#import "Constants.h"

@implementation RecentOrderTableViewCell

@synthesize numberOfCallsLabel=_numberOfCallsLabel;
@synthesize restaurantLabel=_restaurantLabel;
@synthesize phoneCallButton=_phoneCallButton;

- (void)awakeFromNib {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        [_numberOfCallsLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:18]];
        [_restaurantLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
        
    }else{
        [_numberOfCallsLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:20]];
        [_restaurantLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    }
    
    [_numberOfCallsLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_restaurantLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_phoneCallButton setBackgroundImage:[UIImage imageNamed:@"Icon_list_call"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
