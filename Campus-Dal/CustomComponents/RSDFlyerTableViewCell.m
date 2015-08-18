//
//  RSFlyerTableViewCell.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RSDFlyerTableViewCell.h"
#import "UIColor+COLORCategories.h"
#import "Constants.h"

@implementation RSDFlyerTableViewCell
@synthesize imageView1=_imageView1;
@synthesize imageView2=_imageView2;
@synthesize imageView3=_imageView3;
@synthesize imageView4=_imageView4;

@synthesize smallImageView1=_smallImageView1;
@synthesize smallImageView2=_smallImageView2;
@synthesize smallImageView3=_smallImageView3;
@synthesize smallImageView4=_smallImageView4;

@synthesize deleteButton1=_deleteButton1;
@synthesize deleteButton2=_deleteButton2;
@synthesize deleteButton3=_deleteButton3;
@synthesize deleteButton4=_deleteButton4;

@synthesize button1=_button1;
@synthesize button2=_button2;
@synthesize button3=_button3;
@synthesize button4=_button4;

- (void)awakeFromNib {
    [_imageView1 setBackgroundColor:[UIColor colorWithRGBHex:0xdedede]];
    [_imageView2 setBackgroundColor:[UIColor colorWithRGBHex:0xdedede]];
    [_imageView3 setBackgroundColor:[UIColor colorWithRGBHex:0xdedede]];
    [_imageView4 setBackgroundColor:[UIColor colorWithRGBHex:0xdedede]];
    
    [_smallImageView1 setImage:[UIImage imageNamed:@"Icon_add_plus"]];
    [_smallImageView2 setImage:[UIImage imageNamed:@"Icon_add_plus"]];
    [_smallImageView3 setImage:[UIImage imageNamed:@"Icon_add_plus"]];
    [_smallImageView4 setImage:[UIImage imageNamed:@"Icon_add_plus"]];
    
    [_deleteButton1 setBackgroundImage:[UIImage imageNamed:@"Icon_add_delete"] forState:UIControlStateNormal];
    [_deleteButton2 setBackgroundImage:[UIImage imageNamed:@"Icon_add_delete"] forState:UIControlStateNormal];
    [_deleteButton3 setBackgroundImage:[UIImage imageNamed:@"Icon_add_delete"] forState:UIControlStateNormal];
    [_deleteButton4 setBackgroundImage:[UIImage imageNamed:@"Icon_add_delete"] forState:UIControlStateNormal];
    
    [_deleteButton1 setHidden:YES];
    [_deleteButton2 setHidden:YES];
    [_deleteButton3 setHidden:YES];
    [_deleteButton4 setHidden:YES];
    [_deleteButton1 setUserInteractionEnabled:NO];
    [_deleteButton2 setUserInteractionEnabled:NO];
    [_deleteButton3 setUserInteractionEnabled:NO];
    [_deleteButton4 setUserInteractionEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
