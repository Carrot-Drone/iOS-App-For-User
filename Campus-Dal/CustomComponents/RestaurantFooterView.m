//
//  RestaurantFooterView.m
//  
//
//  Created by Sukwon Choi on 8/11/15.
//
//

#import "RestaurantFooterView.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"
@implementation RestaurantFooterView

@synthesize flyerView=_flyerView;
@synthesize flyerImageView=_flyerImageView;
@synthesize flyerButton=_flyerButton;

@synthesize phoneCallImageView=_phoneCallImageView;
@synthesize phoneNumberLabel=_phoneNumberLabel;
@synthesize phoneCallButton=_phoneCallButton;

@synthesize borderView=_borderView;

- (void)awakeFromNib{
    self.backgroundColor = BUTTON_BACKGROUND;
    [_flyerImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_advertisement_flyer"]];
    [_phoneCallImageView setImage:[UIImage imageNamed:@"Icon_btn_call"]];
    
    [_phoneNumberLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_phoneNumberLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    [_borderView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
}

- (void)removeFlyerButton{
    [_flyerView removeFromSuperview];
    [_borderView removeFromSuperview];
}

@end
