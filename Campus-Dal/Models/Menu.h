//
//  Menu.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber * serverID;
@property (nonatomic, strong) NSString * section;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * menu_description;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSMutableArray * submenus;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
