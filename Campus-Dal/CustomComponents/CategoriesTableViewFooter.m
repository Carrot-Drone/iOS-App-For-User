//
//  CategoriesTableViewFooter.m
//  
//
//  Created by Sukwon Choi on 8/9/15.
//
//

#import "CategoriesTableViewFooter.h"

#import "Constants.h"

#import "UIColor+COLORCategories.h"

@implementation CategoriesTableViewFooter
@synthesize mainContentView=_mainContentView;
@synthesize mainLabel1=_mainLabel1;
@synthesize plusImageView=_plusImageView;
@synthesize mainLabel2=_mainLabel2;
@synthesize subLabel1=_subLabel1;
@synthesize subLabel2=_subLabel2;
@synthesize heightConstraint=_heightConstraint;

- (void)awakeFromNib{
    [_mainLabel1 setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_mainLabel2 setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_mainLabel1 setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_mainLabel2 setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_plusImageView setImage:[UIImage imageNamed:@"Icon_list_food_plus"]];

    
    [_subLabel1 setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_subLabel2 setFont:[UIFont fontWithName:MAIN_FONT size:12]];
    [_subLabel1 setTextColor:[UIColor colorWithRGBHex:0xb3b3b3]];
    [_subLabel2 setTextColor:[UIColor colorWithRGBHex:0xb3b3b3]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height;
    if(screenWidth == 320){
        // iPhone 5
        height = 110;
    }else if(screenWidth == 375){
        // iPhone 6
        height = 110;
    }else if(screenWidth == 414){
        // iPhone 6+
        height = 179;
    }else{
        height = 179;
    }
    _heightConstraint.constant = height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}


@end
