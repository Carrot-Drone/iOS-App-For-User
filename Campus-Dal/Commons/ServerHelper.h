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
- (NSURLConnection *)get_campuses_list:(BOOL)all;
- (NSURLConnection *)get_restaurants:(NSNumber *)campusID;
- (NSURLConnection *)get_restaurants_list_in_category:(NSNumber *)campusID categoryID:(NSNumber *)categoryID;
- (NSURLConnection *)get_restaurant:(NSNumber *)restaurantID updatedAt:(NSString *)updatedAt uuid:(NSString *)uuid;
- (NSURLConnection *)set_user_preference:(NSNumber *)restaurantID preference:(NSNumber *)preference uuid:(NSString *)uuid;
- (NSURLConnection *)set_call_log:(NSNumber *)campusID categoryID:(NSNumber *)categoryID restaurantID:(NSNumber *)restaurantID numberOfCalls:(NSNumber *)numberOfCalls uuid:(NSString *)uuid;
- (NSURLConnection *)set_device:(NSNumber *)campusID deviceType:(NSString *)deviceType uuid:(NSString *)uuid;
- (NSURLConnection *)set_campus_reservation:(NSString *)campusName phoneNumber:(NSString *)phoneNumber;
- (NSURLConnection *)set_restaurant_correction:(NSNumber *)restaurantID majorCorrection:(NSString *)majorCorrection details:(NSString *)details;
- (NSURLConnection *)set_restaurant_suggestion:(NSNumber *)campusID name:(NSString *)name phoneNumber:(NSString *)phoneNumber officeHours:(NSString *)officeHours isSuggestedByRestaurant:(BOOL)isSuggestedByRestaurant images:(NSArray *)images;
- (NSURLConnection *)set_user_request:(NSString *)emails details:(NSString *)details uuid:(NSString *)uuid;
- (NSURLConnection *)get_minimum_app_version;

@end
