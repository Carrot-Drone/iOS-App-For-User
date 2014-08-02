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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"allData.bin"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"allData" ofType:@"bin"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:myPathInfo toPath:filePath error:NULL];
    }
    
    return filePath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData * myData = [NSData dataWithContentsOfFile:[self filePath]];
    self.allData = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    
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
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Save alldata to file
    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:allData];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/allData.bin", documentDir] error:nil];

    [myData writeToFile:[NSString stringWithFormat:@"%@/allData.bin", documentDir] atomically:YES];
}

@end
