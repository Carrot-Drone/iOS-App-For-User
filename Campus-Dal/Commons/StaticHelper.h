//
//  StaticHelper.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>
#import <SSKeychain/SSKeychain.h>
#import "Campus.h"
#import "Restaurant.h"

@interface StaticHelper : NSObject


+ (StaticHelper *)staticHelper;
// All Data in campus
- (NSMutableArray *)allData;
- (void)saveAllData:(NSMutableArray *)allData;

// List of campuses
- (NSArray *)campuses;
- (void)saveCampuses:(NSArray *)campuses;

// Current Campus
- (Campus *)campus;
- (void)saveCampus:(Campus *)campus;

// User Info
- (NSMutableDictionary *)user;
- (void)saveUser:(NSMutableDictionary *)user;

// Recommended Restaurants
- (NSDictionary *)recommendedRestaurants;
- (void)saveRecommendedRestaurants:(NSDictionary *)recommendedRestaurants;
- (void)resetCachedRecommendedRestaurants;

// UUID
- (NSString *)uuid;

// Autoincrement counter
- (NSNumber *)counter;

// Restaurant with serverID
- (Restaurant *)restaurant:(NSNumber *)serverID;

// Restaurant Recent Call
- (BOOL)hasRecentCall:(NSNumber *)restaurantID;
- (void)saveCall:(NSNumber *)restaurantID;

// Current Version
- (NSString *)currentVersion;

// AppstoreURL
- (NSString *)appstoreURL;
- (void)setAppstoreURL:(NSString *)url;

@end
