//
//  StaticHelper.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "StaticHelper.h"
@interface StaticHelper () {
    @private
    NSMutableDictionary * s_campus;
    NSMutableArray * s_campuses;
    NSMutableArray * s_allData;
    NSMutableDictionary * s_user;
    NSString * s_uuid;
}
@end
@implementation StaticHelper


+ (id)staticHelper {
    static StaticHelper *staticHelper = nil;
    @synchronized(self) {
        if (staticHelper == nil){
            staticHelper = [[self alloc] init];
        }
    }
    return staticHelper;
}

// All Data in campus
- (NSMutableArray *)allData{
    if(s_allData == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        s_allData = [userDefault objectForKey:@"allData"];
    }
    return s_allData;
}
- (void)saveAllData:(NSMutableArray *)allData{
    s_allData = allData;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:allData forKey:@"allData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// List of campuses
- (NSMutableArray *)campuses{
    if(s_campuses == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        s_campuses = [userDefault objectForKey:@"campuses"];
    }
    return s_campuses;
}
- (void)saveCampuses:(NSMutableArray *)campuses{
    s_campuses = campuses;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:campuses forKey:@"campuses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Current Campus
- (NSMutableDictionary *)campus{
    if(s_campus == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        s_campus = [userDefault objectForKey:@"campus"];
    }
    return s_campus;
}
- (void)saveCampus:(NSMutableDictionary *)campus{
    s_campus = campus;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:campus forKey:@"campus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// User Info
- (NSMutableDictionary *)user{
    if(s_user == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        s_user = [userDefault objectForKey:@"user"];
    }
    return s_user;
}
- (void)saveUser:(NSMutableDictionary *)user{
    s_user = user;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// UUID
- (NSString *)uuid{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.carrot-drone" account:@"user"];
    
    if([retrieveuuid length]>0){
        s_uuid = retrieveuuid;
    }else{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef identifier = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        s_uuid = CFBridgingRelease(identifier);
        [SSKeychain setPassword:s_uuid forService:@"com.carrot-drone" account:@"user"];
    }
    return s_uuid;
}

@end
