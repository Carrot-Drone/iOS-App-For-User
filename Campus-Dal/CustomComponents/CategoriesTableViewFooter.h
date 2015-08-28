//
//  CategoriesTableViewFooter.h
//  
//
//  Created by Sukwon Choi on 8/9/15.
//
//

#import <UIKit/UIKit.h>

@interface CategoriesTableViewFooter : UIView

@property (nonatomic, strong) IBOutlet UIView * mainContentView;
@property (nonatomic, strong) IBOutlet UILabel * mainLabel1;
@property (nonatomic, strong) IBOutlet UIImageView * plusImageView;
@property (nonatomic, strong) IBOutlet UILabel * mainLabel2;
@property (nonatomic, strong) IBOutlet UILabel * subLabel1;
@property (nonatomic, strong) IBOutlet UILabel * subLabel2;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;

@end
