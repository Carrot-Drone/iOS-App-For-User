//
//  Restaurant.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSMutableArray * menu;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * categories;
@property (nonatomic) double openingHours;
@property (nonatomic) double closingHours;

- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber;
- (NSString *)stringWithOpenAndClosingHours;
@end
