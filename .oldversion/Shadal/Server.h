//
//  Server.h
//  Shadal
//
//  Created by Sukwon Choi on 6/25/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface Server : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// Async
+ (BOOL)isConnected;
+ (void)updateRestaurant:(Restaurant *)restaurant;
+ (void)checkForNewRestaurant:(NSString *)category;
+ (void)campuses;

+ (void)sendCallLog:(NSString *)params;

+ (void)updateUUID;

// Sync
+ (NSArray *)allRestaurants;

// GA
+ (void)sendGoogleAnalyticsEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;
+ (void)sendGoogleAnalyticsScreen:(NSString *)screenName;


@end
