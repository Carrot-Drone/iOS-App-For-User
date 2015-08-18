//
//  CustomTableViewFooter.m
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import "CustomTableViewFooter.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation CustomTableViewFooter
@synthesize button=_button;

- (void)awakeFromNib{
    self.backgroundColor = BUTTON_BACKGROUND;
    [_button.titleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_button.titleLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    [_button setBackgroundImage:[UIImage imageNamed:@"Btn_normal"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"Btn_pressed"] forState:UIControlStateHighlighted];
}
@end
