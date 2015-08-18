//
//  Category_.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "CategoryModel.h"

#import "Restaurant.h"

#import "NSDictionary+SAFEACCESSCategories.h"

@implementation CategoryModel

@synthesize serverID=_serverID;
@synthesize title=_title;
@synthesize restaurants=_restaurants;

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _serverID = [dic numberForKey:@"id"];
        _title = [dic stringForKey:@"title"];
        NSArray * restaurants = [dic objectForKey:@"restaurants"];
        if (restaurants != nil){
            _restaurants = [[NSMutableArray alloc] init];
            for (NSDictionary * restaurant in restaurants){
                Restaurant * res = [[Restaurant alloc] initWithDictionary:(NSDictionary *)restaurant];
                [_restaurants addObject:res];
            }
        }
    }
    return self;
}

# pragma NSCoding Delegates
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _serverID               = [aDecoder decodeObjectForKey:@"serverID"];
    _title                  = [aDecoder decodeObjectForKey:@"title"];
    _restaurants            = [aDecoder decodeObjectForKey:@"restaurants"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_serverID forKey:@"serverID"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_restaurants forKey:@"restaurants"];
}

@end