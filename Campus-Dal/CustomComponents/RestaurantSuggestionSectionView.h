//
//  CustomTableViewSection.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RestaurantSuggestionSectionView : UIView

@property (nonatomic, strong) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * detailLabel;
@property (nonatomic, strong) IBOutlet UILabel * mendatoryLabel;

@end
