//
//  MenuCell.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 15..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "MenuCell.h"
#import "Constants.h"

@implementation MenuCell
@synthesize menuLabel, priceLabel;

- (void)awakeFromNib
{
    // set default font
    UIFont * customFont = SEOUL_FONT_L(18);
    if(customFont == nil) NSLog(@"Font not exist");
    [menuLabel setFont:customFont];
    
    customFont = SEOUL_FONT_L(14);
    if(customFont == nil) NSLog(@"Font not exist");
    [priceLabel setFont:customFont];
}

-(void)setFontAttribute{

    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:menuLabel.text];
    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:0.5]
                             range:NSMakeRange(0, [menuLabel.text length])];
    menuLabel.attributedText = attributedString;
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
    [attributedString addAttribute:NSKernAttributeName
                             value:[NSNumber numberWithFloat:0.5]
                             range:NSMakeRange(0, [priceLabel.text length])];
    priceLabel.attributedText = attributedString;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
