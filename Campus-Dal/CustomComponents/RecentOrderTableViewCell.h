//
//  CustomTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RecentOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel * numberOfCallsLabel;
@property (nonatomic, strong) IBOutlet UILabel * restaurantLabel;
@property (nonatomic, strong) IBOutlet UIButton * phoneCallButton;

@end
