//
//  RestaurantsTableViewHeader.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RestaurantsTableViewHeader.h"

#import "UIColor+COLORCategories.h"

#import "Constants.h"

@implementation RestaurantsTableViewHeader{
}
@synthesize officeHoursButton=_officeHoursButton;
@synthesize flyerButton=_flyerButton;

@synthesize retentionLabel=_retentionLabel;
@synthesize officeHoursLabel=_officeHoursLabel;
@synthesize flyerLabel=_flyerLabel;

@synthesize officeHoursImageView=_officeHoursImageView;
@synthesize flyerImageView=_flyerImageView;

@synthesize officeHoursButtonSelected=_officeHoursButtonSelected;
@synthesize flyerButtonSelected=_flyerButtonSelected;

@synthesize imageWidth1=_imageWidth1;
@synthesize imageWidth2=_imageWidth2;


-(void)awakeFromNib{
    self.backgroundColor = SECTION_HEADER_BG_COLOR;
    
    _officeHoursButtonSelected = YES;
    _flyerButtonSelected = YES;
    [self officeHoursButtonClicked:self];
    [self flyerButtonClicked:self];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if(screenWidth == 320){
        // If iPhone 4, 5
        [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:10]];
        [_officeHoursLabel setFont:[UIFont fontWithName:MAIN_FONT size:10]];
        [_flyerLabel setFont:[UIFont fontWithName:MAIN_FONT size:10]];
        _imageWidth1.constant = 10;
        _imageWidth2.constant = 10;

    }else{
        [_retentionLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
        [_officeHoursLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
        [_flyerLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    }
    
    [_retentionLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_officeHoursLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_flyerLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
}

- (void)officeHoursButtonClicked:(id)sender{
    _officeHoursButtonSelected = !_officeHoursButtonSelected;
    if(_officeHoursButtonSelected){
        [_officeHoursImageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_selected"]];
    }else{
        [_officeHoursImageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_normal"]];
    }
}
- (void)flyerButtonClicked:(id)sender{
    _flyerButtonSelected = !_flyerButtonSelected;
    if(_flyerButtonSelected){
        [_flyerImageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_selected"]];
    }else{
        [_flyerImageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_normal"]];
    }
}

@end
