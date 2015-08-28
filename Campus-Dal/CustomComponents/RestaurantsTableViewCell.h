//
//  RestaurantsTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantsTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel * retentionLabel;
@property (nonatomic, strong) IBOutlet UILabel * retentionPercentLabel;

@property (nonatomic, strong) IBOutlet UILabel * nameLabel;
@property (nonatomic, strong) IBOutlet UIButton * flyerButton;
@property (nonatomic, strong) IBOutlet UIImageView * flyerImageView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * leftMargin;

@end
