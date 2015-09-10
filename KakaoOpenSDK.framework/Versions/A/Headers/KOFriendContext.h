//
//  KOFriendContext.h
//  kakao-open-sdk-ios
//
//  Created by Thomas on 2015. 7. 29..
//  Copyright (c) 2015년 Kakao. All rights reserved.
//

#import "KOBaseContext.h"

typedef NS_ENUM(NSInteger, KOFriendServiceType) {
    KOFriendServiceTypeTalk = 0,
    KOFriendServiceTypeStory,
    KOFriendServiceTypeTalkAndStory
};

typedef NS_ENUM(NSInteger, KOFriendFilterType) {
    KOFriendFilterTypeAll = 0,
    KOFriendFilterTypeRegistered,
    KOFriendFilterTypeInvitableNotRegistered
};

typedef NS_ENUM(NSInteger, KOFriendOrderType) {
    KOFriendOrderTypeNickName = 0,
    KOFriendOrderTypeRecentChatting,
    KOFriendOrderTypeTalkUserCreatedAt,
    KOFriendOrderTypeAge,
    KOFriendOrderTypeAffinity
};

extern NSString* convertFriendServiceTypeString(KOFriendServiceType type);
extern NSString* convertFriendFilterTypeString(KOFriendFilterType type);
extern NSString* convertFriendOrderTypeString(KOFriendOrderType type);

@interface KOFriendContext : KOBaseContext

@property (nonatomic, readonly) KOFriendServiceType serviceType;
@property (nonatomic, readonly) KOFriendFilterType filterType;
@property (nonatomic, readonly) BOOL secureResource;
@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) KOFriendOrderType orderType;
@property (nonatomic, readonly) KOFriendOrdering ordering;

+ (instancetype)contextWithServiceType:(KOFriendServiceType)serviceType
                            filterType:(KOFriendFilterType)filterType;

+ (instancetype)contextWithServiceType:(KOFriendServiceType)serviceType
                            filterType:(KOFriendFilterType)filterType
                        secureResource:(BOOL)secureResource
                                 limit:(NSInteger)limit
                             orderType:(KOFriendOrderType)orderType
                              ordering:(KOFriendOrdering)ordering;

- (id)initWithServiceType:(KOFriendServiceType)serviceType
               filterType:(KOFriendFilterType)filterType
           secureResource:(BOOL)secureResource
                    limit:(NSInteger)limit
                orderType:(KOFriendOrderType)orderType
                 ordering:(KOFriendOrdering)ordering;

@end
