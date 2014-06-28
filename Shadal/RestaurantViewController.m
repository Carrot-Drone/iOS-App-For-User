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
#import "Server.h"
#import "Constants.h"

#import "AppDelegate.h"

@interface RestaurantViewController ()  

@end

@implementation RestaurantViewController
@synthesize tableView;
@synthesize restaurant, titleLabel, phoneNumber;
@synthesize barButton;

- (void)setDetailItem:(id)detailItem{
    restaurant = (Restaurant *)detailItem;
    restaurant.phoneNumber = [restaurant.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(restaurant.updated_at == nil){
        restaurant.updated_at = @"00:00";
    }
}

- (void)updateUI{
    self.titleLabel.text = [restaurant name];
    [phoneNumber setTitle:[restaurant phoneNumber] forState:UIControlStateNormal];
    
    // set Flyer Button
    if(restaurant.flyer){
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setFrame:CGRectMake(10.0, 2.0, 30.0, 30.0)];
        [button1 addTarget:self action:@selector(flyerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setImage:[UIImage imageNamed:@"flyer"] forState:UIControlStateNormal];
        barButton = [[UIBarButtonItem alloc]initWithCustomView:button1];
        barButton.style = UIBarButtonItemStyleBordered;
        barButton.enabled = YES;
        
        self.navigationItem.rightBarButtonItem = barButton;
    }
    
    // set Coupon String
    if(restaurant.coupon){
        UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [couponLabel setText:restaurant.couponString];
        couponLabel.numberOfLines = 5;
        couponLabel.baselineAdjustment = YES;
        couponLabel.adjustsFontSizeToFitWidth = YES;
        couponLabel.minimumScaleFactor = 0.8;
        couponLabel.clipsToBounds = YES;
        couponLabel.backgroundColor = [UIColor clearColor];
        couponLabel.textAlignment = NSTextAlignmentCenter;
        
        tableView.tableHeaderView = couponLabel;
    }
    
    [tableView reloadData];
}

- (void)updateViewData{
    [Server updateRestaurant:restaurant];
}

- (IBAction)call:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * params = [NSString stringWithFormat:@"name=%@&phoneNumber=%@&device=ios&campus=%@", restaurant.name, restaurant.phoneNumber, CAMPUS];
    [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"callBool"];
    [prefs setObject:params forKey:@"params"];
    
    NSString * urlString = [NSString stringWithFormat:@"tel://%@", restaurant.phoneNumber];
    NSURL * url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
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
    [super viewDidLoad];
    [self updateUI];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self updateViewData];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self updateUI];
        });
    });
    
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    // myNotificationCenter 객체를 이용해서 옵저버 등록, “firstNotification” 이름의 노티피케이션이
    // 전송되면 노티피케이션을 받아 셀렉터를 이용하여 메서드 실행
    [sendNotification addObserver:self selector:@selector(updateUI) name:@"updateUI" object: nil];
}
- (void)viewWillAppear:(BOOL)animated{
}

- (void)flyerClicked:(id)sender{
    [self performSegueWithIdentifier:@"Flyer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Flyer"]) {
        [[segue destinationViewController] setDetailItem:restaurant];
    }
}
#pragma ma`rk - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [restaurant.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[restaurant.menu objectAtIndex:section] objectAtIndex:1] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[restaurant.menu objectAtIndex:section] objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuCell *cell = (MenuCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    NSArray * menuArray = [[[restaurant.menu objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.menuLabel.text = [menuArray objectAtIndex:0];
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)[[menuArray objectAtIndex:1] integerValue]]
    ;
    if([cell.priceLabel.text isEqualToString:@"0"]){
        cell.priceLabel.text = @"";
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"%@원", cell.priceLabel.text];
    }
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end