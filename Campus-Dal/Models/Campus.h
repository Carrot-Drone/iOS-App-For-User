//
//  Campus.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@interface Campus : NSObject <NSCoding>
@property (nonatomic, strong) NSNumber * serverID;
@property (nonatomic, strong) NSString * nameKor;
@property (nonatomic, strong) NSString * nameKorShort;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * administrator;
@property (nonatomic, strong) NSMutableArray * categories;

-(id)initWithDictionary:(NSDictionary *)dic;

@end