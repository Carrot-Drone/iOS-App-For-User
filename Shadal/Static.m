//
//  Static.m
//  Shadal
//
//  Created by Sukwon Choi on 2/10/15.
//  Copyright (c) 2015 Wafflestudio. All rights reserved.
//

#import "SSKeychain.h"
#import "Static.h"
#import "Server.h"

@implementation Static

static NSDictionary * current_campus_info;
static NSDictionary * s_allData;
static NSArray * s_campuses;
static NSString * s_uuid;



// Static variable

// campus_info
+ (NSDictionary *)campusInfo{
    return current_campus_info;
}
+ (void)setCampusInfo:(NSDictionary *)campusInfo{
    current_campus_info = campusInfo;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:current_campus_info forKey:@"campus_info"];
    
    [Server updateUUID];
}

+ (NSString *)campus{
    return [[self campusInfo] objectForKey:@"name_eng"];
}

+ (NSDictionary *)allData{
    return s_allData;
}
+ (void)setAllData:(NSMutableDictionary *)dic{
    s_allData = [dic copy];
}

+(NSString *)UUID{
    return s_uuid;
}
+ (void)setUUID{
    // Set Uuid
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.wafflestudio.shawa" account:@"user"];
    
    if([retrieveuuid length]>0){
        s_uuid = retrieveuuid;
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef identifier = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        s_uuid = CFBridgingRelease(identifier);
        [SSKeychain setPassword:s_uuid forService:@"com.wafflestudio.shawa" account:@"user"];
    }
}

// Save and load data
+ (void)saveData{
    // save current campus
    if([Static campusInfo] != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[Static campusInfo] forKey:@"campus_info"];
    }
    
    // Save alldata to file
    if(s_allData != nil){
        NSData * myData = [NSKeyedArchiver archivedDataWithRootObject:s_allData];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentDir = [paths objectAtIndex:0];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.json", documentDir, [Static campus]] error:nil];
        
        [myData writeToFile:[NSString stringWithFormat:@"%@/%@.json", documentDir, [Static campus]] atomically:YES];
    }
}

+ (void)loadData{
    // Set current campus
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    current_campus_info = [defaults objectForKey:@"campus_info"];
    
    if(current_campus_info != nil){
        NSData * myData = [NSData dataWithContentsOfFile:[self filePath]];
        s_allData = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    }
}

//
+ (NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", [Static campus]]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self resetData];
    }
    return filePath;
}

+ (void)resetData{
    NSMutableDictionary * _allData = [[NSMutableDictionary alloc] init];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"치킨"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"피자"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"중국집"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"한식/분식"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"도시락/돈까스"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"족발/보쌈"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"냉면"];
    [_allData setObject:[[NSMutableArray alloc] init] forKey:@"기타"];
    
    NSArray *json = [Server allRestaurants];
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
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.json", documentDir, [Static campus]] error:nil];
    
    [myData writeToFile:[NSString stringWithFormat:@"%@/%@.json", documentDir, [Static campus]] atomically:YES];
}

@end
