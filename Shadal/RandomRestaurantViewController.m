//
//  RandomRestaurantViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 8/12/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "RandomRestaurantViewController.h"
#include "stdlib.h"

@interface RandomRestaurantViewController ()

@end

@implementation RandomRestaurantViewController
@synthesize restaurant, titleLabel, phoneNumber;
@synthesize favorite;
@synthesize tableView;


- (void)updateUI{
    self.titleLabel.text = [restaurant name];
    [phoneNumber setTitle:[restaurant phoneNumber] forState:UIControlStateNormal];
    
    // set Flyer Button
    if(restaurant.has_flyer){
        /*
         UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
         [button1 setFrame:CGRectMake(10.0, 2.0, 30.0, 30.0)];
         [button1 addTarget:self action:@selector(flyerClicked:) forControlEvents:UIControlEventTouchUpInside];
         [button1 setImage:[UIImage imageNamed:@"flyer"] forState:UIControlStateNormal];
         barButton = [[UIBarButtonItem alloc]initWithCustomView:button1];
         barButton.style = UIBarButtonItemStyleBordered;
         barButton.enabled = YES;
         
         self.navigationItem.rightBarButtonItem = barButton;
         */
    }
    
    // set Coupon String
    if(restaurant.has_coupon){
        UILabel * couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [couponLabel setText:restaurant.couponString];
        couponLabel.numberOfLines = 5;
        couponLabel.baselineAdjustment = YES;
        couponLabel.adjustsFontSizeToFitWidth = YES;
        couponLabel.minimumScaleFactor = 0.8;
        couponLabel.clipsToBounds = YES;
        couponLabel.backgroundColor = [UIColor clearColor];
        couponLabel.textAlignment = NSTextAlignmentCenter;
    
        self.tableView.tableHeaderView = couponLabel;
    }
    
    // set Favorite
    if(restaurant.isFavorite){
        [favorite setBackgroundImage:[UIImage imageNamed:@"coupon.png"] forState:UIControlStateNormal];
    }else{
        [favorite setBackgroundImage:[UIImage imageNamed:@"flyer.png"] forState:UIControlStateNormal];
    }
    
    [tableView reloadData];
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
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    self.restaurant = [self randomRestaurant];
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!restaurant.menu==nil)
        return [restaurant.menu count];
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![restaurant.menu count]==0)
        return [[[restaurant.menu objectAtIndex:section] objectAtIndex:1] count];
    else return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(![restaurant.menu count]==0)
        return [[restaurant.menu objectAtIndex:section] objectAtIndex:0];
    else return @"";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (Restaurant *)randomRestaurant{
    NSDictionary * allData = [(AppDelegate *)[[UIApplication sharedApplication] delegate] allData];
    
    // 전체 음식점 갯수
    int cnt = 0;
    for(id key in allData){
        cnt += [[allData objectForKey:key] count];
    }
    int r = arc4random() % cnt;
    NSLog(@"random number r : %d", r);
    
    Restaurant * res;
    NSLog(@"start");
    for(id key in allData){
        NSString* category = key;
        if([[allData objectForKey:category] count] <= r){
            r -= [[allData objectForKey:category] count];
        }else{
            res = [[allData objectForKey:category] objectAtIndex:r];
            break;
        }
    }
    return res;
}

@end
