//
//  AboutVCTableViewSection.m
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import "CustomTableViewSection.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation CustomTableViewSection
@synthesize titleLabel=_titleLabel;
@synthesize imageView=_imageView;

-(void)awakeFromNib{
    [_titleLabel setFont:[UIFont fontWithName:MAIN_FONT size:15]];
    [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
}

@end
