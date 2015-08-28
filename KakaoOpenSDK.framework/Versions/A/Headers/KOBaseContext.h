//
//  KOBaseContext.h
//  kakao-open-sdk-ios
//
//  Created by Thomas on 2015. 7. 29..
//  Copyright (c) 2015년 Kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KOFriendOrdering) {
    KOFriendOrderingAscending = 0,
    KOFriendOrderingDescending
};

extern NSString* convertFriendOrderingString(KOFriendOrdering type);

@interface KOBaseContext : NSObject

@property (nonatomic, readonly) NSNumber *totalCount;
@property (nonatomic, readonly) NSString *beforeURL;
@property (nonatomic, readonly) NSString *afterURL;
@property (nonatomic, readonly) NSString *contextID;
@property (nonatomic, readonly) BOOL hasMoreItems;

- (void)parseDictionary:(NSDictionary *)dictionary;

@end
