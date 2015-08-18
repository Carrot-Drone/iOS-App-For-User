//
//  CustomTableViewSection.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RestaurantSuggestionSectionView.h"

#import "Constants.h"

@implementation RestaurantSuggestionSectionView

@synthesize imageView=_imageView;
@synthesize titleLabel=_titleLabel;
@synthesize detailLabel=_detailLabel;
@synthesize mendatoryLabel=_mendatoryLabel;

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    
    _titleLabel.textColor = DARK_GRAY;
    _detailLabel.textColor = DARK_GRAY;
    _mendatoryLabel.textColor = POINT_COLOR;
}

@end
