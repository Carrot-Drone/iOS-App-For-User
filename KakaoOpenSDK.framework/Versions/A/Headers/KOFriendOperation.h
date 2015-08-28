//
//  KOFriendOperation.h
//  kakao-open-sdk-ios
//
//  Created by Thomas on 2015. 7. 29..
//  Copyright (c) 2015년 Kakao. All rights reserved.
//

#import "KOBaseContext.h"

typedef NS_ENUM(NSInteger, KOFriendOperationType) {
    KOFriendOperationTypeIntersection = 0,
    KOFriendOperationTypeUnion,
    KOFriendOperationTypeSubtraction
};

extern NSString* convertriendOperationTypeString(KOFriendOperationType type);

@class KOFriendContext;

@interface KOFriendOperation : KOBaseContext

@property (nonatomic, readonly) KOFriendContext *leftContext;
@property (nonatomic, readonly) KOFriendContext *rightContext;
@property (nonatomic, readonly) KOFriendOperationType operationType;
@property (nonatomic, readonly) BOOL secureResource;
@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) KOFriendOrdering ordering;

+ (instancetype)operationWithLeftContext:(KOFriendContext *)leftContext
                            rightContext:(KOFriendContext *)rightContext
                           operationType:(KOFriendOperationType)operationType;

+ (instancetype)operationWithLeftContext:(KOFriendContext *)leftContext
                            rightContext:(KOFriendContext *)rightContext
                           operationType:(KOFriendOperationType)operationType
                          secureResource:(BOOL)secureResource
                                   limit:(NSInteger)limit
                                ordering:(KOFriendOrdering)ordering;

- (id)initWithLeftContext:(KOFriendContext *)leftContext
             rightContext:(KOFriendContext *)rightContext
            operationType:(KOFriendOperationType)operationType
           secureResource:(BOOL)secureResource
                    limit:(NSInteger)limit
                 ordering:(KOFriendOrdering)ordering;

@end
