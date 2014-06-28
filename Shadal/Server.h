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

+ (void)updateRestaurant:(Restaurant *)restaurant;
+ (Restaurant *)getRestaurantFromServer:(int)restaurant_id;
+ (BOOL)checkForNewRestaurant;

@end
