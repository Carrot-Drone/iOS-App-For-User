//
//  StaticHelper.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "StaticHelper.h"
#import "ServerHelper.h"

#import "Campus.h"
#import "CategoryModel.h"
#import "Restaurant.h"
#import "Menu.h"

@interface StaticHelper () {
    Campus * s_campus;
    NSArray * s_campuses;
    NSMutableArray * s_allData;
    NSMutableDictionary * s_user;
    NSString * s_uuid;
    
    NSDictionary * s_recommendedRestaurants;
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
    if([self campus]==nil) {
        NSLog(@"Error! there is no select campus");
        return nil;
    }
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber * currentCampusID = [userDefault objectForKey:@"currentCampusID"];
    if (currentCampusID != [[self campus] serverID]){
        s_allData = nil;
    }
    
    if(s_allData == nil){
        // Check User Defaults first
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data = [userDefault objectForKey:[NSString stringWithFormat:@"allData_%d", [[[self campus] serverID] intValue]]];
        s_allData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // If there is no data in User Defaults, ask Server
        if(s_allData == nil){
            NSArray * categories_data = [[[ServerHelper alloc] init] get_restaurants_sync:[[self campus] serverID]];
            
            NSMutableArray * categories = [[NSMutableArray alloc] init];
            for(NSDictionary * category_dic in categories_data){
                CategoryModel * category = [[CategoryModel alloc] initWithDictionary:category_dic];
                [categories addObject:category];
            }
            s_allData = categories;
            [self saveAllData:s_allData];
        }
    }
    return s_allData;
}
- (void)saveAllData:(NSMutableArray *)allData{
    s_allData = allData;
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:allData];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:[NSString stringWithFormat:@"allData_%d", [[[self campus] serverID] intValue]]];
    [userDefault setObject:[[self campus]serverID] forKey:@"currentCampusID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Current Campus

// List of campuses
- (NSArray *)campuses{
    // If Campuses is nil, check User Defaults. If it's still nil, get data from server
    if(s_campuses == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data = [userDefault objectForKey:@"campuses"];
        s_campuses = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(s_campuses == nil || [s_campuses count]==0){
            NSArray * campuses_data = [[[ServerHelper alloc] init] get_campuses_list_sync];
            NSMutableArray * campuses = [[NSMutableArray alloc] init];
            for(NSDictionary * campus_dic in campuses_data){
                Campus * campus = [[Campus alloc] initWithDictionary:campus_dic];
                [campuses addObject:campus];
            }
            s_campuses = campuses;
            [self saveCampuses:s_campuses];
        }
    }
    [[[ServerHelper alloc] init] get_campuses_list];
    return s_campuses;
}
- (void)saveCampuses:(NSArray *)campuses{
    s_campuses = campuses;
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:campuses];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:@"campuses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Current Campus
- (Campus *)campus{
    if(s_campus == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSData * data = [userDefault objectForKey:@"campus"];
        s_campus = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([s_campus.serverID intValue]==0){
            s_campus = nil;
            [userDefault removeObjectForKey:@"campus"];
        }
    }
    return s_campus;
}
- (void)saveCampus:(Campus *)campus{
    s_campus = campus;
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:campus];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:@"campus"];
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

// Recommended Restaurants
- (NSDictionary *)recommendedRestaurants{
    if(s_recommendedRestaurants == nil){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        s_recommendedRestaurants = [userDefault objectForKey:[NSString stringWithFormat:@"%@.%d",@"recommendedRestaurants", [[[[StaticHelper staticHelper] campus] serverID] intValue]]];
        if(s_recommendedRestaurants == nil){
            NSDictionary * recommendedRestaurants = [[[ServerHelper alloc] init] get_recommended_restaurants_sync:[[self campus] serverID]];
            s_recommendedRestaurants = recommendedRestaurants;
            [self saveRecommendedRestaurants:s_recommendedRestaurants];
        }
    }
    return s_recommendedRestaurants;
}
- (void)saveRecommendedRestaurants:(NSDictionary *)recommendedRestaurants{
    s_recommendedRestaurants = recommendedRestaurants;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:recommendedRestaurants forKey:[NSString stringWithFormat:@"%@.%d",@"recommendedRestaurants", [[[[StaticHelper staticHelper] campus] serverID] intValue]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)resetCachedRecommendedRestaurants{
    s_recommendedRestaurants = nil;
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

// Auto increment counter
- (NSNumber *)counter{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber * counter = [userDefault objectForKey:@"counter"];
    if(counter == nil){
        counter = [NSNumber numberWithInt:1];
    }
    
    [userDefault setObject:[NSNumber numberWithInt:[counter intValue]+1] forKey:@"counter"];
    
    return counter;
}

- (Restaurant *)restaurant:(NSNumber *)serverID{
    NSMutableArray * allData = [[StaticHelper staticHelper] allData];
    for(CategoryModel * category in allData){
        for(Restaurant * restaurant in category.restaurants){
            if([restaurant.serverID isEqualToNumber:serverID]){
                return restaurant;
            }
        }
    }
    return nil;
}

// Recent Call
- (BOOL)hasRecentCall:(NSNumber *)restaurantID{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber * intervalNumber = [userDefault objectForKey:[NSString stringWithFormat:@"%@.%d",@"recentCallTime", [restaurantID intValue]]];
    NSTimeInterval interval = [intervalNumber doubleValue];
    NSLog(@"%f", interval);
    if([[NSDate date] timeIntervalSince1970] - 60*60*3 <= interval){
        return YES;
    }else{
        return NO;
    }
}
- (void)saveCall:(NSNumber *)restaurantID{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%f", interval);
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithDouble:interval] forKey:[NSString stringWithFormat:@"%@.%d",@"recentCallTime", [restaurantID intValue]]];
}

// current Version
- (NSString *)currentVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// Appstore url

- (NSString *)appstoreURL{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"appstoreURL"];
}
- (void)setAppstoreURL:(NSString *)url{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:url forKey:@"appstoreURL"];
}
@end
