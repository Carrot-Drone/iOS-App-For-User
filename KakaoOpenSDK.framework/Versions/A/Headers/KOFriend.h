//
//  KOFriend.h
//  kakao-open-sdk-ios
//
//  Created by Thomas on 2015. 7. 29..
//  Copyright (c) 2015년 Kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KOOSPropertyType) {
    KOOSPropertyTypeUnknown = 0,
    KOOSPropertyTypeIOS,
    KOOSPropertyTypeAndroid
};

typedef NS_ENUM(NSInteger, KORelationValue) {
    KORelationValueFriend = 0,
    KORelationValueNotFriend,
    KORelationValueNotAvailable
};

@interface KOFriend : NSObject

@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSNumber *serviceUserID;
@property (nonatomic, readonly) BOOL appRegistered;

@property (nonatomic, readonly) NSString *nickName;
@property (nonatomic, readonly) NSString *thumbnailURL;

@property (nonatomic, readonly) KOOSPropertyType talkOS;
@property (nonatomic, readonly) BOOL allowedTalkMessaging;

@property (nonatomic, readonly) KORelationValue talkRelation;
@property (nonatomic, readonly) KORelationValue storyRelation;

+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary;

@end