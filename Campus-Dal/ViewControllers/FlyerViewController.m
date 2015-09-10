//
//  FlyerViewController.m
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import "FlyerViewController.h"
#import "CustomTitleView.h"
#import "Restaurant.h"
#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

@interface FlyerViewController (){
    Restaurant * _restaurant;
    
    NSInteger _numberOfPage;
    NSInteger _previousPage;
    
    NSMutableArray * _imagesURL;
}

@end

@implementation FlyerViewController

@synthesize scrollView=_scrollView;
@synthesize pageControl=_pageControl;
@synthesize footerView=_footerView;

- (void)setDetailItem:(Restaurant *)restaurant{
    _restaurant = restaurant;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init navigation controller
    [self initNavigationController];
    
    // init footer
    [_footerView.phoneNumberLabel setText:_restaurant.phoneNumber];
    [_footerView.phoneCallButton addTarget:self action:@selector(phoneCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // init imagesURL
    _imagesURL = [[NSMutableArray alloc] init];
    for(NSString * flyerURL in _restaurant.flyersURL){
        [_imagesURL addObject:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, flyerURL]];
    }
    _numberOfPage = [_imagesURL count];
    
    [_pageControl setNumberOfPages:_numberOfPage];
    [_pageControl setTintColor:[UIColor whiteColor]];
    [_pageControl setCurrentPageIndicatorTintColor:MAIN_COLOR];
    
    // init scroll view
    _scrollView.delegate = self;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CGFloat scrollWidth = _scrollView.frame.size.width;
    CGFloat scrollHeight = _scrollView.frame.size.height - 20 -44;
    
    [_scrollView setContentSize:CGSizeMake(scrollWidth*_numberOfPage, scrollHeight)];
    
    for(int i=0; i<_numberOfPage; i++){
        UIScrollView * innerScrollView = [[UIScrollView alloc] init];
        innerScrollView.delegate = self;
        [innerScrollView setFrame:CGRectMake(scrollWidth*i, 0, scrollWidth, scrollHeight)];
        [innerScrollView setContentSize:innerScrollView.frame.size];
        [innerScrollView setContentMode:UIViewContentModeScaleAspectFit];
        innerScrollView.bouncesZoom = NO;
        innerScrollView.bounces = NO;
        innerScrollView.clipsToBounds = YES;
        innerScrollView.zoomScale = 2.0;
        innerScrollView.minimumZoomScale = 1.0;
        innerScrollView.maximumZoomScale = 2.0;
        
        
        UIImageView * backgroundImage = [[UIImageView alloc] init];
        [backgroundImage setFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        [backgroundImage setContentMode:UIViewContentModeScaleAspectFit];
        [backgroundImage sd_setImageWithURL:[NSURL URLWithString:[_imagesURL objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"icon_flyer_waiting"]];
        
        [innerScrollView addSubview:backgroundImage];
        
        // resize backgroundImage
        [backgroundImage setNeedsLayout];
        [backgroundImage layoutIfNeeded];
        CGRect bounds;
        
        bounds.origin = CGPointZero;
        bounds.size = backgroundImage.frame.size;
        innerScrollView.bounds = bounds;
        
        [_scrollView addSubview:innerScrollView];
    }
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:_restaurant.name];
    self.navigationItem.titleView = customTitleView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCallLogCompleted:)
                                                 name:@"set_call_log"
                                               object:nil];
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"전단지 화면"];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - ButtonClicked
- (IBAction)backButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)phoneCallButtonClicked:(UIButton *)sender{
    NSLog(@"Phone Call :");
    
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
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"phonenumber_in_flyer_clicked" label:[restaurant.serverID stringValue]];
}

#pragma mark - Notification
- (void)setCallLogCompleted:(NSNotification *) note{
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:_scrollView]){
        // Main ScrollView
        // change _pageControl;
        CGFloat pageNum = nearbyintf((scrollView.contentOffset.x / scrollView.frame.size.width));
        if(pageNum != _pageControl.currentPage){
            _previousPage = _pageControl.currentPage;
            _pageControl.currentPage = pageNum;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isEqual:_scrollView]){
        // Photo ScrollView;
        // reset previous photo scale;
        if(_previousPage != [_pageControl currentPage]){
            UIScrollView * sub = [[_scrollView subviews] objectAtIndex:_previousPage];
            [sub setZoomScale:1.0];
        }
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(![scrollView isEqual:_scrollView]){
        /*
         // Photo ScrollView
         // prevent vertical scrolling
         UIView * view = [[scrollView subviews] objectAtIndex:0];
         CGFloat new_y = scrollView.contentSize.height/2 - view.frame.size.height/2;
         CGFloat new_x = view.frame.origin.x;
         // TODO: Don't know why but sometine new_y goes to 0.0 and the image flashed
         if(new_y != 0){
         [view setFrame:CGRectMake(new_x, new_y, view.frame.size.width, view.frame.size.height)];
         }
         */
    }
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if(![scrollView isEqual:_scrollView]){
        // Photo ScrollView
        NSArray * subviews = [scrollView subviews];
        if(subviews != nil && [subviews count] != 0){
            return [[scrollView subviews] objectAtIndex:0];
        }
    }
    return nil;
}

@end
