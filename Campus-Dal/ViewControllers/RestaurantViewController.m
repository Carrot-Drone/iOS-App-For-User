//
//  RestaurantViewController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "RestaurantViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

#import "FlyerViewController.h"
#import "RestaurantCorrectionViewController.h"
#import "CustomTitleView.h"

#import "RestaurantTableViewHeader.h"

#import "MenuTableViewCell.h"
#import "MenuTableViewSection.h"

#import "Restaurant.h"
#import "Menu.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import <AirBridge/AirBridge.h>

@interface RestaurantViewController (){
    Restaurant * _restaurant;
    NSInteger _myPre;
}
@end

@implementation RestaurantViewController
@synthesize tableView=_tableView;
@synthesize footerView=_footerView;
@synthesize campusNameForKakaoShare=_campusNameForKakaoShare;


- (void)setDetailItem:(Restaurant * )restaurant{
    _restaurant = restaurant;
}

- (void)viewDidLoad{
    // init navigation controller
    [self initNavigationController];
    
    // init tableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 70;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 35;
    
    // init header
    RestaurantTableViewHeader * tvh = (RestaurantTableViewHeader *)[[NSBundle mainBundle] loadNibNamed:@"RestaurantTableViewHeader" owner:nil options:nil][0];
    [tvh.shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tvh.evaluationButton addTarget:self action:@selector(evaluationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tvh.likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tvh.dislikeButton addTarget:self action:@selector(dislikeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = tvh;
    [tvh initWithRestaurant:_restaurant];
    [_tableView layoutIfNeeded];

    // init footer view
    [_footerView.phoneNumberLabel setText:_restaurant.phoneNumber];
    [_footerView.phoneCallButton addTarget:self action:@selector(phoneCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView.flyerButton addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(_restaurant.flyersURL == nil || [_restaurant.flyersURL count]==0){
        [_footerView removeFlyerButton];
    }
    
    // init Right Bar Button
    [self setRightBarButtonItem];
    
    // Server : get restaurant data
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper get_restaurant:_restaurant.serverID updatedAt:_restaurant.updatedAt];
    
}
- (void)setRightBarButtonItem{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Icon_action_bar_pen"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restaurantCorrectionButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // remove border in nav bar
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:_restaurant.name];
    self.navigationItem.titleView = customTitleView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    // Register notification when call log is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCallLogCompleted:)
                                                 name:@"set_call_log"
                                               object:nil];
    
    // Register notification when set user preference is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUserPreferenceCompleted:)
                                                 name:@"set_user_preference"
                                               object:nil];
    
    // Register notification when set user preference is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRestaurantCompleted:)
                                                 name:@"get_restaurant"
                                               object:nil];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"음식점 화면"];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Notification
- (void)setCallLogCompleted:(NSNotification *) note{
}
- (void)setUserPreferenceCompleted:(NSNotification *)note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] != 200){
        // 실패
        NSLog(@"Failed to set user preference");
        //UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"연결에 실패하였습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        //[alertView show];
        return;
    }
    RestaurantTableViewHeader * header =(RestaurantTableViewHeader *)_tableView.tableHeaderView;
    [header initWithRestaurant:_restaurant];
}
- (void)getRestaurantCompleted:(NSNotification *)note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] == 200){
        Restaurant * restaurant = [[Restaurant alloc] initWithDictionary:json];
        [_restaurant setRestaurant:restaurant];
        
        // update Header
        RestaurantTableViewHeader * header =  (RestaurantTableViewHeader *)_tableView.tableHeaderView;
        [header initWithRestaurant:_restaurant];
        _tableView.tableHeaderView = header;
        
        // update Footer
        [_footerView.phoneNumberLabel setText:_restaurant.phoneNumber];
        
        // init Nav Title
        CustomTitleView * customTitleView = (CustomTitleView *)self.navigationItem.titleView;
        [customTitleView.titleLabel setText:_restaurant.name];
        
        [_tableView reloadData];
        [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];
    }
}

# pragma mark - Button Clicked
- (void)phoneCallButtonClicked:(UIButton *)sender{
    NSLog(@"Phone Call :");
    [[AirBridge instance]goalWithDescription:[NSString stringWithFormat:@"%@", _restaurant.name] key:[NSString stringWithFormat:@"%d", _restaurant.serverID]];
    
    // disable Button for 2 sec
    sender.enabled = NO;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.enabled = YES;
    });
    
    
    Restaurant * restaurant = _restaurant;
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
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_restaurant.phoneNumber];
    NSURL * url = [NSURL URLWithString:phoneNumber];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_clicked" label:[restaurant.serverID stringValue]];
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_in_restaurant_clicked" label:[restaurant.serverID stringValue]];
}
- (void)flyerButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"FlyerViewController" sender:self];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"flyer_in_restaurant_clicked" label:[_restaurant.serverID stringValue]];
}
- (IBAction)restaurantCorrectionButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"RestaurantCorrectionViewController" sender:self];
}
-(void)shareButtonClicked:(id)sender{
    NSLog(@"Share Restaurant :");
    
    NSString * campusName;
    if(_campusNameForKakaoShare != nil){
        campusName = _campusNameForKakaoShare;
    }else{
        campusName = [[[StaticHelper staticHelper] campus] nameKorShort];
    }
    NSString * restaurant = [NSString stringWithFormat:@"%@ (%@)\n%@", _restaurant.name, campusName, _restaurant.phoneNumber];
    
    KakaoTalkLinkObject *label
    = [KakaoTalkLinkObject createLabel:restaurant];
    
    KakaoTalkLinkAction *androidAppAction
    = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid
                                devicetype:KakaoTalkLinkActionDeviceTypePhone
                                 execparam:@{@"restaurant_id" :_restaurant.serverID,
                                             @"campusName" :campusName}];

    KakaoTalkLinkAction *iphoneAppAction
    = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                devicetype:KakaoTalkLinkActionDeviceTypePhone
                                 execparam:@{@"restaurant_id" :_restaurant.serverID,
                                             @"campusName" :campusName}];
    
    // url 앱용 링크에 연결할 수 없는 플랫폼일 경우, 사용될 web url 지정
    // e.g. PC (Mac OS, Windows)
    KakaoTalkLinkAction *webLinkActionUsingPC
    = [KakaoTalkLinkAction createWebAction:HOME_PAGE];
    
    KakaoTalkLinkObject *button
    = [KakaoTalkLinkObject createAppButton:@"캠퍼스:달 바로가기"
                                   actions:@[androidAppAction, iphoneAppAction, webLinkActionUsingPC]];

    [KOAppCall openKakaoTalkAppLink:@[label, button]];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"share_kakao_clicked" label:[_restaurant.serverID stringValue]];
    
}
-(void)evaluationButtonClicked:(id)sender{
    NSLog(@"Evaluation :");
    RestaurantTableViewHeader * header =(RestaurantTableViewHeader *)_tableView.tableHeaderView;
    [header.like_dislikeImageView removeFromSuperview];
    [header.like_dislikeLabel removeFromSuperview];
    [header.likeButtonImageView setHidden:NO];
    [[header.likeButtonImageView superview] setBackgroundColor:MAIN_COLOR];
    [header.dislikeButtonImageView setHidden:NO];
    [header.evaluationButton setHidden:YES];
    [header.border3 setHidden:YES];
}
- (void)likeButtonClicked:(id)sender{
    if([_restaurant.myPreference intValue] == 1){
        [self resetRestaurantPreference];
    }else{
        [self likeRestaurant];
    }
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"like_button_clicked" label:[_restaurant.serverID stringValue]];
}
- (void)likeRestaurant{
    if([_restaurant.myPreference intValue] == -1){
        _restaurant.totalNumberOfBads = [NSNumber numberWithInt:[_restaurant.totalNumberOfBads intValue]-1];
    }
    _restaurant.myPreference = [NSNumber numberWithInt:1];
    _restaurant.totalNumberOfGoods = [NSNumber numberWithInt:[_restaurant.totalNumberOfGoods intValue]+1];

    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_user_preference:_restaurant.serverID preference:[NSNumber numberWithInt:1]];
    
    // update view
    RestaurantTableViewHeader * header =(RestaurantTableViewHeader *)_tableView.tableHeaderView;
    [header initWithRestaurant:_restaurant];
}
- (void)dislikeButtonClicked:(id)sender{
    if([_restaurant.myPreference intValue] == -1){
        [self resetRestaurantPreference];
    }else{
        [self dislikeRestaurant];
    }
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"dislike_button_clicked" label:[_restaurant.serverID stringValue]];
}
- (void)dislikeRestaurant{
    if([_restaurant.myPreference intValue] == 1){
        _restaurant.totalNumberOfGoods = [NSNumber numberWithInt:[_restaurant.totalNumberOfGoods intValue]-1];
    }
    _restaurant.myPreference = [NSNumber numberWithInt:-1];
    _restaurant.totalNumberOfBads = [NSNumber numberWithInt:[_restaurant.totalNumberOfBads intValue]+1];
    
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_user_preference:_restaurant.serverID preference:[NSNumber numberWithInt:-1]];
    
    // update view
    RestaurantTableViewHeader * header =(RestaurantTableViewHeader *)_tableView.tableHeaderView;
    [header initWithRestaurant:_restaurant];
}
- (void)resetRestaurantPreference{
    if([_restaurant.myPreference intValue] == 1){
        _restaurant.myPreference = [NSNumber numberWithInt:0];
        _restaurant.totalNumberOfGoods = [NSNumber numberWithInt:[_restaurant.totalNumberOfGoods intValue]-1];
    }else if([_restaurant.myPreference intValue] == -1){
        _restaurant.myPreference = [NSNumber numberWithInt:0];
        _restaurant.totalNumberOfBads = [NSNumber numberWithInt:[_restaurant.totalNumberOfBads intValue]-1];
    }
    
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_user_preference:_restaurant.serverID preference:[NSNumber numberWithInt:0]];
    
    // update view
    RestaurantTableViewHeader * header =(RestaurantTableViewHeader *)_tableView.tableHeaderView;
    [header initWithRestaurant:_restaurant];
}

# pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"FlyerViewController"]){
        [(FlyerViewController *)[[segue destinationViewController] topViewController] setDetailItem:_restaurant];
    }else if([segue.identifier isEqualToString:@"RestaurantCorrectionViewController"]){
        [(RestaurantCorrectionViewController *)[[segue destinationViewController] topViewController] setDetailItem:_restaurant];
    }
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_restaurant.menus count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_restaurant.menus == nil || [_restaurant.menus count]==0){
        return 0;
    }else{
        return [[_restaurant.menus objectAtIndex:section] count];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_restaurant.menus == nil || [_restaurant.menus count] == 0){
        return nil;
    }
    Menu * menu = [[_restaurant.menus objectAtIndex:section] objectAtIndex:0];

    MenuTableViewSection * sectionView = (MenuTableViewSection *)[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewSection" owner:nil options:nil][0];
    sectionView.sectionTitle.text = menu.section;
    
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell * cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if(cell == nil) {
        cell = (MenuTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:nil options:nil][0];
    }
    Menu * menu = [[_restaurant.menus objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.menuNameLabel.text = menu.name;
    
    // set line space
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[menu priceString]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentRight];
    [style setLineSpacing:5];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    cell.menuPriceLabel.attributedText = attrString;
    
    cell.menuDetailLabel.text = menu.menu_description;
    
    if(menu.menu_description == nil || [menu.menu_description isEqualToString:@""]){
        cell.detailLabelHeight.constant = 0;
        cell.detailLabelHeight.priority = 1000;
        cell.detailLabelTop.constant = 0;
    }else{
        cell.detailLabelHeight.constant = 0;
        cell.detailLabelHeight.priority = 1;
        cell.detailLabelTop.constant = 8;
    }
    
    return cell;
}

@end
