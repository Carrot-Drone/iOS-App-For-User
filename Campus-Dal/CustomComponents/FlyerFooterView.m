//
//  FlyerFooterView.m
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import "FlyerFooterView.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation FlyerFooterView

@synthesize phoneCallImageView=_phoneCallImageView;
@synthesize phoneNumberLabel=_phoneNumberLabel;
@synthesize phoneCallButton=_phoneCallButton;

- (void)awakeFromNib{
    self.backgroundColor = BUTTON_BACKGROUND;
    [_phoneCallImageView setImage:[UIImage imageNamed:@"Icon_btn_call"]];
    
    [_phoneNumberLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_phoneNumberLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
}
@end
