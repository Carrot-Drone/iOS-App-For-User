//
//  RestaurantsTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RestaurantsTableViewCell.h"

#import "Constants.h"

#import "UIColor+COLORCategories.h"

@implementation RestaurantsTableViewCell
@synthesize retentionLabel=_retentionLabel;
@synthesize retentionPercentLabel=_retentionPercentLabel;

@synthesize nameLabel=_nameLabel;
@synthesize flyerButton=_flyerButton;
@synthesize flyerImageView=_flyerImageView;

@synthesize leftMargin=_leftMargin;

- (void)awakeFromNib {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
        [_retentionPercentLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
        [_nameLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
        _leftMargin.constant = 75;
    }else{
        [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
        [_retentionPercentLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
        [_nameLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    }
    
    [_retentionLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_retentionPercentLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_nameLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_flyerButton setImage:[UIImage imageNamed:@"Icon_list_advertisement_flyer"] forState:UIControlStateNormal];
    [_flyerImageView setImage:[UIImage imageNamed:@"Icon_list_advertisement_flyer"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
