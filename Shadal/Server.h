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
+ (void)flyersInRestaurant:(Restaurant *)restaurant;
+ (void)campuses;

+ (void)sendCallLog:(NSString *)params;

// Sync
+ (NSArray *)allRestaurants;


@end
