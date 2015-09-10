//
//  RestaurantsTableViewHeader.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantsTableViewHeader : UIView

@property (nonatomic, strong) IBOutlet UIButton * officeHoursButton;
@property (nonatomic, strong) IBOutlet UIButton * flyerButton;

@property (nonatomic, strong) IBOutlet UILabel * retentionLabel;
@property (nonatomic, strong) IBOutlet UILabel * officeHoursLabel;
@property (nonatomic, strong) IBOutlet UILabel * flyerLabel;

@property (nonatomic, strong) IBOutlet UIImageView * officeHoursImageView;
@property (nonatomic, strong) IBOutlet UIImageView * flyerImageView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * imageWidth1;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * imageWidth2;

@property (nonatomic) BOOL officeHoursButtonSelected;
@property (nonatomic) BOOL flyerButtonSelected;


- (void)officeHoursButtonClicked:(id)sender;
- (void)flyerButtonClicked:(id)sender;

@end
