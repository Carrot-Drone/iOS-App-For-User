//
//  MenuTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/11/15.
//
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel * menuNameLabel;
@property (nonatomic, strong) IBOutlet UILabel * menuPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel * menuDetailLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * detailLabelHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * detailLabelTop;

@end
