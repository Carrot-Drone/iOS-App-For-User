//
//  RSTableViewFooterView.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RSTableViewFooterView.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RSTableViewFooterView
@synthesize textLabel=_textLabel;

- (void)awakeFromNib{
    [_textLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_textLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];

    // Set Cutom Table Separator
    CGFloat separatorInset; // Separator x position
    CGFloat separatorHeight;
    CGFloat separatorWidth;
    CGFloat separatorY;
    UIImageView *separator_bottom;
    UIColor *separatorBGColor;
    
    separatorY      = self.frame.size.height;
    separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
    separatorWidth  = 10000;
    separatorInset  = 0.0f;
    separatorBGColor  = DIVIDER_COLOR2;
    
    
    separator_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, separatorY, separatorWidth,separatorHeight)];
    separator_bottom.backgroundColor = separatorBGColor;
    [self addSubview: separator_bottom];
}

@end
