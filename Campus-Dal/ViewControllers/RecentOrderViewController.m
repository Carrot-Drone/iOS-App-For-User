//
//  FirstViewController.m
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#import "RecentOrderViewController.h"

#import "RestaurantViewController.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "Campus.h"
#import "CategoryModel.h"
#import "Restaurant.h"

#import "CustomTitleView.h"
#import "RecentOrderTableViewCell.h"

#import "UIColor+COLORCategories.h"


@interface RecentOrderViewController (){
    NSMutableArray * _restaurants;
    Restaurant * _selectedRestaurant;
    NSString * _currentPhoneNumber;
    int _sortBy;
    
}

@end

@implementation RecentOrderViewController
@synthesize tableView=_tableView;
@synthesize placeHolderLabel=_placeHolderLabel;
@synthesize fixedTableViewHeader=_fixedTableViewHeader;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init tableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // init navigation controller
    [self initNavigationController];
    
    // init Restaurants
    [self reloadRestaurants];
    
    // init placeholder Label
    [_placeHolderLabel setFont:[UIFont fontWithName:MAIN_FONT size:16]];
    [_placeHolderLabel setTextColor:[UIColor colorWithRGBHex:0xfb7010]];
    
    // init fixed Table View Header
    [_fixedTableViewHeader.sortByCallLogsButton addTarget:self action:@selector(sortByCallLogsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fixedTableViewHeader.sortByNameButton addTarget:self action:@selector(sortByNameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fixedTableViewHeader.sortByRecentOrderButton addTarget:self action:@selector(sortByRecentOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fixedTableViewHeader.sortByCallLogsImageView setHidden:YES];
    [_fixedTableViewHeader.sortByNameImageView setHidden:YES];
    [_fixedTableViewHeader.sortByRecentOrderImageView setHidden:NO];
    _sortBy = 3;
    
    
    
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadRecentOrder:)
                                                 name:@"reload_recent_order"
                                               object:nil];
}

- (void)reloadRecentOrder:(NSNotification *)note{
    [self reloadRestaurants];
    [_tableView reloadData];
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"최근 주문"];
    self.navigationItem.titleView = customTitleView;
}

- (void)viewWillAppear:(BOOL)animated{
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCallLogCompleted:)
                                                 name:@"set_call_log"
                                               object:nil];
    
    [self reloadRestaurants];
    [_tableView reloadData];
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"최근주문 화면"];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"set_call_log" object:nil];
}
- (void)reloadRestaurants{
    // init _restaurants
    if(_restaurants != nil){
        [_restaurants removeAllObjects];
    }else{
        _restaurants = [[NSMutableArray alloc] init];
    }
    NSArray * categories = [[StaticHelper staticHelper] allData];
    for (CategoryModel * category in categories){
        for(Restaurant * restaurant in [category restaurants]){
            if([restaurant.numberOfCalls intValue] != 0){
                [_restaurants addObject:restaurant];
            }
        }
    }
    [self sortRestaurants];
    
    // init placeHolderLabel
    if([_restaurants count]==0){
        _placeHolderLabel.hidden = NO;
        _tableView.hidden = YES;
    }else{
        _placeHolderLabel.hidden = YES;
        _tableView.hidden = NO;
    }
}
- (void)sortRestaurants{
    // sort _restaurant
    NSArray * sortedArray;
    if(_sortBy == 1){
        sortedArray = [_restaurants sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = [(Restaurant*)a numberOfCalls];
            NSNumber *second = [(Restaurant*)b numberOfCalls];
            return [second compare:first];
        }];
    }else if(_sortBy == 2){
        sortedArray = [_restaurants sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(Restaurant*)a name];
            NSString *second = [(Restaurant*)b name];
            return [first compare:second];
        }];
    }
    else{
        sortedArray = [_restaurants sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = [(Restaurant*)a recentCallCounter];
            NSNumber *second = [(Restaurant*)b recentCallCounter];
            return [second compare:first];
        }];
    }
    _restaurants = [[NSMutableArray alloc] initWithArray:sortedArray];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_restaurants count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecentOrderTableViewCell * cell = (RecentOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentOrderCell"];
    
    if(cell == nil) {
        cell = (RecentOrderTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"RecentOrderTableViewCell" owner:nil options:nil][0];
    }
    
    Restaurant * restaurant = [_restaurants objectAtIndex:indexPath.row];
    [cell.numberOfCallsLabel setText:[restaurant.numberOfCalls stringValue]];
    [cell.restaurantLabel setText:restaurant.name];
    cell.phoneCallButton.tag = indexPath.row;
    [cell.phoneCallButton addTarget:self action:@selector(phoneCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneCallButton setUserInteractionEnabled:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
     _selectedRestaurant = [_restaurants objectAtIndex:indexPath.row];
     [self performSegueWithIdentifier:@"RestaurantViewController" sender:self];
     
     
     // GA
     [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"res_in_recent_clicked" label:[_selectedRestaurant.serverID stringValue]];
 }


# pragma mark -PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RestaurantViewController"]) {
        RestaurantViewController * rvc = (RestaurantViewController *)[segue destinationViewController];
        rvc.hidesBottomBarWhenPushed = YES;
        [rvc setDetailItem:_selectedRestaurant];
    }
}

#pragma mark - Button Clicked
- (void)sortByCallLogsButtonClicked:(UIButton *)sender{
    [_fixedTableViewHeader.sortByCallLogsImageView setHidden:NO];
    [_fixedTableViewHeader.sortByNameImageView setHidden:YES];
    [_fixedTableViewHeader.sortByRecentOrderImageView setHidden:YES];
    _sortBy = 1;
    
    [self sortRestaurants];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"sort_by_calls" label:@""];
}
- (void)sortByNameButtonClicked:(UIButton *)sender{
    [_fixedTableViewHeader.sortByCallLogsImageView setHidden:YES];
    [_fixedTableViewHeader.sortByNameImageView setHidden:NO];
    [_fixedTableViewHeader.sortByRecentOrderImageView setHidden:YES];
    _sortBy = 2;
    
    [self sortRestaurants];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"sort_by_name" label:@""];
}
- (void)sortByRecentOrderButtonClicked:(UIButton *)sender{
    [_fixedTableViewHeader.sortByCallLogsImageView setHidden:YES];
    [_fixedTableViewHeader.sortByNameImageView setHidden:YES];
    [_fixedTableViewHeader.sortByRecentOrderImageView setHidden:NO];
    _sortBy = 3;
    
    [self sortRestaurants];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"sort_by_recent_order" label:@""];
}
- (void)phoneCallButtonClicked:(UIButton *)sender{
    // disable Button for 2 sec
    sender.enabled = NO;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.enabled = YES;
    });
    
    
    Restaurant * restaurant = [_restaurants objectAtIndex:sender.tag];
    if([[StaticHelper staticHelper] hasRecentCall:restaurant.serverID]){
        restaurant.numberOfCalls = [NSNumber numberWithInt:[restaurant.numberOfCalls intValue]];
        restaurant.recentCallCounter = [[StaticHelper staticHelper] counter];
        [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];
        
        [[[ServerHelper alloc] init] set_call_log:[[[StaticHelper staticHelper] campus] serverID] categoryID:nil restaurantID:restaurant.serverID numberOfCalls:restaurant.numberOfCalls hasRecentCall:YES];
    }else{
        restaurant.numberOfCalls = [NSNumber numberWithInt:[restaurant.numberOfCalls intValue]+1];
        restaurant.recentCallCounter = [[StaticHelper staticHelper] counter];
        [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];
        // save Call
        [[StaticHelper staticHelper] saveCall:restaurant.serverID];
        
        [[[ServerHelper alloc] init] set_call_log:[[[StaticHelper staticHelper] campus] serverID] categoryID:nil restaurantID:restaurant.serverID numberOfCalls:restaurant.numberOfCalls hasRecentCall:NO];
    }
    
    _currentPhoneNumber = restaurant.phoneNumber;
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_currentPhoneNumber];
    NSURL * url = [NSURL URLWithString:phoneNumber];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
        
    }
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_clicked" label:[restaurant.serverID stringValue]];
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_in_recent_clicked" label:[restaurant.serverID stringValue]];
}
#pragma mark - Notification
- (void)setCallLogCompleted:(NSNotification *) note{

    [self sortRestaurants];
}
@end
