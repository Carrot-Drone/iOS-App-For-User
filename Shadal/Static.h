//
//  Static.h
//  Shadal
//
//  Created by Sukwon Choi on 2/10/15.
//  Copyright (c) 2015 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Static : NSObject

+ (NSString *)campus;
+ (NSDictionary *)campusInfo;
+ (void)setCampusInfo:(NSDictionary *)campusInfo;

+ (NSMutableDictionary *)allData;
+ (void)setAllData:(NSMutableDictionary *)dic;

+ (void)saveData;
+ (void)loadData;

@end
