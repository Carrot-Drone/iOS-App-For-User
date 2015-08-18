//
//  MainTabBarController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "MainTabBarController.h"
#import "UIImage+IMAGECategories.h"
#import "UIColor+COLORCategories.h"
#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

@implementation MainTabBarController {
    
}

- (void)viewDidLoad{
    // init Appearance
    
    // UITabBarItem
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:MAIN_FONT size:10.0f], NSFontAttributeName,
      nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:MAIN_FONT_BOLD size:10.0f], NSFontAttributeName,
      [UIColor colorWithRGBHex:0xfb7010], NSForegroundColorAttributeName,
      nil] forState:UIControlStateSelected];
    
    // UIBarItem
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:MAIN_FONT size:17.0], NSFontAttributeName,
                                        [UIColor colorWithRGBHex:0xffffff], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    
    
    // init tab bar
    UITabBar *tabBar = self.tabBar;
    tabBar.tintColor = MAIN_COLOR;
    tabBar.backgroundColor = TAB_BAR_BG_COLOR;
    
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.selectedImage = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_recent_selected"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.image = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_recent_normal"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.title = @"최근주문";
    tabBarItem1.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    tabBarItem2.selectedImage = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_store_selected"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_store_normal"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.title = @"음식점";
    tabBarItem2.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    tabBarItem3.selectedImage = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_recommand_selected"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_recommand_normal"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.title = @"추천";
    tabBarItem3.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    tabBarItem4.selectedImage = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_more_selected"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem4.image = [[UIImage imageWithImage:[UIImage imageNamed:@"Icon_tab_bar_more_normal"] scaledToSize:CGSizeMake(30, 30) ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem4.title = @"더보기";
    tabBarItem4.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRecommendedRestaurantsCompleted:)
                                                 name:@"get_recommended_restaurants"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCampusCompleted:)
                                                 name:@"get_campus"
                                               object:nil];
    
    // Set Recommended restaurant
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper get_recommended_restaurants:[[[StaticHelper staticHelper] campus] serverID]];
    
    // get Campus
    if([[StaticHelper staticHelper] campus] != nil){
        [serverHelper get_campus:[[[StaticHelper staticHelper] campus] serverID]];
    }
    
    // load view controllers
    [self.viewControllers makeObjectsPerformSelector:@selector(view)];

    
}
- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)getRecommendedRestaurantsCompleted:(NSNotification *)note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] == 200){
        NSDictionary * recommendedRestaurants = [json objectForKey:@"recommendedRestaurants"];
        [[StaticHelper staticHelper] saveRecommendedRestaurants:recommendedRestaurants];
    }
}
-(void)getCampusCompleted:(NSNotification *)note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] == 200){
        Campus * campus = [[Campus alloc] initWithDictionary:json];
        [[StaticHelper staticHelper] saveCampus:campus];
    }
}

@end
