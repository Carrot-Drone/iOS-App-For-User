//
//  Menu.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "Menu.h"
#import "NSDictionary+SAFEACCESSCategories.h"

@implementation Menu

@synthesize serverID=_serverID;
@synthesize section=_section;
@synthesize name=_name;
@synthesize menu_description=_menu_description;
@synthesize price=_price;
@synthesize submenus=_submenus;

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        _serverID = [dic numberForKey:@"id"];
        _name = [dic stringForKey:@"name"];
        _menu_description = [dic stringForKey:@"description"];
        _price = [dic numberForKey:@"price"];
        _submenus = [dic objectForKey:@"submenus"];
    }
    
    return self;
}


# pragma NSCoding Delegates
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _serverID           = [aDecoder decodeObjectForKey:@"serverID"];
    _section            = [aDecoder decodeObjectForKey:@"section"];
    _name               = [aDecoder decodeObjectForKey:@"name"];
    _menu_description   = [aDecoder decodeObjectForKey:@"menu_description"];
    _price              = [aDecoder decodeObjectForKey:@"price"];
    _submenus           = [aDecoder decodeObjectForKey:@"submenus"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_serverID forKey:@"serverID"];
    [aCoder encodeObject:_section forKey:@"section"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_menu_description forKey:@"menu_description"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_submenus forKey:@"submenus"];
}

@end
