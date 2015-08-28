//
//  MenuTableViewSection.m
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import "MenuTableViewSection.h"
#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation MenuTableViewSection

@synthesize sectionTitle=_sectionTitle;
@synthesize sectionImageView=_sectionImageView;


- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor colorWithRGBHex:0xeeeeee]];
    
    [_sectionTitle setFont:[UIFont fontWithName:MAIN_FONT size:14]];
    [_sectionTitle setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_sectionImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_arrow"]];
}

@end
