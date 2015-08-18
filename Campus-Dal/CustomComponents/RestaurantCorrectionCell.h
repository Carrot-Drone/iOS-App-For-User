//
//  RestaurantCorrectionTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantCorrectionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) IBOutlet UIButton * checkButton;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;

@property (nonatomic, strong) IBOutlet UITextView * textView;

@property (nonatomic, strong) IBOutlet UIImageView * sectionImageView;
@property (nonatomic, strong) IBOutlet UILabel * sectionTitleLabel;

@property (nonatomic) BOOL isSelected;
@end
