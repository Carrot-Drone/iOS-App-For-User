//
//  SelectCampusViewController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "SelectCampusViewController.h"
#import "MainTabBarController.h"
#import "RestaurantSuggestionDetailViewController.h"
#import "RecentOrderViewController.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "Campus.h"
#import "CategoryModel.h"
#import "Restaurant.h"

#import "AppDelegate.h"

#import "CustomTitleView.h"

#import "CustomCampusCell.h"
#import "CustomCurrentCampusCell.h"
#import "CustomTableViewSection.h"


@interface SelectCampusViewController (){
    NSArray * _campuses;
    NSString * _navigationBarTitle;
    
    Campus * _selectedCampus;
    
    BOOL _isFromAboutVC;
    BOOL _isFromRSV;
}
    
@end

@implementation SelectCampusViewController
@synthesize tableView=_tableView;
@synthesize headerHeightConstraint=_headerHeightConstraint;

@synthesize headerTableView=_headerTableView;
@synthesize startButtonView=_startButtonView;

@synthesize activityIndicator=_activityIndicator;

- (void)setDetailItem:(BOOL)isFromRSV{
    _isFromRSV = isFromRSV;
}

- (void)viewDidLoad{
    // init activity Indicator
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
    
    // Set TableView Delegate
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    _headerTableView.delegate = self;
    _headerTableView.dataSource = self;
    _headerTableView.separatorColor = [UIColor clearColor];
    
    // init Campuses
    _campuses = [[StaticHelper staticHelper] campuses];
    _selectedCampus = [[StaticHelper staticHelper] campus];
    
    // init HeaderView
    if(_isFromRSV){
        _headerHeightConstraint.constant = 0;
        _isFromAboutVC = NO;
        _navigationBarTitle = @"음식점추가 / 입점문의";
        [_startButtonView removeFromSuperview];
    }else if([[StaticHelper staticHelper] campus] != nil){
        _isFromAboutVC = YES;
        _navigationBarTitle = @"캠퍼스 바꾸기";
        [_startButtonView.button setTitle:@"캠퍼스 바꾸기" forState:UIControlStateNormal];
    }else{
        //[_headerTableView removeFromSuperview];
        _headerHeightConstraint.constant = 0;
        _isFromAboutVC = NO;
        _navigationBarTitle = @"캠퍼스 고르기";
        [_startButtonView.button setTitle:@"시작하기" forState:UIControlStateNormal];
    }
    
    // init Bar Button Button
    if(_isFromRSV){
        self.navigationItem.leftBarButtonItem.title = @"취소";
        self.navigationItem.leftBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.action = @selector(cancelButtonClicked:);
        
        self.navigationItem.rightBarButtonItem.title = @"완료";
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.rightBarButtonItem.action = @selector(confirmButtonClicked:);
    }else if(_isFromAboutVC){
        self.navigationItem.leftBarButtonItem = nil;
        
        [self setRightBarButtonItem];
    }else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // init Navigation Controller
    [self initNavigationController];
    
    // init Start Button
    [_startButtonView.button addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:_navigationBarTitle];
    self.navigationItem.titleView = customTitleView;
}
- (void)setRightBarButtonItem{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Icon_action_bar_cancel"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRestaurantsCompleted:)
                                                 name:@"get_restaurants"
                                               object:nil];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"캠퍼스 선택하기 화면"];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)campusSelected:(Campus *)campus{
    // Campus Selected
    [[[ServerHelper alloc] init] set_device:[campus serverID] deviceType:DEVICE_TYPE];
    [[StaticHelper staticHelper] saveCampus:campus];
    
    // Start Animating
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    [self.view setUserInteractionEnabled:NO];
    
    // Get restaurants Data
    // Check User Defaults first
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * data = [userDefault objectForKey:[NSString stringWithFormat:@"allData_%d", [[campus serverID] intValue]]];
    
    if(data == nil){
        [[[ServerHelper alloc] init] get_restaurants:[campus serverID]];
    }else{
        
        // Duplicated Code!!
        NSMutableArray * categories = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [[StaticHelper staticHelper] saveAllData:categories];
        [[StaticHelper staticHelper] resetCachedRecommendedRestaurants];
        
        // Send Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"campus_changed" object:self];
        
        if(_isFromAboutVC){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MainTabBarController * mtc = (MainTabBarController *)appDelegate.window.rootViewController;
            UINavigationController * vc1 = [mtc.viewControllers objectAtIndex:0];
            UINavigationController * vc2 = [mtc.viewControllers objectAtIndex:1];
            [vc1 popToRootViewControllerAnimated:NO];
            [vc2 popToRootViewControllerAnimated:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_recent_order" object:nil];
            
            [mtc setSelectedIndex:0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = appDelegate.mainTabBarController;
        }
    }
    
    
    // GA
    if(_isFromAboutVC){
        // is From About Vc
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"select_campus_in_about_start" label:[campus.serverID stringValue]];
    }else {
        // is the first time
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"select_campus_start" label:[campus.serverID stringValue]];
    }
}
- (void)start{
    
}
# pragma mark - Notifications
- (void)getRestaurantsCompleted:(NSNotification *)note{
    // Stop Animating
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
    
    
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] != 200){
        // 실패
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"데이터를 가져오는데 실패했습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // 성공
        NSArray * categories_data = [json objectForKey:@"restaurants"];
        
        NSMutableArray * categories = [[NSMutableArray alloc] init];
        for(NSDictionary * category_dic in categories_data){
            CategoryModel * category = [[CategoryModel alloc] initWithDictionary:category_dic];
            [categories addObject:category];
        }
        
        // Duplicated Code!!
        [[StaticHelper staticHelper] saveAllData:categories];
        [[StaticHelper staticHelper] resetCachedRecommendedRestaurants];
        
        // Send Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"campus_changed" object:self];
        
        if(_isFromAboutVC){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MainTabBarController * mtc = (MainTabBarController *)appDelegate.window.rootViewController;
            UINavigationController * vc1 = [mtc.viewControllers objectAtIndex:0];
            UINavigationController * vc2 = [mtc.viewControllers objectAtIndex:1];
            [vc1 popToRootViewControllerAnimated:NO];
            [vc2 popToRootViewControllerAnimated:NO];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_recent_order" object:nil];
            
            [mtc setSelectedIndex:0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = appDelegate.mainTabBarController;
        }
    }
}

# pragma mark - Button Clicked
- (void)startButtonClicked:(id)sender{
    if(_selectedCampus != nil){
        [self campusSelected:_selectedCampus];
    }
}
- (void)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)confirmButtonClicked:(id)sender{
    RestaurantSuggestionDetailViewController * vc = (RestaurantSuggestionDetailViewController *)[(UINavigationController *)[self presentingViewController] topViewController];
    vc.campus = _selectedCampus;
    [vc.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"select_campus_in_restaurant_suggestion_start" label:[_selectedCampus.serverID stringValue]];
}
# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:_headerTableView]){
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:_headerTableView]){
        return 1;
    }else{
        return [_campuses count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:_headerTableView]){
        CustomTableViewSection * sectionView = (CustomTableViewSection *)[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewSection" owner:nil options:nil][0];
        
        [sectionView.titleLabel setText:@"현재 캠퍼스"];
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_campus"]];
        return sectionView;
    }else{
        CustomTableViewSection * sectionView = (CustomTableViewSection *)[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewSection" owner:nil options:nil][0];
        
        if(_isFromRSV){
            [sectionView.titleLabel setText:@"캠퍼스"];
            [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_campus"]];
        }else if(_isFromAboutVC){
            [sectionView.titleLabel setText:@"새로운 캠퍼스"];
            [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_campus"]];
        }else{
            [sectionView.titleLabel setText:@"새로운 캠퍼스"];
            [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_change"]];
        }
        
        // Set Cutom Table Separator
        CGFloat separatorInset; // Separator x position
        CGFloat separatorHeight;
        CGFloat separatorWidth;
        CGFloat separatorY;
        UIImageView *separator_bottom;
        UIColor *separatorBGColor;
        
        separatorY      = sectionView.frame.size.height;
        separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
        separatorWidth  = 10000;
        separatorInset  = 0.0f;
        separatorBGColor  = [UIColor colorWithRed: 204.0/255.0 green: 204.0/255.0 blue: 204.0/255.0 alpha:1.0];
        
        
        separator_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, separatorY, separatorWidth,separatorHeight)];
        separator_bottom.backgroundColor = separatorBGColor;
        [sectionView addSubview: separator_bottom];
        
        return sectionView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_headerTableView]){
        CustomCurrentCampusCell * cell = (CustomCurrentCampusCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomCurrentCampusCell" owner:nil options:nil][0];
        
        // 현재 캠퍼스
        cell.backgroundColor = tableView.backgroundColor;
        cell.currentCampus.text = [[[StaticHelper staticHelper] campus] nameKor];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    CustomCampusCell * cell = (CustomCampusCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCampusCell"];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CustomCampusCell" owner:nil options:nil][0];
    }
    
    Campus * campus = [_campuses objectAtIndex:indexPath.row];
    
    cell.campusLabel.text = [campus nameKor];
    if([campus isEqual:_selectedCampus]){
        cell.checkImageView.hidden = NO;
    }else{
        cell.checkImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_headerTableView]){
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _selectedCampus = [_campuses objectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

@end
