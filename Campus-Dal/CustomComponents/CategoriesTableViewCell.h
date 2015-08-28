//
//  CategoriesTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface CategoriesTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView * categoryImageView;
@property (nonatomic, strong) IBOutlet UILabel * categoryLabel;

@property (nonatomic, strong) IBOutlet UIImageView * accessoryImageView;

@end
