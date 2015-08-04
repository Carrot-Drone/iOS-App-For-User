//
//  Category_.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber * serverID;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSMutableArray * restaurants;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
