//
//  Restaurant.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Restaurant.h"
#import "Menu.h"
#import "NSDictionary+SAFEACCESSCategories.h"

@implementation Restaurant
@synthesize serverID=_serverID;
@synthesize name=_name;
@synthesize phoneNumber=_phoneNumber;
@synthesize hasFlyer=_hasFlyer;
@synthesize hasCoupon=_hasCoupon;
@synthesize isNew=_isNew;
@synthesize openingHours=_openingHours;
@synthesize closingHours=_closingHours;
@synthesize couponString=_couponString;

@synthesize retention=_retention;
@synthesize numberOfCalls=_numberOfCalls;
@synthesize myPreference=_myPreference;
@synthesize totalNumberOfCalls=_totalNumberOfCalls;
@synthesize totalNumberOfGoods=_totalNumberOfGoods;
@synthesize totalNumberOfBads=_totalNumberOfBads;

@synthesize updatedAt=_updatedAt;

@synthesize menus=_menus;
@synthesize flyersURL=_flyersURL;

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _serverID = [dic numberForKey:@"id"];
        _name = [dic stringForKey:@"name"];
        _phoneNumber = [dic stringForKey:@"phone_number"];
        _hasFlyer = [dic numberForKey:@"has_flyer"];
        _hasCoupon = [dic numberForKey:@"has_coupon"];
        _isNew = [dic numberForKey:@"is_new"];
        _openingHours = [dic numberForKey:@"opening_hours"];
        _closingHours = [dic numberForKey:@"closing_hours"];
        
        _retention = [dic numberForKey:@"retention"];
        _numberOfCalls = [dic numberForKey:@"number_of_calls"];
        _myPreference = [dic numberForKey:@"my_preference"];
        _totalNumberOfCalls = [dic numberForKey:@"total_number_of_calls"];
        _totalNumberOfGoods = [dic numberForKey:@"total_number_of_goods"];
        _totalNumberOfBads = [dic numberForKey:@"total_number_of_bads"];
        
        _updatedAt = [dic stringForKey:@"updated_at"];
        _flyersURL = [dic objectForKey:@"flyers_url"];
        
        NSArray * menus = [dic objectForKey:@"restaurants"];
        if (menus != nil){
            menus = [[NSMutableArray alloc] init];
            for (NSDictionary * menu in menus){
                Menu * m = [[Menu alloc] initWithDictionary:(NSDictionary *)menu];
                [_menus addObject:m];
            }
        }
    }
    
    return self;
}


# pragma NSCoding Delegates
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    _serverID               = [aDecoder decodeObjectForKey:@"serverID"];
    _name                   = [aDecoder decodeObjectForKey:@"name"];
    _phoneNumber            = [aDecoder decodeObjectForKey:@"phoneNumber"];
    _hasFlyer               = [aDecoder decodeObjectForKey:@"hasFlyer"];
    _hasCoupon              = [aDecoder decodeObjectForKey:@"hasCoupon"];
    _isNew                  = [aDecoder decodeObjectForKey:@"isNew"];
    _openingHours           = [aDecoder decodeObjectForKey:@"openingHours"];
    _closingHours           = [aDecoder decodeObjectForKey:@"closingHours"];
    _couponString           = [aDecoder decodeObjectForKey:@"couponString"];
    
    _retention              = [aDecoder decodeObjectForKey:@"retention"];
    _numberOfCalls          = [aDecoder decodeObjectForKey:@"numberOfCalls"];
    _myPreference           = [aDecoder decodeObjectForKey:@"myPreference"];
    _totalNumberOfCalls     = [aDecoder decodeObjectForKey:@"totalNumberOfCalls"];
    _totalNumberOfGoods     = [aDecoder decodeObjectForKey:@"totalNumberOfGoods"];
    _totalNumberOfBads      = [aDecoder decodeObjectForKey:@"totalNumberOfBads"];
    
    _updatedAt             = [aDecoder decodeObjectForKey:@"updatedAt"];
    
    _menus                  = [aDecoder decodeObjectForKey:@"menus"];
    _flyersURL              = [aDecoder decodeObjectForKey:@"flyersURL"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_serverID forKey:@"serverID"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:_hasFlyer forKey:@"hasFlyer"];
    [aCoder encodeObject:_hasCoupon forKey:@"hasCoupon"];
    [aCoder encodeObject:_isNew forKey:@"isNew"];
    [aCoder encodeObject:_openingHours forKey:@"openingHours"];
    [aCoder encodeObject:_closingHours forKey:@"closingHours"];
    [aCoder encodeObject:_couponString forKey:@"couponString"];
    
    [aCoder encodeObject:_retention forKey:@"retention"];
    [aCoder encodeObject:_numberOfCalls forKey:@"numberOfCalls"];
    [aCoder encodeObject:_myPreference forKey:@"myPreference"];
    [aCoder encodeObject:_totalNumberOfCalls forKey:@"totalNumberOfCalls"];
    [aCoder encodeObject:_totalNumberOfGoods forKey:@"totalNumberOfGoods"];
    [aCoder encodeObject:_totalNumberOfBads forKey:@"totalNumberOfBads"];
    
    [aCoder encodeObject:_updatedAt forKey:@"updatedAt"];
    
    [aCoder encodeObject:_menus forKey:@"menus"];
    [aCoder encodeObject:_flyersURL forKey:@"flyersURL"];
}

@end
