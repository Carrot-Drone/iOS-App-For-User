//
//  RSCustomView.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RSTableViewCell.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RSTableViewCell

@synthesize subLabel=_subLabel;
@synthesize mainLabel1=_mainLabel1;
@synthesize mainLabel2=_mainLabel2;
@synthesize imageView=_imageView;
@synthesize suggestionButton=_suggestionButton;

@synthesize imageWidth=_imageWidth;

-(void)awakeFromNib{
    [_mainLabel1 setTextColor:[UIColor colorWithRGBHex:0x333333]];
    [_mainLabel2 setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_subLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    [_suggestionButton setBackgroundImage:[UIImage imageNamed:@"Btn_add_store_normal"] forState:UIControlStateNormal];
    [_suggestionButton setBackgroundImage:[UIImage imageNamed:@"Btn_add_store_selected"] forState:UIControlStateSelected];
    
    [_suggestionButton.titleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_suggestionButton setTitleColor:[UIColor colorWithRGBHex:0xfb7010] forState:UIControlStateNormal];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        [_mainLabel1 setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
        [_mainLabel2 setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
        [_subLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
        _imageWidth.constant = 100;
        
    }else{
        [_mainLabel1 setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:16]];
        [_mainLabel2 setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:16]];
        [_subLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
        _imageWidth.constant = 114;
    }
    [self layoutIfNeeded];
}

@end
