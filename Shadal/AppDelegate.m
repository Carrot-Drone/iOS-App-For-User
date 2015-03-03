//
//  AppDelegate.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "SSKeychain.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Server.h"
#import "Static.h"

#import "RestaurantViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Static setUUID];
    NSLog(@"%@",[Static UUID]);
    
    [Static loadData];
    
    // init tabbar
    UITabBarController * tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.delegate = self;
    [tabBarController.tabBar setBarTintColor:BAR_TINT_COLOR];
    [tabBarController.tabBar setTintColor:MAIN_COLOR];

    [self setTabBarItemImage];

    // init navigation bar
    UIFont * customFont = FONT_EB(19.5);
    if(customFont == nil) NSLog(@"Font not exist");
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               customFont, NSFontAttributeName,
                                               nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    return YES;
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if([(UINavigationController *)viewController respondsToSelector:@selector(viewControllers)]){
        UIViewController * rootViewController = ((UINavigationController *)viewController).viewControllers[0];
        if([rootViewController isKindOfClass:[RestaurantViewController class]]){
            [((RestaurantViewController *)rootViewController) setDetailItem:[self randomRestaurant]];
            [((RestaurantViewController *)rootViewController) updateUI];
            ((RestaurantViewController *)rootViewController).isFromRandom = TRUE;
        }
    }
    return true;
}

- (Restaurant *)randomRestaurant{
    
    NSDictionary * allData = [Static allData];
    // 전체 음식점 갯수
    int cnt = 0;
    for(id key in allData){
        cnt += [[allData objectForKey:key] count];
    }
    Restaurant * res;
    do{
        if(cnt == 0) break;
        int r = arc4random() % cnt;
        for(id key in allData){
            NSString* category = key;
            if([[allData objectForKey:category] count] <= r){
                r -= [[allData objectForKey:category] count];
            }else{
                res = [[allData objectForKey:category] objectAtIndex:r];
                break;
            }
        }
    }while(res.server_id == 0 || [res.menu count] == 0);
    return res;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs objectForKey:@"callBool"] boolValue]==NO){
        NSString * params = [prefs objectForKey:@"params"];
        if(params != nil)
            [Server sendCallLog:params];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [Static saveData];
}

- (void)setTabBarItemImage{
    UITabBarController * tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UITabBarItem *item1 = [tabBarController.tabBar.items objectAtIndex:0];
    item1.title = @"메인화면";
    item1.image = [UIImage imageNamed:@"BotIconMain.png"];
    item1.selectedImage = [UIImage imageNamed:@"BotIconMainSelect.png"];
    UITabBarItem *item2 = [tabBarController.tabBar.items objectAtIndex:1];
    item2.title = @"즐겨찾기";
    item2.image = [UIImage imageNamed:@"BotIconStar.png"];
    item2.selectedImage = [UIImage imageNamed:@"BotIconStarSelect.png"];
    UITabBarItem *item3 = [tabBarController.tabBar.items objectAtIndex:2];
    item3.title = @"아무거나";
    item3.image = [UIImage imageNamed:@"BotIconRandom.png"];
    item3.selectedImage = [UIImage imageNamed:@"BotIconRandomSelect.png"];
    UITabBarItem *item4 = [tabBarController.tabBar.items objectAtIndex:3];
    item4.title = @"더보기";
    item4.image = [UIImage imageNamed:@"BotIconMore.png"];
    item4.selectedImage = [UIImage imageNamed:@"BotIconMoreSelect.png"];
    
    for (UITabBarItem  *tab in tabBarController.tabBar.items) {
        
//        tab.image = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
//        tab.selectedImage = [tab.selectedImage imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [tab setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_EB_TAB(12.5), NSFontAttributeName,  [UIColor darkGrayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        
        [tab setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_EB_TAB(12.5), NSFontAttributeName,  MAIN_COLOR, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
        /*
        [tab setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_EB(12.5), NSFontAttributeName,  [UIColor colorWithRed:51/255.0 green:255/255.0 blue:231/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
         */
        
    }
}
@end
