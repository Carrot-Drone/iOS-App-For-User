//
//  Restaurant.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant
@synthesize name, menu, phoneNumber, openingHours, closingHours, categories;

- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber{
    self = [super init];
    if(self != nil){
        self.name = name;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

- (NSString *)stringWithOpenAndClosingHours{
    if(openingHours + closingHours == 0) return @"";
    return [NSString stringWithFormat:@"영업시간 %.0f:00-%.0f:00", openingHours, closingHours];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    name = [aDecoder decodeObjectForKey:@"name"];
    menu = [aDecoder decodeObjectForKey:@"menu"];
    phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    categories = [aDecoder decodeObjectForKey:@"categories"];
    openingHours = [[aDecoder decodeObjectForKey:@"openingHours"] doubleValue];
    closingHours = [[aDecoder decodeObjectForKey:@"closingHours"] doubleValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:menu forKey:@"menu"];
    [aCoder encodeObject:phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:[NSNumber numberWithDouble:openingHours] forKey:@"openingHours"];
    [aCoder encodeObject:[NSNumber numberWithDouble:closingHours] forKey:@"closingHours"];
}

- (NSComparisonResult)compare:(Restaurant *)otherObject {
    return [self.name compare:otherObject.name];
}

@end
