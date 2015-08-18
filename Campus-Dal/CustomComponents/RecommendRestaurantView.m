//
//  RecommendRestaurantView.m
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import "RecommendRestaurantView.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "UIColor+COLORCategories.h"

#import "CategoryModel.h"


@interface RecommendRestaurantView(){
    NSMutableDictionary * _categoryImageTitles;
}

@end

@implementation RecommendRestaurantView

@synthesize restaurant=_restaurant;
@synthesize reason=_reason;
@synthesize category=_category;

@synthesize resNewImageView=_resNewImageView;

@synthesize nextButton1=_nextButton1;
@synthesize nextButton2=_nextButton2;

@synthesize titleView=_titleView;
@synthesize resTitleLabel=_resTitleLabel;
@synthesize resSubTitleLabel=_resSubTitleLabel;

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
@synthesize retentionLabel=_retentionLabel;
@synthesize retentionUnitLabel=_retentionUnitLabel;
@synthesize retentionTitleLabel=_retentionTitleLabel;

@synthesize myCallsView=_myCallsView;
@synthesize callLabel=_callLabel;
@synthesize callUnitLabel=_callUnitLabel;
@synthesize callTitleLabel=_callTitleLabel;

@synthesize totalCallsView=_totalCallsView;
@synthesize totalCallLabel=_totalCallLabel;
@synthesize totalCallUnitLabel=_totalCallUnitLabel;
@synthesize totalCallTitleLabel=_totalCallTitleLabel;

@synthesize borderView=_borderView;
@synthesize subBorderView1=_subBorderView1;
@synthesize subBorderView2=_subBorderView2;

@synthesize linkView=_linkView;
@synthesize categoryButton=_categoryButton;
@synthesize categoryLabel=_categoryLabel;
@synthesize flyerButton=_flyerButton;
@synthesize flyerLabel=_flyerLabel;
@synthesize restaurantButton=_restaurantButton;
@synthesize restaurantLabel=_restaurantLabel;

@synthesize buttonView=_buttonView;
@synthesize buttonImageView=_buttonImageView;
@synthesize buttonLabel=_buttonLabel;
@synthesize buttonViewButton=_buttonViewButton;

@synthesize buttonHeightConstraint=_buttonHeightConstraint;

- (void)awakeFromNib{
    self.backgroundColor = LIGHT_BG_COLOR;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        _buttonHeightConstraint.constant = 30;
    }else{
        _buttonHeightConstraint.constant = 45;
    }
    
    // init category Titles
    _categoryImageTitles = [[NSMutableDictionary alloc] init];
    [_categoryImageTitles setObject:@"Icon_card_food_chicken" forKey:@"치킨"];
    [_categoryImageTitles setObject:@"Icon_card_food_pizza" forKey:@"피자"];
    [_categoryImageTitles setObject:@"Icon_card_food_chinese_dishes" forKey:@"중국집"];
    [_categoryImageTitles setObject:@"Icon_card_food_korean_dishes" forKey:@"한식/분식"];
    [_categoryImageTitles setObject:@"Icon_card_food_lunch" forKey:@"도시락/돈까스"];
    [_categoryImageTitles setObject:@"Icon_card_food_jokbal" forKey:@"족발/보쌈"];
    [_categoryImageTitles setObject:@"Icon_card_food_etc" forKey:@"기타"];
    
    // init next Button
    UIImage *arrowImage1 = [UIImage imageNamed:@"Icon_card_arrow_up"];
    UIImage *arrowImage2 = [UIImage imageNamed:@"Icon_card_arrow_down"];
    [_nextButton1 setBackgroundImage:arrowImage1 forState:UIControlStateNormal];
    [_nextButton2 setBackgroundImage:arrowImage2 forState:UIControlStateNormal];
    
    // new image view
    [_resNewImageView setImage:[UIImage imageNamed:@"Icon_card_new"]];
    
    // TitleView
    [_resTitleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:18]];
    [_resTitleLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_resSubTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_resSubTitleLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    // Like View
    [_likeImageView setImage:[UIImage imageNamed:@"Icon_card_bar_like"]];
    [_dislikeImageView setImage:[UIImage imageNamed:@"Icon_card_bar_hate"]];
    [_gaugeView setBackgroundColor:LIKE_GAUGE_COLOR];
    
    [_gaugeBackgroundView setBackgroundColor:[UIColor colorWithRGBHex:0xebebeb]];
    _gaugeBackgroundView.layer.cornerRadius = 8;
    _gaugeBackgroundView.clipsToBounds = YES;
    
    [_likeLabel setFont:[UIFont fontWithName:MAIN_FONT size:9]];
    [_likeLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    [_dislikeLabel setFont:[UIFont fontWithName:MAIN_FONT size:9]];
    [_dislikeLabel setTextColor:[UIColor colorWithRGBHex:0xababab]];
    
    [_percentageImageView setImage:[UIImage imageNamed:@"Icon_card_bubble"]];
    
    [_percentageLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:8]];
    [_percentageLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    
    // Border
    [_subBorderView1 setBackgroundColor:[UIColor colorWithRGBHex:0xececec]];
    [_subBorderView2 setBackgroundColor:[UIColor colorWithRGBHex:0xececec]];
    [_borderView setBackgroundColor:[UIColor colorWithRGBHex:0xececec]];
    
    // Status View
    [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_retentionLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_callLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_callLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_totalCallLabel setFont:[UIFont fontWithName:MAIN_FONT size:22]];
    [_totalCallLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    
    [_retentionUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_retentionUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_callUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_callUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    [_totalCallUnitLabel setFont:[UIFont fontWithName:MAIN_FONT size:17]];
    [_totalCallUnitLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    
    [_retentionTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_retentionTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    [_callTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_callTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    [_totalCallTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:11]];
    [_totalCallTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    // Link View
    [_categoryButton setTitle:@"" forState:UIControlStateNormal];
    [_categoryButton setBackgroundImage:[UIImage imageNamed:@"Icon_card_food_chicken"] forState:UIControlStateNormal];
    [_categoryLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_categoryLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_flyerButton setTitle:@"" forState:UIControlStateNormal];
    [_flyerButton setBackgroundImage:[UIImage imageNamed:@"Icon_card_advertisement_flyer"] forState:UIControlStateNormal];
    [_flyerLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_flyerLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_restaurantButton setTitle:@"" forState:UIControlStateNormal];
    [_restaurantButton setBackgroundImage:[UIImage imageNamed:@"Icon_card_store"] forState:UIControlStateNormal];
    [_restaurantLabel setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_restaurantLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    // Button View
    [_buttonViewButton setBackgroundImage:[UIImage imageNamed:@"Btn_card_normal"] forState:UIControlStateNormal];
    [_buttonViewButton setBackgroundImage:[UIImage imageNamed:@"Btn_card_selected"] forState:UIControlStateHighlighted];
    [_buttonImageView setImage:[UIImage imageNamed:@"Icon_btn_call"]];
    _buttonImageView.userInteractionEnabled = NO;
    [_buttonLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_buttonLabel setTextColor:[UIColor colorWithRGBHex:0xffffff]];
    _buttonLabel.userInteractionEnabled = NO;

}

- (void)initWithRestaurant:(Restaurant *)restaurant reason:(NSString *)reason{
    
    // set Restaurant and Reason
    _restaurant = restaurant;
    _reason = reason;
    // set Category
    NSMutableArray * categoriesArray = [[NSMutableArray alloc] init];
    NSArray * allData = [[StaticHelper staticHelper] allData];
    for(CategoryModel * cat in allData){
        for(Restaurant * res in cat.restaurants){
            if([res isEqual:restaurant]){
                [categoriesArray addObject:cat];
                break;
            }
        }
    }
    NSUInteger randomIndex = arc4random() % [categoriesArray count];
    _category = [categoriesArray objectAtIndex:randomIndex];
    
    _resTitleLabel.text = restaurant.name;
    _resSubTitleLabel.text = reason;
    
    _likeLabel.text = [restaurant.totalNumberOfGoods stringValue];
    _dislikeLabel.text = [restaurant.totalNumberOfBads stringValue];
    
    [_categoryButton setBackgroundImage:[UIImage imageNamed:[_categoryImageTitles objectForKey:_category.title]] forState:UIControlStateNormal];
    [_categoryLabel setText:_category.title];
    
    int percentage = 50;
    if([restaurant.totalNumberOfGoods intValue] != 0 || [restaurant.totalNumberOfBads intValue]!=0){
        double p =[restaurant.totalNumberOfGoods doubleValue] / ([restaurant.totalNumberOfGoods doubleValue] + [restaurant.totalNumberOfBads doubleValue]);
        percentage = (int)(p*100);
    }
    
    _percentageLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    _gaugeWidth.constant = _gaugeBackgroundView.frame.size.width * (((double)percentage)/100.0);
    
    _retentionLabel.text = [restaurant retentionString];
    _callLabel.text = [NSString stringWithFormat:@"%d", [restaurant.numberOfCalls intValue]];
    _totalCallLabel.text = [restaurant estimatedTotalCallString];
    
    _buttonLabel.text = restaurant.phoneNumber;
        
    [self layoutIfNeeded];
}
@end
