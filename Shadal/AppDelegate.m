//
//  AppDelegate.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Server.h"

#import "RestaurantViewController.h"

@implementation AppDelegate

@synthesize allData;
- (NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"Gwanak.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self resetData];
    }
    return filePath;
}

- (void)resetData{
    NSArray *json = [Server allRestaurants];
    
    NSMutableDictionary * _allData = [[NSMutableDictionary alloc] init];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"치킨"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"피자"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"중국집"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"한식/분식"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"도시락/돈까스"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"족발/보쌈"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"냉면"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"기타"];
    
    for(int i=0; i<[json count]; i++){
        NSDictionary * res = [json objectAtIndex:i];
        
        Restaurant * restaurant = [[Restaurant alloc] init];
        [restaurant setRestaurantFromDictionary:res];
        
        [[_allData objectForKey:restaurant.categories] addObject:restaurant];
    }
    // Save alldata to file
    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:_allData];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] error:nil];
    
    [myData writeToFile:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] atomically:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData * myData = [NSData dataWithContentsOfFile:[self filePath]];
    self.allData = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
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
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithBool:YES] forKey:@"callBool"];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [connection start];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs objectForKey:@"callBool"] boolValue]==NO){
        NSString * params = [prefs objectForKey:@"params"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, NEW_CALL]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection start];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save alldata to file
    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:allData];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] error:nil];
    
    [myData writeToFile:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] atomically:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Save alldata to file
    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:allData];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] error:nil];

    [myData writeToFile:[NSString stringWithFormat:@"%@/Gwanak.json", documentDir] atomically:YES];
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
