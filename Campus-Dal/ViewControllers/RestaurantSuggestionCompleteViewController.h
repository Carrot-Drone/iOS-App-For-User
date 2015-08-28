//
//  RestaurantSuggestionCompleteViewController.h
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantSuggestionCompleteViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView * contentView;
@property (nonatomic, strong) IBOutlet UILabel * mainTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) IBOutlet UILabel * subTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel1;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel2;
@property (nonatomic, strong) IBOutlet UIButton * confirmButton;

@property (nonatomic, strong)IBOutlet NSLayoutConstraint * heightConstraint;

- (void)setDetailItem:(BOOL)isByUser;


@end
