//
//  RestaurantsViewController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "RestaurantsViewController.h"

#import "RestaurantViewController.h"
#import "FlyerViewController.h"

#import "CustomTitleView.h"
#import "RestaurantsTableViewCell.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "CategoryModel.h"
#import "Restaurant.h"

#import "NSDictionary+SAFEACCESSCategories.h"

@interface RestaurantsViewController(){
    CategoryModel * _category;
    NSMutableArray * _restaurants;
    Restaurant * _selectedRestaurant;
}

@end

@implementation RestaurantsViewController

@synthesize tableView=_tableView;
@synthesize headerView=_headerView;
@synthesize placeholderView=_placeholderView;

- (void)setDetailItem:(CategoryModel * )category{
    _category = category;
}

- (void)viewDidLoad{
    // init tableview
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // init navigation controller
    [self initNavigationController];
    
    // init header
    [_headerView.flyerButton addTarget:self action:@selector(filterByFlyer:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.officeHoursButton addTarget:self action:@selector(filterByofficeHours:) forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadRestaurants];
    
    
    // Server : get restaurants list
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper get_restaurants_list_in_category:[[[StaticHelper staticHelper] campus] serverID] categoryID:[_category serverID]];
}

- (void)initNavigationController{
    // Back
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:[_category title]];
    self.navigationItem.titleView = customTitleView;
}

- (void)reloadRestaurants{
    _restaurants = [[NSMutableArray alloc] initWithArray:[_category restaurants]];
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    for(Restaurant * res in _restaurants){
        if(_headerView.flyerButtonSelected == YES && [res.hasFlyer boolValue] == NO){
            [discardedItems addObject:res];
        }
        if(_headerView.officeHoursButtonSelected == YES && [res isOpened] == NO){
            [discardedItems addObject:res];
        }
    }
    [_restaurants removeObjectsInArray:discardedItems];
    
    NSArray * sortedArray = [_restaurants sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Restaurant*)a name];
        NSString *second = [(Restaurant*)b name];
        return [first compare:second];
    }];
    _restaurants = [[NSMutableArray alloc] initWithArray:sortedArray];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // init placeholderview
    if([[_category restaurants] count] == 0){
        [_placeholderView setHidden:NO];
        [_tableView setHidden:YES];
    }else{
        [_placeholderView setHidden:YES];
        [_tableView setHidden:NO];
    }
    [_tableView reloadData];

    // Register notification when call log is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRestaurantsListInCategory:)
                                                 name:@"get_restaurants_list_in_category"
                                               object:nil];
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"음식점 리스트 화면"];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Notification
- (void)getRestaurantsListInCategory:(NSNotification *) note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] == 200){
        NSDictionary * restaurants = [json objectForKey:@"restaurants"];
        // Add New Restaurant
        for(NSDictionary * restaurantDic in restaurants){
            BOOL isNew = true;
            for(Restaurant * res in [_category restaurants]){
                if([res.serverID isEqualToNumber:[restaurantDic numberForKey:@"id"]]){
                    isNew = false;
                    break;
                }
            }
            if(isNew){
                Restaurant * newRes = [[Restaurant alloc] initWithDictionary:restaurantDic];
                [[_category restaurants] addObject:newRes];
            }
        }
        
        // Remove deleted Restaurant
        NSMutableArray * resShouldRemoved = [[NSMutableArray alloc] init];
        for(Restaurant * res in [_category restaurants]){
            BOOL isRemoved = true;
            for(NSDictionary * restaurantDic in restaurants){
                if([res.serverID isEqualToNumber:[restaurantDic numberForKey:@"id"]]){
                    // update Res info based on new Res
                    // Only for meta data. If you push in to the real Restaurant view, it will then update it's content
                    res.name = [restaurantDic stringForKey:@"name"];
                    res.phoneNumber = [restaurantDic stringForKey:@"phone_number"];
                    res.hasCoupon = [restaurantDic numberForKey:@"has_coupon"];
                    res.hasFlyer = [restaurantDic numberForKey:@"has_flyer"];
                    res.isNew = [restaurantDic numberForKey:@"is_new"];
                    res.retention = [restaurantDic numberForKey:@"retention"];
                    res.openingHours = [restaurantDic numberForKey:@"opening_hours"];
                    res.closingHours = [restaurantDic numberForKey:@"closing_hours"];
                    res.flyersURL = [restaurantDic objectForKey:@"flyers_url"];

                    isRemoved = false;
                    break;
                }
            }
            if(isRemoved){
                [resShouldRemoved addObject:res];
            }
        }
        [[_category restaurants] removeObjectsInArray:resShouldRemoved];
        
        // Save data
        [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];
        
        [self reloadRestaurants];
    }
}
# pragma mark -PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RestaurantViewController"]) {
        RestaurantViewController * rvc = (RestaurantViewController *)[segue destinationViewController];
        rvc.hidesBottomBarWhenPushed = YES;
        [rvc setDetailItem:_selectedRestaurant];
    }else if([segue.identifier isEqualToString:@"FlyerViewController"]){
        UIButton * flyerButton = (UIButton * )sender;
        [(FlyerViewController *)[[segue destinationViewController] topViewController] setDetailItem:[_restaurants objectAtIndex:flyerButton.tag]];
    }
}

# pragma mark - ButtonClicked
- (void)flyerButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"FlyerViewController" sender:sender];
    
    
    // GA
    UIButton * flyerButton = (UIButton *)sender;
    Restaurant * restaurant = (Restaurant *)[_restaurants objectAtIndex:flyerButton.tag];
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"flyer_in_restaurants_clicked" label:[restaurant.serverID stringValue]];
}
- (void)filterByFlyer:(id)sender{
    [_headerView flyerButtonClicked:self];
    [self reloadRestaurants];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"filter_by_flyer" label:@""];
}
- (void)filterByofficeHours:(id)sender{
    [_headerView officeHoursButtonClicked:self];
    [self reloadRestaurants];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"filter_by_office_hours" label:@""];
}
- (void)restaurantSelected:(Restaurant *)selectedRestaurant{
    _selectedRestaurant = selectedRestaurant;
    [self performSegueWithIdentifier:@"RestaurantViewController" sender:self];
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_restaurants count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RestaurantsTableViewCell * cell = (RestaurantsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RestaurantsTableViewCell" owner:nil options:nil][0];
    }
    
    Restaurant * restaurant = [_restaurants objectAtIndex:indexPath.row];
    
    cell.retentionLabel.text = [restaurant retentionString];
    cell.nameLabel.text = [restaurant name];
    cell.flyerButton.hidden = ![[restaurant hasFlyer] boolValue];
    cell.flyerImageView.hidden = ![[restaurant hasFlyer] boolValue];
    cell.flyerButton.tag = indexPath.row;
    [cell.flyerButton addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Restaurant * selectedRestaurant = [_restaurants objectAtIndex:indexPath.row];
    [self restaurantSelected:selectedRestaurant];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"res_in_restaurants_clicked" label:[_selectedRestaurant.serverID stringValue]];
}

@end
