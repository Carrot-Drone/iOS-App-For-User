//
//  RestaurantTableViewHeader.h
//  
//
//  Created by Sukwon Choi on 8/8/15.
//
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantTableViewHeader : UIView

@property (nonatomic, strong) IBOutlet UIView * topView;
@property (nonatomic, strong) IBOutlet UIImageView * officeDotImageView;
@property (nonatomic, strong) IBOutlet UILabel * officeHourTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * officeHourLabel;
@property (nonatomic, strong) IBOutlet UIImageView * minimumPriceDotImageView;
@property (nonatomic, strong) IBOutlet UILabel * minimumPriceTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * minimumPriceLabel;

@property (nonatomic, strong) IBOutlet UIView * likeView;
@property (nonatomic, strong) IBOutlet UIImageView * likeImageView;
@property (nonatomic, strong) IBOutlet UILabel * likeLabel;
@property (nonatomic, strong) IBOutlet UIImageView * dislikeImageView;
@property (nonatomic, strong) IBOutlet UILabel * dislikeLabel;
@property (nonatomic, strong) IBOutlet UIView * gaugeBackgroundView;
@property (nonatomic, strong) IBOutlet UIView * gaugeView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * gaugeWidth;
@property (nonatomic, strong) IBOutlet UIImageView * percentageImageView;
@property (nonatomic, strong) IBOutlet UILabel * percentageLabel;

@property (nonatomic, strong) IBOutlet UIView * statusView;
@property (nonatomic, strong) IBOutlet UIView * retentionView;
@property (nonatomic, strong) IBOutlet UILabel * retentionLabel;
@property (nonatomic, strong) IBOutlet UILabel * retentionUnitLabel;
@property (nonatomic, strong) IBOutlet UILabel * retentionTitleLabel;
@property (nonatomic, strong) IBOutlet UIView * myCallsView;
@property (nonatomic, strong) IBOutlet UILabel * callLabel;
@property (nonatomic, strong) IBOutlet UILabel * callUnitLabel;
@property (nonatomic, strong) IBOutlet UILabel * callTitleLabel;
@property (nonatomic, strong) IBOutlet UIView * totalCallsView;
@property (nonatomic, strong) IBOutlet UILabel * totalCallLabel;
@property (nonatomic, strong) IBOutlet UILabel * totalCallUnitLabel;
@property (nonatomic, strong) IBOutlet UILabel * totalCallTitleLabel;

@property (nonatomic, strong) IBOutlet UIView * border1;
@property (nonatomic, strong) IBOutlet UIView * border2;
@property (nonatomic, strong) IBOutlet UIView * border3;

@property (nonatomic, strong) IBOutlet UIView * buttonView;
@property (nonatomic, strong) IBOutlet UIView * leftView;
@property (nonatomic, strong) IBOutlet UIButton * shareButton;
@property (nonatomic, strong) IBOutlet UIImageView * shareImageView;
@property (nonatomic, strong) IBOutlet UILabel * shareLabel;

@property (nonatomic, strong) IBOutlet UIView * rightView;
@property (nonatomic, strong) IBOutlet UIButton * evaluationButton;
@property (nonatomic, strong) IBOutlet UIImageView * like_dislikeImageView;
@property (nonatomic, strong) IBOutlet UILabel * like_dislikeLabel;
@property (nonatomic, strong) IBOutlet UIButton * likeButton;
@property (nonatomic, strong) IBOutlet UIImageView * likeButtonImageView;
@property (nonatomic, strong) IBOutlet UIButton * dislikeButton;
@property (nonatomic, strong) IBOutlet UIImageView * dislikeButtonImageView;

@property (nonatomic, strong) IBOutlet UIView * noticeView;
@property (nonatomic, strong) IBOutlet UIImageView * noticeImageView;
@property (nonatomic, strong) IBOutlet UILabel * noticeLabel;

- (void)initWithRestaurant:(Restaurant *)restaurant;

@end
