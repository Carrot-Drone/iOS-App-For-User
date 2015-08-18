//
//  Restaurant.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber * serverID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSNumber * hasFlyer;
@property (nonatomic, strong) NSNumber * hasCoupon;
@property (nonatomic, strong) NSNumber * isNew;
@property (nonatomic, strong) NSNumber *  openingHours;
@property (nonatomic, strong) NSNumber * closingHours;
@property (nonatomic, strong) NSString * notice;
@property (nonatomic, strong) NSNumber * minimumPrice;

@property (nonatomic, strong) NSNumber * retention;
@property (nonatomic, strong) NSNumber * numberOfCalls;
@property (nonatomic, strong) NSNumber * myPreference;
@property (nonatomic, strong) NSNumber * totalNumberOfCalls;
@property (nonatomic, strong) NSNumber * totalNumberOfGoods;
@property (nonatomic, strong) NSNumber * totalNumberOfBads;

@property (nonatomic, strong) NSString * updatedAt;

@property (nonatomic, strong) NSMutableArray * menus;
@property (nonatomic, strong) NSMutableArray * flyersURL;

// Used in 'sort by recent call'
@property (nonatomic, strong) NSNumber * recentCallCounter;

-(NSString *)officeHoursString;
-(NSString *)minimumPriceString;
-(NSString *)estimatedTotalCallString;
-(NSString *)retentionString;
-(BOOL)isOpened;
-(void)setRestaurant:(Restaurant *)restaurant;
-(id)initWithDictionary:(NSDictionary *)dic;

@end
