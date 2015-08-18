//
//  RestaurantSuggestionCompleteViewController.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RestaurantSuggestionCompleteViewController.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@interface RestaurantSuggestionCompleteViewController (){
    BOOL _isByUser;
}

@end

@implementation RestaurantSuggestionCompleteViewController
@synthesize contentView=_contentView;
@synthesize mainTitleLabel=_mainTitleLabel;
@synthesize imageView=_imageView;
@synthesize subTitleLabel=_subTitleLabel;
@synthesize detailLabel1=_detailLabel1;
@synthesize detailLabel2=_detailLabel2;
@synthesize confirmButton=_confirmButton;

@synthesize heightConstraint=_heightConstraint;

- (void)setDetailItem:(BOOL)isByUser{
    _isByUser = isByUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init View
    [_contentView setBackgroundColor:DARK_BACKGROUND];
    [_imageView setImage:[UIImage imageNamed:@"Icon_popup_good"]];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"Btn_popup_normal"] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"Btn_popup_pressed"] forState:UIControlStateHighlighted];
    
    [_mainTitleLabel setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:22]];
    [_mainTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_subTitleLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
    [_subTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    
    [_detailLabel1 setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_detailLabel1 setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    [_detailLabel2 setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_detailLabel2 setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    
    [[_confirmButton titleLabel] setFont:[UIFont fontWithName:MAIN_FONT_BOLD size:15]];
    [_confirmButton setTitleColor:[UIColor colorWithRGBHex:0xffffff] forState:UIControlStateNormal];
    
    if(_isByUser){
        _mainTitleLabel.text = @"제보해주셔서 감사합니다!";
        _subTitleLabel.text = @"캠퍼스:달에서 해당음식점을 확인하고 빠른 시일내에 추가하겠습니다";
        _heightConstraint.constant = 365;
        [_detailLabel1 removeFromSuperview];
        [_detailLabel2 removeFromSuperview];
        [self.view layoutIfNeeded];
    }else{
        _mainTitleLabel.text = @"등록해주셔서 감사합니다!";
        _subTitleLabel.text = @"캠퍼스:달에서 해당음식점을 확인하고 빠른 시일내에 추가하겠습니다";
        _heightConstraint.constant = 391;
        [self.view layoutIfNeeded];
    }
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Clicked
- (void)confirmButtonClicked:(id)sender{
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
