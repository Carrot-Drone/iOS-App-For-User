//
//  RecommendationTitleView.m
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import "RecommendationTitleView.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RecommendationTitleView
@synthesize titleLabel=_titleLabel;
@synthesize leftImageView=_leftImageView;
@synthesize rightImageView=_rightImageView;

- (void)awakeFromNib{
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:17]];
    
    [_leftImageView setImage:[UIImage imageNamed:@"Icon_card_tab_selected"]];
    [_rightImageView setImage:[UIImage imageNamed:@"Icon_card_tab_normal"]];
}

@end
