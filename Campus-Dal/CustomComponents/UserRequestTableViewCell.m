//
//  UserRequestTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/7/15.
//
//

#import "UserRequestTableViewCell.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation UserRequestTableViewCell
@synthesize sectionImage=_sectionImage;
@synthesize sectionLabel=_sectionLabel;
@synthesize emailTextField=_emailTextField;
@synthesize requestTextView=_requestTextView;

- (void)awakeFromNib {
    if(_emailTextField != nil){
        self.backgroundColor = TAB_BAR_BG_COLOR;
        self.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0].CGColor;
        self.layer.borderWidth = 1;
        
    }else{
        _requestTextView.backgroundColor = TAB_BAR_BG_COLOR;
        _requestTextView.layer.cornerRadius = 5;
        _requestTextView.clipsToBounds = YES;
        _requestTextView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0].CGColor;
        _requestTextView.layer.borderWidth = 1;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
