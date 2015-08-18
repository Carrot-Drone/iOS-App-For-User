//
//  RestaurantCorrectionTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import "RestaurantCorrectionCell.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RestaurantCorrectionCell

@synthesize imageView=_imageView;
@synthesize titleLabel=_titleLabel;
@synthesize textView=_textView;
@synthesize checkButton=_checkButton;

@synthesize sectionImageView=_sectionImageView;
@synthesize sectionTitleLabel=_sectionTitleLabel;

@synthesize isSelected=_isSelected;

- (void)awakeFromNib {
    if(_titleLabel != nil){
        [_imageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_normal"]];
        [_titleLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
        [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
        
        // Set Cutom Table Separator
        CGFloat separatorInset; // Separator x position
        CGFloat separatorHeight;
        CGFloat separatorWidth;
        CGFloat separatorY;
        UIImageView *separator_top;
        UIColor *separatorBGColor;
        
        separatorY      = self.frame.size.height;
        separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
        separatorWidth  = 10000;
        separatorInset  = 0.0f;
        separatorBGColor  = DIVIDER_COLOR2;
        
        
        separator_top = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, 0, separatorWidth,separatorHeight)];
        separator_top.backgroundColor = separatorBGColor;
        [self addSubview: separator_top];

    }else if(_textView != nil){
        _textView.backgroundColor = TAB_BAR_BG_COLOR;
        _textView.layer.cornerRadius = 5;
        _textView.clipsToBounds = YES;
        _textView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0].CGColor;
        _textView.layer.borderWidth = 1;
    }else{
        [_sectionTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:15]];
        [_sectionTitleLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
        
        // Set Cutom Table Separator
        CGFloat separatorInset; // Separator x position
        CGFloat separatorHeight;
        CGFloat separatorWidth;
        CGFloat separatorY;
        UIImageView *separator_top;
        UIColor *separatorBGColor;
        
        separatorY      = self.frame.size.height;
        separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
        separatorWidth  = 10000;
        separatorInset  = 0.0f;
        separatorBGColor  = DIVIDER_COLOR2;
        
        
        separator_top = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, 0, separatorWidth,separatorHeight)];
        separator_top.backgroundColor = separatorBGColor;
        [self addSubview: separator_top];
    }
}



@end
