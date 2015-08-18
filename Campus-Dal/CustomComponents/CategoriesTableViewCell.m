//
//  CategoriesTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "CategoriesTableViewCell.h"
#import "UIColor+COLORCategories.h"

#import "Constants.h"

@implementation CategoriesTableViewCell
@synthesize categoryImageView=_categoryImageView;
@synthesize categoryLabel=_categoryLabel;
@synthesize accessoryImageView=_accessoryImageView;

- (void)awakeFromNib {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        [_categoryLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
        
    }else{
        [_categoryLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
    }
    
    [_accessoryImageView setImage:[UIImage imageNamed:@"Icon_list_food_arrow"]];
    [_categoryLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
