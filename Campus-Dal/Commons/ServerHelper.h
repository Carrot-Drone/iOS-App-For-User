//
//  ServerHelper.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

@interface ServerHelper : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIAlertViewDelegate>

// Check internet connection
- (BOOL)isConnected;

// API's

// Sync
- (NSArray *)get_campuses_list_sync;
- (NSDictionary *)get_recommended_restaurants_sync:(NSNumber *)campusID;
- (NSArray *)get_restaurants_sync:(NSNumber *)campusID;

// Async
- (void)get_campuses_list;
- (void)get_campus:(NSNumber *)campusID;
- (void)get_restaurants:(NSNumber *)campusID;
- (void)get_restaurants_list_in_category:(NSNumber *)campusID categoryID:(NSNumber *)categoryID;
- (void)get_restaurant:(NSNumber *)restaurantID updatedAt:(NSString *)updatedAt;
- (void)get_recommended_restaurants:(NSNumber *)campusID;
- (void)set_user_preference:(NSNumber *)restaurantID preference:(NSNumber *)preference;
- (void)set_call_log:(NSNumber *)campusID categoryID:(NSNumber *)categoryID restaurantID:(NSNumber *)restaurantID numberOfCalls:(NSNumber *)numberOfCalls hasRecentCall:(BOOL)hasRecentCall;
- (void)set_device:(NSNumber *)campusID deviceType:(NSString *)deviceType;
- (void)set_campus_reservation:(NSString *)campusName phoneNumber:(NSString *)phoneNumber;
- (void)set_restaurant_correction:(NSNumber *)restaurantID majorCorrection:(NSString *)majorCorrection details:(NSString *)details;

- (void)set_restaurant_suggestion:(NSNumber *)campusID name:(NSString *)name phoneNumber:(NSString *)phoneNumber officeHours:(NSString *)officeHours isSuggestedByRestaurant:(BOOL)isSuggestedByRestaurant images:(NSArray *)images;

- (void)set_user_request:(NSString *)emails details:(NSString *)details;
- (void)get_minimum_app_version;

// GA
+ (void)sendGoogleAnalyticsEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;
+ (void)sendGoogleAnalyticsScreen:(NSString *)screenName;


@end
