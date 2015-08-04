//
//  Campus.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "Campus.h"
#import "CategoryModel.h"
#import "NSDictionary+SAFEACCESSCategories.h"

@implementation Campus
@synthesize serverID=_serverID;
@synthesize nameKor=_nameKor;
@synthesize nameKorShort=_nameKorShort;
@synthesize email=_email;
@synthesize categories=_categories;

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _serverID = [dic numberForKey:@"id"];
        _nameKor = [dic stringForKey:@"name_kor"];
        _nameKorShort = [dic stringForKey:@"name_kor_short"];
        _email = [dic stringForKey:@"email"];
        NSArray * categories = [dic objectForKey:@"categories"];
        if (categories != nil){
            _categories = [[NSMutableArray alloc] init];
            for (NSDictionary * category in categories){
                CategoryModel * cm = [[CategoryModel alloc] initWithDictionary:(NSDictionary *)category];
                [_categories addObject:cm];
            }
        }
    }
    
    return self;
}

# pragma NSCoding Delegates
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _serverID               = [aDecoder decodeObjectForKey:@"serverID"];
    _nameKor                = [aDecoder decodeObjectForKey:@"nameKor"];
    _nameKorShort           = [aDecoder decodeObjectForKey:@"nameKorShort"];
    _email                  = [aDecoder decodeObjectForKey:@"email"];
    _categories             = [aDecoder decodeObjectForKey:@"categories"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_serverID forKey:@"serverID"];
    [aCoder encodeObject:_nameKor forKey:@"nameKor"];
    [aCoder encodeObject:_nameKorShort forKey:@"nameKorShort"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_categories forKey:@"categories"];
}

@end
