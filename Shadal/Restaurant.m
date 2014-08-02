//
//  Restaurant.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant
@synthesize server_id, updated_at;
@synthesize name, menu, phoneNumber, openingHours, closingHours, categories;
@synthesize flyer, coupon, couponString;

- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber{
    self = [super init];
    if(self != nil){
        self.name = name;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

- (NSDictionary *)dictionaryFromRestaurant{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:server_id] forKey:@"server_id"];
    [dic setObject:updated_at forKey:@"updated_at"];
    
    [dic setObject:name forKey:@"name"];
    [dic setObject:menu forKey:@"menu"];
    [dic setObject:phoneNumber forKey:@"phoneNumber"];
    [dic setObject:categories forKey:@"categories"];
    [dic setObject:[NSNumber numberWithDouble:openingHours] forKey:@"openingHours"];
    [dic setObject:[NSNumber numberWithDouble:closingHours] forKey:@"closingHours"];
    [dic setObject:[NSNumber numberWithBool:flyer] forKey:@"flyer"];
    [dic setObject:[NSNumber numberWithBool:coupon] forKey:@"coupon"];
    [dic setObject:couponString forKey:@"couponString"];
    return dic;
}

- (void)setRestaurantFromDictionary:(NSDictionary *)dictionary{
    NSLog(@"%@", dictionary);
    
    self.server_id = [[dictionary objectForKey:@"id"] intValue];
    self.updated_at = [dictionary objectForKey:@"updated_at"];
    
    self.name = [dictionary objectForKey:@"name"];
    self.phoneNumber = [dictionary objectForKey:@"phone_number"];
    self.categories = [dictionary objectForKey:@"category"];
    self.openingHours = [[dictionary objectForKey:@"openingHours"] doubleValue];
    self.closingHours = [[dictionary objectForKey:@"closingHours"] doubleValue];
    self.flyer = [[dictionary objectForKey:@"flyer"] boolValue];
    self.coupon = [[dictionary objectForKey:@"coupon"] boolValue];
    self.couponString = [dictionary objectForKey:@"couponString"];
    
    NSArray * menus = [dictionary objectForKey:@"menus"];
    NSMutableArray *res_menu = [[NSMutableArray alloc] init];
    
    NSString * currentSection = [[menus objectAtIndex:0] objectForKey:@"section"];
    NSMutableArray * sections = [[NSMutableArray alloc] init];
    NSMutableArray * prices = [[NSMutableArray alloc] init];

    for(NSDictionary * dic in menus){
        if([currentSection isEqualToString:[dic objectForKey:@"section"]]){
            [prices addObject:[NSArray arrayWithObjects:[dic objectForKey:@"name"], [dic objectForKey:@"price"], nil]];
        }else{
            [sections addObject:currentSection];
            [sections addObject:prices];
            [res_menu addObject:sections];
            
            currentSection = [dic objectForKey:@"section"];
            sections = [[NSMutableArray alloc] init];
            prices = [[NSMutableArray alloc] init];
            [prices addObject:[NSArray arrayWithObjects:[dic objectForKey:@"name"], [dic objectForKey:@"price"], nil]];
        }
    }
    
    [sections addObject:currentSection];
    [sections addObject:prices];
    [res_menu addObject:sections];
    self.menu = res_menu;
}

- (NSString *)stringWithOpenAndClosingHours{
    if(openingHours + closingHours == 0) return @"";
    return [NSString stringWithFormat:@"영업시간 %.0f:00-%.0f:00", openingHours, closingHours];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    server_id = [aDecoder decodeIntForKey:@"server_id"];
    updated_at = [aDecoder decodeObjectForKey:@"updated_at"];
    
    name = [aDecoder decodeObjectForKey:@"name"];
    menu = [aDecoder decodeObjectForKey:@"menu"];
    phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    categories = [aDecoder decodeObjectForKey:@"categories"];
    openingHours = [[aDecoder decodeObjectForKey:@"openingHours"] doubleValue];
    closingHours = [[aDecoder decodeObjectForKey:@"closingHours"] doubleValue];
    flyer = [[aDecoder decodeObjectForKey:@"flyer"] boolValue];
    coupon = [[aDecoder decodeObjectForKey:@"coupon"] boolValue];
    couponString = [aDecoder decodeObjectForKey:@"couponString"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:server_id forKey:@"server_id"];
    [aCoder encodeObject:updated_at forKey:@"updated_at"];
    
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:menu forKey:@"menu"];
    [aCoder encodeObject:phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:categories forKey:@"categories"];
    [aCoder encodeObject:[NSNumber numberWithDouble:openingHours] forKey:@"openingHours"];
    [aCoder encodeObject:[NSNumber numberWithDouble:closingHours] forKey:@"closingHours"];
    [aCoder encodeObject:[NSNumber numberWithBool:flyer] forKey:@"flyer"];
    [aCoder encodeObject:[NSNumber numberWithBool:coupon] forKey:@"coupon"];
    [aCoder encodeObject:couponString forKey:@"couponString"];
}

- (NSComparisonResult)compare:(Restaurant *)otherObject {
    return [self.name compare:otherObject.name];
}

@end
