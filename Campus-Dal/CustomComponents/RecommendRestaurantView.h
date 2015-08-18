//
//  RecommendRestaurantView.h
//  
//
//  Created by Sukwon Choi on 8/10/15.
//
//

#import <UIKit/UIKit.h>

#import "Restaurant.h"
#import "CategoryModel.h"


@interface RecommendRestaurantView : UIView

@property (nonatomic, strong) Restaurant * restaurant;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) CategoryModel * category;

@property (nonatomic, strong) IBOutlet UIImageView * resNewImageView;

@property (nonatomic, strong) IBOutlet UIButton * nextButton1;
@property (nonatomic, strong) IBOutlet UIButton * nextButton2;

@property (nonatomic, strong) IBOutlet UIView * titleView;
@property (nonatomic, strong) IBOutlet UILabel * resTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel * resSubTitleLabel;

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

@property (nonatomic, strong) IBOutlet UIView * borderView;
@property (nonatomic, strong) IBOutlet UIView * subBorderView1;
@property (nonatomic, strong) IBOutlet UIView * subBorderView2;

@property (nonatomic, strong) IBOutlet UIView * linkView;
@property (nonatomic, strong) IBOutlet UIButton * categoryButton;
@property (nonatomic, strong) IBOutlet UILabel * categoryLabel;
@property (nonatomic, strong) IBOutlet UIButton * flyerButton;
@property (nonatomic, strong) IBOutlet UILabel * flyerLabel;
@property (nonatomic, strong) IBOutlet UIButton * restaurantButton;
@property (nonatomic, strong) IBOutlet UILabel * restaurantLabel;

@property (nonatomic, strong) IBOutlet UIView * buttonView;
@property (nonatomic, strong) IBOutlet UIImageView * buttonImageView;
@property (nonatomic, strong) IBOutlet UILabel * buttonLabel;
@property (nonatomic, strong) IBOutlet UIButton *buttonViewButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * buttonHeightConstraint;

- (void)initWithRestaurant:(Restaurant *)restaurant reason:(NSString *)reason;

@end
