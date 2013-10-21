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
//@synthesize book;
/*
-(BookHandle)excelBook{
    if(book != nil)
        xlBookRelease(book);
    
    NSString * filename = [NSString stringWithFormat:@"SNU 전단지 정리본"];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"xlsx"];
    filename = resourcePath;
    
    book = xlCreateXMLBook();
    xlBookLoad(book, [filename UTF8String]);
    
    return book;
}
- (Restaurant *)getResFromExcelSheetIndex:(int)index{
    SheetHandle sheet = xlBookGetSheet([self excelBook], index);
    
    Restaurant * res = [[Restaurant alloc] init];
    res.name = [NSString stringWithUTF8String:xlSheetReadStrA(sheet, 1, 2, NULL)];
    res.categories = [NSString stringWithUTF8String:xlSheetReadStrA(sheet, 2, 2, NULL)];
    res.openingHours = xlSheetReadNumA(sheet, 3, 2, NULL)/100 + fmod(xlSheetReadNumA(sheet, 3, 2, NULL), 100)/60.0;
    res.closingHours = xlSheetReadNumA(sheet, 3, 3, NULL)/100 + fmod(xlSheetReadNumA(sheet, 3, 3, NULL), 100)/60.0;
    
    res.phoneNumber = [NSString stringWithUTF8String:xlSheetReadStrA(sheet, 4, 2, NULL)];
    
    int k = xlSheetReadNumA(sheet, 6, 2, NULL);
    
    res.menu = [[NSMutableArray alloc] init];
    NSMutableDictionary * keyChecker = [[NSMutableDictionary alloc] init];
    NSMutableArray * menu = [[NSMutableArray alloc] init];
    NSString * previousSection;
    
    for(int i=0; i<k; i++){
        if(fmod(i, 20)==0){
            sheet = xlBookGetSheet([self excelBook], index);
        }
        NSString * section = [NSString stringWithUTF8String:xlSheetReadStrA(sheet, 8+i, 0, NULL)];
        NSString * menuName = [NSString stringWithUTF8String:xlSheetReadStrA(sheet, 8+i, 3, NULL)];
        NSString * price = [NSString stringWithFormat:@"%d", (int)xlSheetReadNumA(sheet, 8+i, 8, NULL)];
        NSArray * _menu = [NSArray arrayWithObjects:menuName, price, nil];
        
        if([keyChecker objectForKey:section]==nil){
            [keyChecker setObject:section forKey:section];
            if([menu count]!=0){
                [res.menu addObject:[NSArray arrayWithObjects:previousSection, [menu copy], nil]];
                [menu removeAllObjects];
            }
        }
        [menu addObject:_menu];
        previousSection = section;
        NSLog(@"%@ %@", menuName, price);
    }
    [res.menu addObject:[NSArray arrayWithObjects:previousSection, menu, nil]];
    return res;
}
 */
/*
- (void)createFileFromExcel{
    allData = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * array1 = [[NSMutableArray alloc] init];  // 치킨
    NSMutableArray * array2 = [[NSMutableArray alloc] init];  // 피자
    NSMutableArray * array3 = [[NSMutableArray alloc] init];  // 중국집
    NSMutableArray * array4 = [[NSMutableArray alloc] init];  // 한식/분식
    NSMutableArray * array5 = [[NSMutableArray alloc] init];  // 도시락/돈가스
    NSMutableArray * array6 = [[NSMutableArray alloc] init];  // 족발/보쌈
    NSMutableArray * array7 = [[NSMutableArray alloc] init];  // 냉면
    NSMutableArray * array8 = [[NSMutableArray alloc] init];  // 패스트푸드
    NSMutableArray * array9 = [[NSMutableArray alloc] init];  // 기타
    
    [allData setObject:array1 forKey:@"치킨"];
    [allData setObject:array2 forKey:@"피자"];
    [allData setObject:array3 forKey:@"중국집"];
    [allData setObject:array4 forKey:@"한식/분식"];
    [allData setObject:array5 forKey:@"도시락/돈까스"];
    [allData setObject:array6 forKey:@"족발/보쌈"];
    [allData setObject:array7 forKey:@"냉면"];
    [allData setObject:array8 forKey:@"패스트푸드"];
    [allData setObject:array9 forKey:@"기타"];
    
    int k = xlBookSheetCountA([self excelBook]);
    for(int i=0; i<k; i++){
        if(i==33){
            
        }
        Restaurant * res = [self getResFromExcelSheetIndex:i];
        NSMutableArray *array = [allData objectForKey:res.categories];
        [array addObject:res];
        [allData setObject:array forKey:res.categories];
    }
    
    NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:allData];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    [myData writeToFile:[NSString stringWithFormat:@"%@/allData.bin", documentDir] atomically:YES];
}*/

- (NSString *)filePath{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allData" ofType:@"bin"];
    return filePath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self createFileFromExcel];
    
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
        NSString * params = [[NSString alloc] initWithFormat:@"phoneNumber=%@", [prefs objectForKey:@"phoneNumber"]];
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
