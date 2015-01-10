//
//  RestaurantViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 6..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "RestaurantViewController.h"
#import "FlyerViewController.h"
#import "MenuCell.h"
#import "RestaurantCell.h"
#import "Server.h"
#import "Constants.h"

#import "AppDelegate.h"
#import "UIImage+IMAGECategories.h"

#include "stdlib.h"

@interface RestaurantViewController ()  

@end

@implementation RestaurantViewController
@synthesize tableView;
@synthesize restaurant, phoneNumber, openingTimeLabel;
@synthesize barButton;
@synthesize favorite;
@synthesize isFromRandom;

- (void)setDetailItem:(id)detailItem{
    restaurant = (Restaurant *)detailItem;
    restaurant.phoneNumber = [restaurant.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(restaurant.updated_at == nil){
        restaurant.updated_at = @"00:00";
    }
}

- (void)updateUI{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    
    self.navigationItem.title = restaurant.name;
    [phoneNumber setTitle:[restaurant phoneNumber] forState:UIControlStateNormal];
    [phoneNumber.titleLabel setFont:SEOUL_FONT_EB(19.5)];
    [phoneNumber setTintColor:[UIColor whiteColor]];
    
    [openingTimeLabel setFont:SEOUL_FONT_EB(11.0)];
    [openingTimeLabel setText:[restaurant stringWithOpenAndClosingHours]];
    
    // set Coupon String
    if(restaurant.has_coupon){
        UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        [couponLabel setText:restaurant.couponString];
        couponLabel.font = SEOUL_FONT_EB(18);
        couponLabel.numberOfLines = 5;
        couponLabel.baselineAdjustment = YES;
        couponLabel.adjustsFontSizeToFitWidth = YES;
        couponLabel.minimumScaleFactor = 0.8;
        couponLabel.clipsToBounds = YES;
        couponLabel.backgroundColor = [UIColor clearColor];
        
        // set line space
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:couponLabel.text];
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [couponLabel.text length])];
        
        couponLabel.attributedText = attributedString ;
        couponLabel.textAlignment = NSTextAlignmentCenter;

        self.tableView.tableHeaderView = couponLabel;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    
    // set Favorite
    if(restaurant.isFavorite){
        [favorite setBackgroundImage:[UIImage imageNamed:@"StarOn.png"] forState:UIControlStateNormal];
    }else{
        [favorite setBackgroundImage:[UIImage imageNamed:@"StarOff.png"] forState:UIControlStateNormal];
    }
    
    [tableView reloadData];
}

- (void)updateViewData{
    [Server updateRestaurant:restaurant];
}

- (IBAction)call:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * params = [NSString stringWithFormat:@"name=%@&phoneNumber=%@&device=ios&campus=%@", restaurant.name, restaurant.phoneNumber, s_campus];
    [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"callBool"];
    [prefs setObject:params forKey:@"params"];
    
    NSString * urlString = [NSString stringWithFormat:@"tel://%@", restaurant.phoneNumber];
    NSURL * url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}
-(IBAction)favoriteButtonClicked:(id)sender{
    restaurant.isFavorite = !restaurant.isFavorite;
    [self updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:BACKGROUND_COLOR];
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    // myNotificationCenter 객체를 이용해서 옵저버 등록
    [sendNotification addObserver:self selector:@selector(updateUI) name:@"updateUI" object: nil];
    
//    self.phoneNumber.backgroundColor = [UIColor colorWithRed:73/255.0 green:196/255.0 blue:57/255.0 alpha:1.0];
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [self updateUI];
    if(!self.isFromRandom){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateViewData];
        });
    }
}

- (void)flyerClicked:(id)sender{
    if(restaurant.has_flyer == NO){
        NSLog(@"Restaurant doesn't have any flyers ");
        return;
    }
    [self performSegueWithIdentifier:@"Flyer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Flyer"]) {
        FlyerViewController * flyerViewController = (FlyerViewController *)[segue destinationViewController];
        [flyerViewController setDetailItem:self.restaurant];
    }
}
#pragma ma`rk - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger num;
    if(!(restaurant.menu==nil))
        num = [restaurant.menu count];
    else num = 0;
    
    // 전단지가 있을 경우
    if(restaurant.has_flyer){
        num++;
    }
    return num;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // '전단지' section
    if(restaurant.has_flyer){
        if(section == 0) return 1;
        
        section -= 1;
    }
    
    if(![restaurant.menu count]==0)
        return [[[restaurant.menu objectAtIndex:section] objectAtIndex:1] count];
    else return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // '전단지' section
    if(restaurant.has_flyer){
        if(section == 0) return @"전단지";
        
        section -= 1;
    }
    
    if(![restaurant.menu count]==0)
        return [[restaurant.menu objectAtIndex:section] objectAtIndex:0];
    else return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    NSInteger section = indexPath.section;
    // 전단지 보기
    if(restaurant.has_flyer){
        if(section == 0){
            RestaurantCell * cell;
            
            if(cell == nil){
                NSArray * array;
                array = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:nil options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.restaurantLabel.text = @"전단지 보기";
            cell.firstImage.hidden = YES;
            cell.secondImage.hidden = YES;
            cell.thirdImage.hidden = YES;
            cell.forthImage.image = [UIImage imageNamed:@"flyerBlack"];
            return cell;
        }
        
        section -= 1;
    }
    MenuCell *cell = (MenuCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    NSArray * menuArray = [[[restaurant.menu objectAtIndex:section] objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.menuLabel.text = [menuArray objectAtIndex:0];
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)[[menuArray objectAtIndex:1] integerValue]]
    ;
    if([cell.priceLabel.text isEqualToString:@"0"]){
        cell.priceLabel.text = @"";
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"%@원", cell.priceLabel.text];
    }
    // 자간 조절
    [cell setFontAttribute];
    
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = BACKGROUND_COLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(restaurant.has_flyer){
        if(indexPath.section==0 && indexPath.row==0){
            [self flyerClicked:self];
        }
    }
}

@end