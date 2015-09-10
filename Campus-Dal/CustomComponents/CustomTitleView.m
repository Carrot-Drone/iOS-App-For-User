//
//  CustomTitleView.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "CustomTitleView.h"
#import "Constants.h"

@implementation CustomTitleView

@synthesize titleLabel=_titleLabel;

-(void)awakeFromNib{
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:17]];
}

@end
