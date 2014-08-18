//
//  RestaurantCell.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Restaurant.h"
#import "RestaurantCell.h"

@implementation RestaurantCell
@synthesize restaurantLabel;
@synthesize firstImage,secondImage,thirdImage,forthImage;

- (void)awakeFromNib
{
    // set default font
    UIFont * customFont = [UIFont fontWithName:@"SeN-CL" size:19.5];
    if(customFont == nil) NSLog(@"Font not exist");
    
    [restaurantLabel setFont:customFont];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)setResIcons:(Restaurant *)res{
    RestaurantCell * cell = self;
    if(res.has_flyer){
        cell.forthImage.hidden = NO;
        cell.forthImage.image = [UIImage imageNamed:@"flyer"];
        if(res.has_coupon){
            if(res.isFavorite){
                if(res.is_new){
                    cell.firstImage.hidden = NO;
                    cell.firstImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
                }else{
                    cell.firstImage.hidden = YES;
                    return;
                }
            }else if(res.is_new){
                cell.secondImage.hidden = NO;
                cell.secondImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
                
                cell.firstImage.hidden = YES;
                return;
            }else{
                cell.firstImage.hidden = YES;
                cell.secondImage.hidden = YES;
                return;
            }
        }else if(res.isFavorite){
            cell.thirdImage.hidden = NO;
            cell.thirdImage.image = [UIImage imageNamed:@"StarOnList"];
            if(res.is_new){
                cell.secondImage.hidden = NO;
                cell.secondImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
                
                cell.firstImage.hidden = YES;
                return;
            }else{
                cell.firstImage.hidden = YES;
                cell.secondImage.hidden = YES;
                return;
            }
        }else if(res.is_new){
            cell.thirdImage.hidden = NO;
            cell.thirdImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
            
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            return;
        }else{
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            cell.thirdImage.hidden = YES;
            return;
        }
    }else if(res.has_coupon){
        cell.forthImage.hidden = NO;
        cell.forthImage.image = [UIImage imageNamed:@"coupon"];
        if(res.isFavorite){
            cell.thirdImage.hidden = NO;
            cell.thirdImage.image = [UIImage imageNamed:@"StarOnList"];
            if(res.is_new){
                cell.secondImage.hidden = NO;
                cell.secondImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
                
                cell.firstImage.hidden = YES;
                return;
            }else{
                cell.firstImage.hidden = YES;
                cell.secondImage.hidden = YES;
                return;
            }
        }else if(res.is_new){
            cell.thirdImage.hidden = NO;
            cell.thirdImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
            
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            return;
        }else{
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            cell.thirdImage.hidden = YES;
            return;
        }
    }else if(res.isFavorite){
        cell.forthImage.hidden = NO;
        cell.forthImage.image = [UIImage imageNamed:@"StarOnList"];
        if(res.is_new){
            cell.thirdImage.hidden = NO;
            cell.thirdImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
            
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            return;
        }else{
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            cell.thirdImage.hidden = YES;
            return;
        }
    }else if(res.is_new){
        cell.forthImage.hidden = NO;
        cell.forthImage.image = [UIImage imageNamed:@"StarOnList"]; //NEW
        
        cell.firstImage.hidden = YES;
        cell.secondImage.hidden = YES;
        cell.thirdImage.hidden = YES;
        return;
    }else{
        cell.firstImage.hidden = YES;
        cell.secondImage.hidden = YES;
        cell.thirdImage.hidden = YES;
        cell.forthImage.hidden = YES;
        return;
    }
}
@end
