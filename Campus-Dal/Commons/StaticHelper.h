//
//  StaticHelper.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>
#import <SSKeyChain/SSKeyChain.h>
@interface StaticHelper : NSObject


+ (StaticHelper *)staticHelper;
// All Data in campus
- (NSMutableArray *)allData;
- (void)saveAllData:(NSMutableArray *)allData;

// List of campuses
- (NSMutableArray *)campuses;
- (void)saveCampuses:(NSMutableArray *)campuses;

// Current Campus
- (NSMutableDictionary *)campus;
- (void)saveCampus:(NSMutableDictionary *)campus;

// User Info
- (NSMutableDictionary *)user;
- (void)saveUser:(NSMutableDictionary *)user;

// UUID
- (NSString *)uuid;


@end
