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
@synthesize notice=_notice;
@synthesize minimumPrice=_minimumPrice;

@synthesize retention=_retention;
@synthesize numberOfCalls=_numberOfCalls;
@synthesize myPreference=_myPreference;
@synthesize totalNumberOfCalls=_totalNumberOfCalls;
@synthesize totalNumberOfGoods=_totalNumberOfGoods;
@synthesize totalNumberOfBads=_totalNumberOfBads;

@synthesize updatedAt=_updatedAt;

@synthesize menus=_menus;
@synthesize flyersURL=_flyersURL;

@synthesize recentCallCounter=_recentCallCounter;

-(NSString *)estimatedTotalCallString{
    int totalCall = [_totalNumberOfCalls intValue];
    if(totalCall < 10){
        totalCall =totalCall;
    }else if(totalCall < 100){
        totalCall = (totalCall/10) * 10;
    }else if(totalCall < 1000){
        totalCall = (totalCall/100) * 100;
    }else{
        totalCall = (totalCall/100) * 100;
    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:totalCall]];
    return formatted;
}

- (NSString *)officeHoursString{
    if([_openingHours doubleValue] + [_closingHours doubleValue] == 0) return @"";
    int openingHour = [_openingHours intValue];
    int closingHour = [_closingHours intValue];
    int openingMin = ([_openingHours doubleValue] - [_openingHours intValue]) * 60;
    int closingMin = ([_closingHours doubleValue] - [_closingHours intValue]) * 60;
    return [NSString stringWithFormat:@"%02d:%02d ~ %02d:%02d", openingHour, (openingMin/10)*10, closingHour, (closingMin/10)*10];
}

- (NSString *)minimumPriceString{
    if(_minimumPrice == nil || [_minimumPrice isEqualToNumber:[NSNumber numberWithInt:0]]){
        return 0;
    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:_minimumPrice];
    return formatted;
}
- (NSString *)retentionString{
    if([_retention intValue] >= 0) return [NSString stringWithFormat:@"%.0f", roundf([_retention doubleValue]*100.0)];
    else return @"0";
}
-(BOOL)isOpened{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                              initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:today];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    
    NSCalendar *myCal = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *officeHours = [myCal dateFromComponents:comp];
    
    NSTimeInterval openingHours = [officeHours timeIntervalSince1970] + [self.openingHours doubleValue] * 60 * 60;
    NSTimeInterval closingHours = [officeHours timeIntervalSince1970] + [self.closingHours doubleValue] * 60 * 60;
    NSTimeInterval now = [officeHours timeIntervalSince1970] + [today timeIntervalSinceDate:officeHours];
    
    if(openingHours < now && closingHours > now) return YES;
    else return NO;
    
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _serverID = [dic numberForKey:@"id"];
        _name = [dic stringForKey:@"name"];
        _phoneNumber = [dic stringForKey:@"phone_number"];
        _hasFlyer = [dic numberForKey:@"has_flyer"];
        _hasCoupon = [dic numberForKey:@"has_coupon"];
        _notice = [dic stringForKey:@"notice"];
        _isNew = [dic numberForKey:@"is_new"];
        _openingHours = [dic numberForKey:@"opening_hours"];
        _closingHours = [dic numberForKey:@"closing_hours"];
        _minimumPrice = [dic numberForKey:@"minimum_price"];
        
        _retention = [dic numberForKey:@"retention"];
        _numberOfCalls = [dic numberForKey:@"number_of_my_calls"];
        _myPreference = [dic numberForKey:@"my_preference"];
        _totalNumberOfCalls = [dic numberForKey:@"total_number_of_calls"];
        _totalNumberOfGoods = [dic numberForKey:@"total_number_of_goods"];
        _totalNumberOfBads = [dic numberForKey:@"total_number_of_bads"];
        
        _updatedAt = [dic stringForKey:@"updated_at"];
        _flyersURL = [dic objectForKey:@"flyers_url"];
        
        _menus = [[NSMutableArray alloc] init];
        NSArray * menus = [dic objectForKey:@"menus"];
        if (menus != nil){
            NSString * currentSection = @"";
            NSMutableArray * sections = [[NSMutableArray alloc] init];
            for (NSDictionary * menu in menus){
                Menu * m = [[Menu alloc] initWithDictionary:(NSDictionary *)menu];
                if([currentSection isEqualToString:@""]){
                    [sections addObject:m];
                    currentSection = m.section;
                }else if([currentSection isEqualToString:m.section]){
                    [sections addObject:m];
                }else{
                    [_menus addObject:sections];
                    sections = [[NSMutableArray alloc] initWithObjects:m, nil];
                    currentSection = m.section;
                }
            }
            if([sections count] != 0){
                [_menus addObject:sections];
            }
        }
        _recentCallCounter = [dic numberForKey:@"recent_call_counter"];
    }
    return self;
}

-(void)setRestaurant:(Restaurant *)restaurant{
    
    _serverID = restaurant.serverID;
    _name = restaurant.name;
    _phoneNumber = restaurant.phoneNumber;
    _hasFlyer = restaurant.hasFlyer;
    _hasCoupon = restaurant.hasCoupon;
    _notice = restaurant.notice;
    _isNew = restaurant.isNew;
    _openingHours = restaurant.openingHours;
    _closingHours = restaurant.closingHours;
    _minimumPrice = restaurant.minimumPrice;
    
    _retention = restaurant.retention;
    _numberOfCalls = restaurant.numberOfCalls;
    _myPreference = restaurant.myPreference;
    _totalNumberOfCalls = restaurant.totalNumberOfCalls;
    _totalNumberOfGoods = restaurant.totalNumberOfGoods;
    _totalNumberOfBads = restaurant.totalNumberOfBads;
    
    _updatedAt = restaurant.updatedAt;
    _flyersURL = restaurant.flyersURL;
    
    _menus = restaurant.menus;
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
    _notice                 = [aDecoder decodeObjectForKey:@"notice"];
    _minimumPrice           = [aDecoder decodeObjectForKey:@"minimumPrice"];
    
    _retention              = [aDecoder decodeObjectForKey:@"retention"];
    _numberOfCalls          = [aDecoder decodeObjectForKey:@"numberOfCalls"];
    _myPreference           = [aDecoder decodeObjectForKey:@"myPreference"];
    _totalNumberOfCalls     = [aDecoder decodeObjectForKey:@"totalNumberOfCalls"];
    _totalNumberOfGoods     = [aDecoder decodeObjectForKey:@"totalNumberOfGoods"];
    _totalNumberOfBads      = [aDecoder decodeObjectForKey:@"totalNumberOfBads"];
    
    _updatedAt             = [aDecoder decodeObjectForKey:@"updatedAt"];
    
    _menus                  = [aDecoder decodeObjectForKey:@"menus"];
    _flyersURL              = [aDecoder decodeObjectForKey:@"flyersURL"];
    
    _recentCallCounter      = [aDecoder decodeObjectForKey:@"recentCallCounter"];
    
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
    [aCoder encodeObject:_notice forKey:@"notice"];
    [aCoder encodeObject:_minimumPrice forKey:@"minimumPrice"];
    
    [aCoder encodeObject:_retention forKey:@"retention"];
    [aCoder encodeObject:_numberOfCalls forKey:@"numberOfCalls"];
    [aCoder encodeObject:_myPreference forKey:@"myPreference"];
    [aCoder encodeObject:_totalNumberOfCalls forKey:@"totalNumberOfCalls"];
    [aCoder encodeObject:_totalNumberOfGoods forKey:@"totalNumberOfGoods"];
    [aCoder encodeObject:_totalNumberOfBads forKey:@"totalNumberOfBads"];
    
    [aCoder encodeObject:_updatedAt forKey:@"updatedAt"];
    
    [aCoder encodeObject:_menus forKey:@"menus"];
    [aCoder encodeObject:_flyersURL forKey:@"flyersURL"];
    
    [aCoder encodeObject:_recentCallCounter forKey:@"recentCallCounter"];
}

@end
