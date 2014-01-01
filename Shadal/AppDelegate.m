//
//  AppDelegate.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize allData;
- (NSString *)filePath{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allData" ofType:@"bin"];
    return filePath;
}

- (void)sendData{
    NSMutableArray * categories = [[NSMutableArray alloc] init];
    [categories addObject:@"치킨"];
    [categories addObject:@"피자"];
    [categories addObject:@"중국집"];
    [categories addObject:@"한식/분식"];
    [categories addObject:@"도시락/돈까스"];
    [categories addObject:@"족발/보쌈"];
    [categories addObject:@"냉면"];
    [categories addObject:@"기타"];
    int k =1;
    for(int i=0; i<[categories count]; i++){
        NSMutableArray * resArray = [allData objectForKey:[categories objectAtIndex:i]];
        
        for(int j=0; j<[resArray count]; j++){
            Restaurant * restaurant = [resArray objectAtIndex:j];
            NSLog(@"%d %@",k++, restaurant.name);
            
            NSString * params = [NSString stringWithFormat:@"name=%@&phoneNumber=%@&campus=Yongon", restaurant.name, restaurant.phoneNumber];
            NSURL *url = [NSURL URLWithString:WEB_BASE_URL];
            
            
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
            
            [theRequest setHTTPMethod:@"POST"];
            
            [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
            [connection start];
        }
    }
    /*
        Restaurant * restaurant;
    
        NSString * params = [NSString stringWithFormat:@"name=%@&phoneNumber=%@&campus=Yongon", restaurant.name, restaurant.phoneNumber];
        NSURL *url = [NSURL URLWithString:WEB_BASE_URL];
    
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        
        [theRequest setHTTPMethod:@"POST"];

        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection start];
     */
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self createFileFromExcel];
    
    NSData * myData = [NSData dataWithContentsOfFile:[self filePath]];
    self.allData = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
    [self sendData];
    return YES;
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
        NSURL *url = [NSURL URLWithString:WEB_BASE_URL];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection start];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
