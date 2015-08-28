//
//  RestaurantFooterView.h
//  
//
//  Created by Sukwon Choi on 8/11/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantFooterView : UIView

@property (nonatomic, strong) IBOutlet UIView * flyerView;
@property (nonatomic, strong) IBOutlet UIImageView * flyerImageView;
@property (nonatomic, strong) IBOutlet UIButton * flyerButton;

@property (nonatomic, strong) IBOutlet UIImageView * phoneCallImageView;
@property (nonatomic, strong) IBOutlet UILabel * phoneNumberLabel;
@property (nonatomic, strong) IBOutlet UIButton * phoneCallButton;

@property (nonatomic, strong) IBOutlet UIView * borderView;

- (void)removeFlyerButton;

@end
