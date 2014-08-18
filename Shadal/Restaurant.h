//
//  Restaurant.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject <NSCoding>

@property (nonatomic) int server_id;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSMutableArray * menu;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * categories;
@property (nonatomic) double openingHours;
@property (nonatomic) double closingHours;

@property (nonatomic) BOOL has_flyer;
@property (nonatomic) BOOL has_coupon;
@property (nonatomic) BOOL is_new;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, strong) NSString * couponString;


- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber;
- (NSDictionary *)dictionaryFromRestaurant;
- (void)setRestaurantFromDictionary:(NSDictionary *)dictionary;

- (NSString *)stringWithOpenAndClosingHours;
- (NSComparisonResult)compare:(Restaurant *)otherObject;
@end
