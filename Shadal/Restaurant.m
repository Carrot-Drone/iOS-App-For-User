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
@synthesize has_flyer, has_coupon, couponString;
@synthesize isFavorite;

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
    [dic setObject:[NSNumber numberWithBool:has_flyer] forKey:@"has_flyer"];
    [dic setObject:[NSNumber numberWithBool:has_coupon] forKey:@"has_coupon"];
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
    self.has_flyer = [[dictionary objectForKey:@"has_flyer"] boolValue];
    self.has_coupon = [[dictionary objectForKey:@"has_coupon"] boolValue];
    self.couponString = [dictionary objectForKey:@"coupon_string"];
    
    NSArray * menus = [dictionary objectForKey:@"menus"];
    NSMutableArray *res_menu = [[NSMutableArray alloc] init];
    
    NSString * currentSection = @"";
    if([menus count]!=0){
        currentSection = [[menus objectAtIndex:0] objectForKey:@"section"];
    }
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
    has_flyer = [[aDecoder decodeObjectForKey:@"has_flyer"] boolValue];
    has_coupon = [[aDecoder decodeObjectForKey:@"has_coupon"] boolValue];
    couponString = [aDecoder decodeObjectForKey:@"couponString"];
    isFavorite = [[aDecoder decodeObjectForKey:@"isFavorite"] boolValue];
    
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
    [aCoder encodeObject:[NSNumber numberWithBool:has_flyer] forKey:@"has_flyer"];
    [aCoder encodeObject:[NSNumber numberWithBool:has_coupon] forKey:@"has_coupon"];
    [aCoder encodeObject:couponString forKey:@"couponString"];
    [aCoder encodeObject:[NSNumber numberWithBool:isFavorite] forKey:@"isFavorite"];
}

- (NSComparisonResult)compare:(Restaurant *)otherObject {
    return [self.name compare:otherObject.name];
}

@end
