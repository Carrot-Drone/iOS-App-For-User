//
//  RecommendationViewController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "RecommendationViewController.h"

#import "RestaurantsViewController.h"
#import "RestaurantViewController.h"
#import "FlyerViewController.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "CategoryModel.h"
#import "Restaurant.h"

#import "RecommendationTitleView.h"
#import "RecommendRestaurantView.h"

#import "NSMutableArray+SHUFFLECategories.h"

#define VIEW_TAG_0  1
#define VIEW_TAG_1  2
#define VIEW_TAG_2  3

@implementation RecommendationViewController{
    RecommendationTitleView * _titleView;
    
    NSMutableArray * _newRestaurants;
    NSMutableArray * _trendRestaurants;
    
    NSMutableArray * _newRestaurantViews;
    NSMutableArray * _trendRestaurantViews;
    
    Restaurant * _selectedRestaurant;
    CategoryModel * _selectedCategory;
    
    CGRect _mainScrollFrame;
    
    UIScrollView * _subScrollView1;
    UIScrollView * _subScrollView2;
}
@synthesize mainScrollView=_mainScrollView;

- (void)viewDidLoad{
    // init Navigation Controller
    [self initNavigationController];
    
    // Remove 1px border
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    
    // Register notification when set call log is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadViews)
                                                 name:@"campus_changed"
                                               object:nil];
    
    // init ScrollView
    _mainScrollFrame = CGRectMake(0, 0, 0, 0);
    [self reloadViews];

}
- (void)viewWillAppear:(BOOL)animated{
    
    // Register notification when set call log is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCallLogCompleted:)
                                                 name:@"set_call_log"
                                               object:nil];
    
    // reloadRestaurants
    [self reloadScrollView];
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"추천 화면"];
    
}
- (void)reloadViews{
    // init recommended restaurants
    [self initRecommendedRestaurants];
    // init ScrollView
    [self initScrollView];
}

- (void)reloadScrollView{
    for(UIView * view in _newRestaurantViews){
        RecommendRestaurantView * header = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [header initWithRestaurant:header.restaurant reason:header.reason];
    }
    for(UIView * view in _trendRestaurantViews){
        RecommendRestaurantView * header = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [header initWithRestaurant:header.restaurant reason:header.reason];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"set_call_log" object:self];
}
- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    RecommendationTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"RecommendationTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"우리학교 트렌드"];
    
    _titleView = customTitleView;
    self.navigationItem.titleView = customTitleView;
}

- (void)initRecommendedRestaurants{
    _newRestaurants = [[NSMutableArray alloc] init];
    _trendRestaurants = [[NSMutableArray alloc] init];
    _newRestaurantViews = [[NSMutableArray alloc] init];
    _trendRestaurantViews = [[NSMutableArray alloc] init];
    
    NSDictionary * dictionary = [[StaticHelper staticHelper] recommendedRestaurants];
    
    for(NSDictionary * dic in [dictionary objectForKey:@"new"]){
        NSNumber * res_id = [dic objectForKey:@"id"];
        NSString * reason = [dic objectForKey:@"reason"];
        Restaurant * res =[[StaticHelper staticHelper] restaurant:res_id];
        if(res != nil){
            NSArray * array = [[NSArray alloc] initWithObjects:res, reason, nil];
            [_newRestaurants addObject:array];
        }
    }
    for(NSDictionary * dic in [dictionary objectForKey:@"trend"]){
        NSNumber * res_id = [dic objectForKey:@"id"];
        NSString * reason = [dic objectForKey:@"reason"];
        Restaurant * res =[[StaticHelper staticHelper] restaurant:res_id];
        if(res != nil){
            NSArray * array = [[NSArray alloc] initWithObjects:res, reason, nil];
            [_trendRestaurants addObject:array];
        }
    }
    
    [_newRestaurants shuffle];
    [_trendRestaurants shuffle];
}

- (void)initScrollView{
    [_mainScrollView layoutIfNeeded];

    for (UIView * view in [_mainScrollView subviews]){
        [view removeFromSuperview];
    }
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    if(_mainScrollFrame.size.width == 0){
        _mainScrollFrame = _mainScrollView.frame;
    }
    CGRect frame = _mainScrollFrame;
    CGSize realScrollViewSize = CGSizeMake(frame.size.width, frame.size.height - 49 - 64);
    _mainScrollView.contentSize = CGSizeMake(frame.size.width*2, (frame.size.height - 49-64));
    for(int i=0; i<2; i++){
        UIScrollView * subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(realScrollViewSize.width*i, 0, realScrollViewSize.width, realScrollViewSize.height)];
        
        if(i==0)  _subScrollView1 = subScrollView;
        else      _subScrollView2 = subScrollView;
        
        subScrollView.delegate = self;
        subScrollView.tag = i;
        subScrollView.pagingEnabled = YES;
        subScrollView.bounces = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        [subScrollView setContentSize:CGSizeMake(realScrollViewSize.width, realScrollViewSize.height*5)];
        
        for(int j=0; j<5; j++){
            UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, realScrollViewSize.height*j, realScrollViewSize.width, realScrollViewSize.height)];
            [contentView setBackgroundColor:[UIColor redColor]];
            UIView * view = [[NSBundle mainBundle] loadNibNamed:@"RecommendRestaurantView" owner:nil options:nil][0];
            if(i==0){
                [_trendRestaurantViews addObject:view];
            }else{
                [_newRestaurantViews addObject:view];
            }
            [self initRecommenRestaurantView:view i:i j:j];

            [view setTranslatesAutoresizingMaskIntoConstraints:NO];
            [contentView addSubview:view];
            [subScrollView addSubview:contentView];
            [self addConstraint:view in:contentView];
        }
        
        CGRect frame = subScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = frame.size.height * 1;
        [subScrollView scrollRectToVisible:frame animated:NO];

        [_mainScrollView addSubview:subScrollView];
    }
}
- (void)initRecommenRestaurantView:(UIView *)view i:(int)i j:(int)j{
    int index;
    if(j==0 || j==3){
        view.tag = VIEW_TAG_0;
        index = 0;
    }else if(j==1 || j==4){
        view.tag = VIEW_TAG_1;
        index = 1;
    }else{
        view.tag = VIEW_TAG_2;
        index = 2;
    }
    
    RecommendRestaurantView * rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
    NSArray * restaurants;
    if(i==0){
        [rv.resNewImageView setHidden:NO];
        restaurants = _trendRestaurants;
        rv.nextButton1.tag = 0;
        rv.nextButton2.tag = 0;
    }else{
        [rv.resNewImageView setHidden:YES];
        restaurants = _newRestaurants;
        rv.nextButton1.tag = 1;
        rv.nextButton2.tag = 1;
    }
    NSArray * array = [restaurants objectAtIndex:index];
    NSString * reason = [array objectAtIndex:1];
    Restaurant * res = [array objectAtIndex:0];
    reason = [NSString stringWithFormat:@"<%@>", reason];
    [rv initWithRestaurant:res reason:reason];
    [rv.categoryButton addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rv.restaurantButton addTarget:self action:@selector(restaurantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rv.flyerButton addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rv.buttonViewButton addTarget:self action:@selector(phoneCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rv.nextButton1 addTarget:self action:@selector(scrollUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rv.nextButton2 addTarget:self action:@selector(scrollDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Decelerating");
    if([scrollView isEqual:_mainScrollView]){
        CGFloat pageWidth = _mainScrollView.frame.size.width;
        int currentPage = floor((_mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(currentPage == 0){
            [_titleView.leftImageView setImage:[UIImage imageNamed:@"Icon_card_tab_selected"]];
            [_titleView.rightImageView setImage:[UIImage imageNamed:@"Icon_card_tab_normal"]];
            _titleView.titleLabel.text = @"우리학교 트렌드";
        }else{
            [_titleView.leftImageView setImage:[UIImage imageNamed:@"Icon_card_tab_normal"]];
            [_titleView.rightImageView setImage:[UIImage imageNamed:@"Icon_card_tab_selected"]];
            _titleView.titleLabel.text = @"캠달에 처음이에요";
        }
    }else{
        [self loadNextViews:scrollView];
    }
}
- (void)setNextAndPrevView:(int)indexOfPage isNew:(BOOL)isNew{
    NSArray * restaurantViews;
    NSArray * restaurants;
    if(isNew){
        restaurantViews = _newRestaurantViews;
        restaurants = _newRestaurants;
    }else{
        restaurantViews = _trendRestaurantViews;
        restaurants = _trendRestaurants;
    }
    
    Restaurant * currentRestaurant = [[[[restaurantViews objectAtIndex:indexOfPage] subviews] objectAtIndex:0] restaurant];
    NSArray * nextResArray = [self nextRes:restaurants restaurant:currentRestaurant];
    NSArray * prevResArray = [self prevRes:restaurants restaurant:currentRestaurant];
    
    Restaurant * nextRes = [nextResArray objectAtIndex:0];
    Restaurant * prevRes = [prevResArray objectAtIndex:0];
    
    NSString * nextReason = [nextResArray objectAtIndex:1];
    nextReason = [NSString stringWithFormat:@"<%@>", nextReason];

    NSString * prevReason = [prevResArray objectAtIndex:1];
    prevReason = [NSString stringWithFormat:@"<%@>", prevReason];
    
    if(indexOfPage == 1){
        UIView * view;
        RecommendRestaurantView * rv;
        // Next
        view = [restaurantViews objectAtIndex:2];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:nextRes reason:nextReason];
        // Prev
        view = [restaurantViews objectAtIndex:0];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:prevRes reason:prevReason];
        view = [restaurantViews objectAtIndex:3];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:prevRes reason:prevReason];
    }else if(indexOfPage == 2){
        UIView * view;
        RecommendRestaurantView * rv;
        // Next
        view = [restaurantViews objectAtIndex:0];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:nextRes reason:nextReason];
        view = [restaurantViews objectAtIndex:3];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:nextRes reason:nextReason];
        // Prev
        view = [restaurantViews objectAtIndex:1];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:prevRes reason:prevReason];
        view = [restaurantViews objectAtIndex:4];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:prevRes reason:prevReason];
    }else if(indexOfPage == 3){
        UIView * view;
        RecommendRestaurantView * rv;
        // Next
        view = [restaurantViews objectAtIndex:1];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:nextRes reason:nextReason];
        view = [restaurantViews objectAtIndex:4];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:nextRes reason:nextReason];
        // Prev
        view = [restaurantViews objectAtIndex:2];
        rv = (RecommendRestaurantView *)[[view subviews] objectAtIndex:0];
        [rv initWithRestaurant:prevRes reason:prevReason];
    }else{
        NSLog(@"Error! %d", indexOfPage);
    }
}
- (NSArray *)nextRes:(NSArray *)restaurants restaurant:(Restaurant *)restaurant{
    NSUInteger index = -1;
    for(int i=0; i<[restaurants count]; i++){
        NSArray * array = [restaurants objectAtIndex:i];
        Restaurant * res = [array objectAtIndex:0];
        if([res isEqual:restaurant]){
            index = i;
            break;
        }
    }
    if(index==-1) {
        NSLog(@"Error!");
        return nil;
    }
    if(index == [restaurants count]-1){
        index = 0;
    }else{
        index += 1;
    }
    return [restaurants objectAtIndex:index];
}
- (NSArray *)prevRes:(NSArray *)restaurants restaurant:(Restaurant *)restaurant{
    NSUInteger index = -1;
    for(int i=0; i<[restaurants count]; i++){
        NSArray * array = [restaurants objectAtIndex:i];
        Restaurant * res = [array objectAtIndex:0];
        if([res isEqual:restaurant]){
            index = i;
            break;
        }
    }
    if(index==-1) return nil;
    if(index == 0){
        index = [restaurants count]-1;
    }else{
        index -= 1;
    }
    return [restaurants objectAtIndex:index];
}

# pragma mark - Button Clicked

- (void)scrollUpButtonClicked:(UIButton *)sender{
    UIScrollView * scrollView;
    
    if(sender.tag == 0){
        scrollView = _subScrollView1;
    }else{
        scrollView = _subScrollView2;
    }
    int indexOfPage = scrollView.contentOffset.y / scrollView.frame.size.height;
    NSLog(@"!%d", indexOfPage);
    
    CGRect frame = scrollView.frame;
    CGPoint point = scrollView.contentOffset;
    frame.origin.x = 0;
    frame.origin.y = point.y - frame.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView scrollRectToVisible:frame animated:NO];
    } completion:^(BOOL finished) {
        [self loadNextViews:scrollView];
    }];
}
-(void)scrollDownButtonClicked:(UIButton *)sender{
    UIScrollView * scrollView;
    if(sender.tag == 0){
        scrollView = _subScrollView1;
    }else{
        scrollView = _subScrollView2;
    }
    CGRect frame = scrollView.frame;
    CGPoint point = scrollView.contentOffset;
    frame.origin.x = 0;
    frame.origin.y = point.y + frame.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView scrollRectToVisible:frame animated:NO];
    } completion:^(BOOL finished) {
        [self loadNextViews:scrollView];
    }];
    
}
- (void)loadNextViews:(UIScrollView *)scrollView{
    UIScrollView * subScrollView = scrollView;
    int indexOfPage = subScrollView.contentOffset.y / subScrollView.frame.size.height;
    NSLog(@"from : %d", indexOfPage);
    
    if(indexOfPage == 0){
        CGRect frame = subScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = frame.size.height * 3;
        [subScrollView scrollRectToVisible:frame animated:NO];
    }else if(indexOfPage == 4){
        CGRect frame = subScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = frame.size.height * 1;
        [subScrollView scrollRectToVisible:frame animated:NO];
    }
    
    indexOfPage = subScrollView.contentOffset.y / subScrollView.frame.size.height;
    NSLog(@"to :%d", indexOfPage);
    [self setNextAndPrevView:indexOfPage isNew:subScrollView.tag];
}
- (void)categoryButtonClicked:(UIButton *)sender{
    RecommendRestaurantView * view = (RecommendRestaurantView *)[[[sender superview] superview] superview];
    _selectedCategory = view.category;
    
    [self performSegueWithIdentifier:@"RestaurantsViewController" sender:self];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"category_in_recommend_clicked" label:[_selectedCategory.serverID stringValue]];
}
- (void)restaurantButtonClicked:(UIButton *)sender{
    RecommendRestaurantView * view = (RecommendRestaurantView *)[[[sender superview] superview] superview];
    Restaurant * restaurant = view.restaurant;
    _selectedRestaurant = restaurant;
    [self performSegueWithIdentifier:@"RestaurantViewController" sender:self];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"res_in_recommend_clicked" label:[_selectedRestaurant.serverID stringValue]];
    
}
- (void)flyerButtonClicked:(UIButton *)sender{
    RecommendRestaurantView * view = (RecommendRestaurantView *)[[[sender superview] superview] superview];
    Restaurant * restaurant = view.restaurant;
    _selectedRestaurant = restaurant;
    if(restaurant.flyersURL == nil || [restaurant.flyersURL count]==0){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"해당 음식점은 전단지가 없습니다" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self performSegueWithIdentifier:@"FlyerViewController" sender:self];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"flyer_in_recommend_clicked" label:[restaurant.serverID stringValue]];
}
- (void)phoneCallButtonClicked:(UIButton *)sender{
    // disable Button for 2 sec
    sender.enabled = NO;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        sender.enabled = YES;
    });
    
    RecommendRestaurantView * view = (RecommendRestaurantView *)[[[sender superview] superview] superview];
    Restaurant * restaurant = view.restaurant;
    
    _selectedRestaurant = restaurant;
    
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
    NSLog(@"Phone call:");
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_selectedRestaurant.phoneNumber];
    NSURL * url = [NSURL URLWithString:phoneNumber];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_clicked" label:[restaurant.serverID stringValue]];
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_in_recommend_clicked" label:[restaurant.serverID stringValue]];
}

#pragma mark - Notification
- (void)setCallLogCompleted:(NSNotification *) note{
}
# pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"RestaurantsViewController"]){
        RestaurantsViewController * vc = (RestaurantsViewController *)[segue destinationViewController];
        [vc setDetailItem:_selectedCategory];
    }else if([segue.identifier isEqualToString:@"RestaurantViewController"]){
        RestaurantViewController * vc = (RestaurantViewController *)[segue destinationViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setDetailItem:_selectedRestaurant];
        
    }else if([segue.identifier isEqualToString:@"FlyerViewController"]){
        FlyerViewController * vc = (FlyerViewController *)[[segue destinationViewController] topViewController];
        [vc setDetailItem:_selectedRestaurant];
    }else{
        NSLog(@"Error : prepare for segue");
    }
}

# pragma mark - AutoLayout

- (void)addConstraint:(UIView *)view in:(UIView *)contentView{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [contentView addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [contentView addConstraint:rightConstraint];

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:0
                                                                          toItem:contentView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0];
    [contentView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:0
                                                                          toItem:contentView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0];
    [contentView addConstraint:bottomConstraint];
}

@end
