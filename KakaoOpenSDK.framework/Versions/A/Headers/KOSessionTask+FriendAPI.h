//
//  KOSessionTask+FriendAPI.h
//  kakao-open-sdk-ios
//
//  Created by Thomas on 2015. 7. 29..
//  Copyright (c) 2015년 Kakao. All rights reserved.
//

#import "KOSessionTask.h"

@class KOFriend, KOFriendContext, KOFriendOperation;

typedef void(^KOSessionFriendsTaskCompletionHandler)(NSArray *friends, NSError *error);

@interface KOSessionTask (FriendAPI)

+ (instancetype)friendsWithContext:(KOFriendContext *)context
                 completionHandler:(KOSessionFriendsTaskCompletionHandler)completionHandler;

+ (instancetype)friendsWithOperation:(KOFriendOperation *)operation
                   completionHandler:(KOSessionFriendsTaskCompletionHandler)completionHandler;

@end
