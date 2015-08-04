//
//  NSDictionary+SAFEACCESSCategories.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "NSDictionary+SAFEACCESSCategories.h"

@implementation NSDictionary(SAFEACCESSCategories)

- (NSString *)stringForKey:(NSString *)key{
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSString class]]){
        return value;
    }else{
        return @"";
    }
}

- (NSNumber *)numberForKey:(NSString *)key{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }else{
        return [NSNumber numberWithInt:0];
    }
}

@end
