//
//  AppDelegate.m
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#import "AppDelegate.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "SelectCampusViewController.h"
#import "MainTabBarController.h"
#import "RestaurantViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

#import  "Constants.h"
#import "CategoryModel.h"
#import "Menu.h"

// GA
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

// Flurry
#import "Flurry.h"

// AirBridge
#import <AirBridge/AirBridge.h>
#import <AirBridge/ABCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize mainTabBarController=_mainTabBarController;

NSString *AIRBRIDGE_USER_TOKEN = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjIsInR5cCI6ImFpcmJyaWRnZS9hcGkvdjEiLCJhdWQiOiJBSVJCUklER0UifQ.JAYWkkE-9T09qoNbJXkJtdHAMAfQAIa-xy8vp2jrN9M";
NSString *AIRBRIDGE_APP_TOKEN = @"3";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set Status Bar color to white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    // Set TableView Insets
    // iOS 7:
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
    
    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    
    // iOS 8:
    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
    }
    // Set NavigationBar
    [[UINavigationBar appearance] setTranslucent:NO];
    
    // If Campus is not Set
    if([[StaticHelper staticHelper] campus] == NULL){
        UINavigationController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SelectCampusNavigationController"];
        self.window.rootViewController = vc;
    }else{
        self.window.rootViewController = self.mainTabBarController;
    }
    [self.window makeKeyAndVisible];
    
    
    
    // 구글아날리틱스, Google Analytics GA
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 5;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    //init Flurry
    [Flurry startSession:FLURRY_API_KEY];
    
    //AirBridge
    AirBridge* airbridge_instance = [AirBridge getInstance:AIRBRIDGE_USER_TOKEN appToken:AIRBRIDGE_APP_TOKEN];
    [ABCommon showDebugConsole:YES];
    
    [airbridge_instance registDefaultRoutingCallback:^(NSString *routing, NSDictionary *params, NSError *error) {
        NSNumber * restaurant_id = [NSNumber numberWithInt:[[params objectForKey:@"restaurant_id"] intValue]];
        NSString * campusName = [[params objectForKey:@"campusName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self callRestaurantView:restaurant_id campusName:campusName];
    }];
    /*
    
    [airbridge_instance registRouting:@"//"
                             callback:^(NSDictionary *params) {
                                 
                             }];
    */
    return YES;
}

// Check Version
- (void)getMinimumAppVersionCompleted:(NSNotification *)note{
    NSDictionary * dictionary = [note userInfo];
    NSString * newestVersion = [dictionary objectForKey:@"minimum_ios_version"];
    NSString * appstoreURL = [dictionary objectForKey:@"ios_appstore_url"];
    [[StaticHelper staticHelper] setAppstoreURL:appstoreURL];
    NSString * currentVersion = [[StaticHelper staticHelper] currentVersion];

    NSComparisonResult result = [newestVersion compare:currentVersion];
    if (result == NSOrderedDescending){
        // 새 버전이 나온 경우
        UIAlertView * av =[[UIAlertView alloc] initWithTitle:@"새 버전이 업데이트 되었습니다" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"업데이트 하러 가기", nil];
        av.delegate = self;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * url =[[StaticHelper staticHelper] appstoreURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // save Data
    [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // set Notification : 버전 체크
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(getMinimumAppVersionCompleted:) name:@"get_minimum_app_version" object:nil];
    
    [[[ServerHelper alloc] init] get_minimum_app_version];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // save Data
    [[StaticHelper staticHelper] saveAllData:[[StaticHelper staticHelper] allData]];
}

// KAKAO TALK
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([[AirBridge instance] canHandleURL:url]) {
        [[AirBridge instance]handleURL:url];
        return YES;
    }
    
    if ([KOSession isKakaoLinkCallback:url]) {
        NSLog(@"KakaoLink callback! query string: %@", [url query]);
        
        NSArray *parameters = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [parameters count]; i=i+2) {
            [paramDic setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
        }
        NSLog(@"%@", paramDic);
        NSLog(@"%@", [paramDic objectForKey:@"restaurant_id"]);
        
        NSNumber * restaurant_id = [NSNumber numberWithInt:[[paramDic objectForKey:@"restaurant_id"] intValue]];
        NSString * campusName = [[paramDic objectForKey:@"campusName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self callRestaurantView:restaurant_id campusName:campusName];
        return YES;
    }
    return NO;
}
- (void)callRestaurantView:(NSNumber *)restaurant_id campusName:(NSString *)campusName{
    // init Restaurant View Controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    Restaurant * restaurant = [[StaticHelper staticHelper] restaurant:restaurant_id];
    if(restaurant == nil) {
        restaurant = [[Restaurant alloc] init];
        restaurant.serverID = restaurant_id;
        restaurant.notice = @"  ";
    }
    
    [vc setDetailItem:restaurant];
    vc.campusNameForKakaoShare = campusName;
    
    [self.window makeKeyAndVisible];
    if([self.window.rootViewController isMemberOfClass:[MainTabBarController class]]){
        MainTabBarController * mainTabBarController = (MainTabBarController *)self.window.rootViewController;
        
        // disable Button for 0.5 sec
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [(UINavigationController *)mainTabBarController.selectedViewController pushViewController:vc animated:YES];
        });
        
    }else if([self.window.rootViewController isMemberOfClass:[UINavigationController class]]){
        UINavigationController * navigationController = (UINavigationController *)self.window.rootViewController;
        // disable Button for 0.5 sec
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [navigationController pushViewController:vc animated:YES];
        });
    }
    

}

@end
