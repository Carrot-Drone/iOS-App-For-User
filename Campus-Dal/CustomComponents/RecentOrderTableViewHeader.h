//
//  CustomTableViewHeader.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RecentOrderTableViewHeader : UIView

@property (nonatomic, strong) IBOutlet UILabel *callLogsLabel;
@property (nonatomic, strong) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *recentOrderLabel;

@property (nonatomic, strong) IBOutlet UIButton * sortByCallLogsButton;
@property (nonatomic, strong) IBOutlet UIButton * sortByNameButton;
@property (nonatomic, strong) IBOutlet UIButton * sortByRecentOrderButton;
@property (nonatomic, strong) IBOutlet UIImageView * sortByCallLogsImageView;
@property (nonatomic, strong) IBOutlet UIImageView * sortByNameImageView;
@property (nonatomic, strong) IBOutlet UIImageView * sortByRecentOrderImageView;

@end
