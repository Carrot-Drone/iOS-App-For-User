//
//  RestaurantTableViewHeader.m
//  
//
//  Created by Sukwon Choi on 8/8/15.
//
//

#import "RestaurantTableViewHeader.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RestaurantTableViewHeader

@synthesize topView=_topView;
@synthesize officeDotImageView=_officeDotImageView;
@synthesize officeHourTitleLabel=_officeHourTitleLabel;
@synthesize officeHourLabel=_officeHourLabel;
@synthesize minimumPriceDotImageView=_minimumPriceDotImageView;
@synthesize minimumPriceTitleLabel=_minimumPriceTitleLabel;
@synthesize minimumPriceLabel=_minimumPriceLabel;

@synthesize likeView=_likeView;
@synthesize likeImageView=_likeImageView;
@synthesize likeLabel=_likeLabel;
@synthesize dislikeImageView=_dislikeImageView;
@synthesize dislikeLabel=_dislikeLabel;
@synthesize gaugeBackgroundView=_gaugeBackgroundView;
@synthesize gaugeView=_gaugeView;
@synthesize gaugeWidth=_gaugeWidth;
@synthesize percentageImageView=_percentageImageView;
@synthesize percentageLabel=_percentageLabel;

@synthesize statusView=_statusView;
@synthesize retentionView=_retentionView;
@synthesize retentionUnitLabel=_retentionUnitLabel;
@synthesize retentionLabel=_retentionLabel;
@synthesize retentionTitleLabel=_retentionTitleLabel;
@synthesize myCallsView=_myCallsView;
@synthesize callLabel=_callLabel;
@synthesize callTitleLabel=_callTitleLabel;
@synthesize callUnitLabel=_callUnitLabel;
@synthesize totalCallsView=_totalCallsView;
@synthesize totalCallLabel=_totalCallLabel;
@synthesize totalCallTitleLabel=_totalCallTitleLabel;
@synthesize totalCallUnitLabel=_totalCallUnitLabel;

@synthesize border1=_border1;
@synthesize border2=_border2;
@synthesize border3=_border3;

@synthesize buttonView=_buttonView;
@synthesize leftView=_leftView;
@synthesize shareButton=_shareButton;
@synthesize shareImageView=_shareImageView;
@synthesize shareLabel=_shareLabel;

@synthesize rightView=_rightView;
@synthesize evaluationButton=_evaluationButton;
@synthesize like_dislikeImageView=_like_dislikeImageView;
@synthesize like_dislikeLabel=_like_dislikeLabel;
@synthesize likeButton=_likeButton;
@synthesize likeButtonImageView=_likeButtonImageView;
@synthesize dislikeButton=_dislikeButton;
@synthesize dislikeButtonImageView=_dislikeButtonImageView;

@synthesize noticeView=_noticeView;
@synthesize noticeImageView=_noticeImageView;
@synthesize noticeLabel=_noticeLabel;

- (void)initWithRestaurant:(Restaurant *)restaurant{
    [self layoutIfNeeded];
    
    // Top View
    _officeHourLabel.text = [restaurant officeHoursString];
    _minimumPriceLabel.text = [restaurant minimumPriceString];
    if(_minimumPriceLabel.text == nil || [_minimumPriceLabel.text isEqualToString:@""] || [_minimumPriceLabel.text isEqualToString:@"0"]){
        [_minimumPriceDotImageView setHidden:YES];
        [_minimumPriceTitleLabel setHidden:YES];
        [_minimumPriceLabel setHidden:YES];
    }
    _minimumPriceLabel.text = [NSString stringWithFormat:@"%@원", _minimumPriceLabel.text];
    
    // like View
    _likeLabel.text = [restaurant.totalNumberOfGoods stringValue];
    _dislikeLabel.text = [restaurant.totalNumberOfBads stringValue];
    
    int percentage = 50;
    if([restaurant.totalNumberOfGoods intValue] != 0 || [restaurant.totalNumberOfBads intValue]!=0){
        double p =[restaurant.totalNumberOfGoods doubleValue] / ([restaurant.totalNumberOfGoods doubleValue] + [restaurant.totalNumberOfBads doubleValue]);
        percentage = (int)(p*100);
    }
    
    _percentageLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    
    // Change Gauge bar with animation
    [UIView animateWithDuration:5.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ {
                         _gaugeWidth.constant = _gaugeBackgroundView.frame.size.width * (((double)percentage)/100.0);
                         
                     }completion:^(BOOL finished) {
                         
                     }];
    
    // Status View
    _retentionLabel.text = [restaurant retentionString];
    _callLabel.text = [NSString stringWithFormat:@"%d", [restaurant.numberOfCalls intValue]];
    _totalCallLabel.text = [restaurant estimatedTotalCallString];
    
    // Button View
    if([restaurant.myPreference intValue] == 1){
        [_likeButtonImageView setHidden:NO];
        [[_likeButtonImageView superview] setBackgroundColor:MAIN_COLOR];
        [_dislikeButtonImageView setHidden:NO];
        [_likeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_check"]];
        [_dislikeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_hate"]];
        
        [_evaluationButton removeFromSuperview];
        [_like_dislikeLabel removeFromSuperview];
        [_like_dislikeImageView removeFromSuperview];
        [_border3 removeFromSuperview];
    }else if([restaurant.myPreference intValue] == -1){
        [_likeButtonImageView setHidden:NO];
        [[_likeButtonImageView superview] setBackgroundColor:MAIN_COLOR];
        [_dislikeButtonImageView setHidden:NO];
        [_dislikeButtonImageView setImage:[UIImage imageNamed:@"Icon_list_check"]];
        [_likeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_like"]];
        
        [_evaluationButton removeFromSuperview];
        [_like_dislikeLabel removeFromSuperview];
        [_like_dislikeImageView removeFromSuperview];
        [_border3 removeFromSuperview];
    }else{
        [_likeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_like"]];
        [_dislikeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_hate"]];
    }
    
    // Notice View
    
    if([restaurant notice] == nil || [restaurant.notice isEqualToString:@""]){
        self.frame = CGRectMake(0, 0, self.frame.size.width, _noticeView.frame.origin.y);
        [_noticeView removeFromSuperview];
    }else{
        _noticeLabel.text = [restaurant notice];
        [_noticeLabel layoutIfNeeded];
        [_noticeView layoutIfNeeded];
        self.frame = CGRectMake(0, 0, self.frame.size.width, _noticeView.frame.origin.y+_noticeView.frame.size.height);
    }
    
    [self layoutIfNeeded];

}

- (void)awakeFromNib{
    // TopView
    [_topView setBackgroundColor:MAIN_COLOR];
    [_officeDotImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_dot"]];
    [_officeHourLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_officeHourLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    [_officeHourTitleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:13]];
    //[_officeHourTitleLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
    [_officeHourTitleLabel setTextColor:[UIColor colorWithRGBHex:0xfdcdba]];
    
    [_minimumPriceDotImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_dot"]];
    [_minimumPriceLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_minimumPriceLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    [_minimumPriceTitleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:13]];
    //[_minimumPriceTitleLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
    [_minimumPriceTitleLabel setTextColor:[UIColor colorWithRGBHex:0xfdcdba]];
    
    // Like View
    [_likeImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_like"]];
    [_dislikeImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bar_hate"]];
    [_gaugeView setBackgroundColor:LIKE_GAUGE_COLOR];
    
    
    [_gaugeBackgroundView setBackgroundColor:[UIColor colorWithRGBHex:0xebebeb]];
    _gaugeBackgroundView.layer.cornerRadius = 8;
    _gaugeBackgroundView.clipsToBounds = YES;
    _gaugeWidth.constant = 0;
    
    [_likeLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:12]];
    [_likeLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    [_dislikeLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:12]];
    [_dislikeLabel setTextColor:[UIColor colorWithRGBHex:0xb0b0b0]];
    
    [_percentageImageView setImage:[UIImage imageNamed:@"Icon_detail_page_bubble"]];
    
    [_percentageLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:10]];
    [_percentageLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    // Status View
    [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_retentionLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_retentionUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_retentionUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_retentionTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_retentionTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_callLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_callLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_callUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_callUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_callTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_callTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_totalCallLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_totalCallLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_totalCallUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_totalCallUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_totalCallTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_totalCallTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];

    
    // Border
    [_border1 setBackgroundColor:[UIColor colorWithRGBHex:0xececec]];
    [_border2 setBackgroundColor:[UIColor colorWithRGBHex:0xececec]];
    [_border3 setBackgroundColor:[UIColor colorWithRGBHex:0xfdb787]];
    
    // Button View
    _buttonView.layer.cornerRadius = 5;
    _buttonView.layer.borderColor = (__bridge CGColorRef)(MAIN_COLOR.CGColor);
    _buttonView.layer.borderWidth = 1;
    _buttonView.clipsToBounds = YES;
    [_shareImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_share"]];
    [_like_dislikeImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_evalustion"]];
    
    [_likeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_like"]];
    [_dislikeButtonImageView setImage:[UIImage imageNamed:@"Icon_detail_page_btn_hate"]];
    [_likeButtonImageView setHidden:YES];
    [_dislikeButtonImageView setHidden:YES];
    
    [_shareLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:14]];
    [_shareLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_like_dislikeLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:14]];
    [_like_dislikeLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    
    [_noticeImageView setImage:[UIImage imageNamed:@"Icon_list_food_arrow"]];
    [_noticeLabel setFont:[UIFont fontWithName:MAIN_FONT size:10]];
    [_noticeLabel setTextColor:[UIColor colorWithRGBHex:0xa4a4a4]];

}

@end
