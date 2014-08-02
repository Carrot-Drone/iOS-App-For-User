//
//  Server.m
//  Shadal
//
//  Created by Sukwon Choi on 6/25/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "Server.h"
#import "Constants.h"
#import "Restaurant.h"

@implementation Server{
}

static Restaurant * _restaurant;

static NSMutableData * responseData;

+(void)updateRestaurant:(Restaurant *)restaurant{
    _restaurant = restaurant;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_UPDATE]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        [theRequest setHTTPMethod:@"POST"];
        
        NSString * params = [NSString stringWithFormat:@"restaurant_id=%d&phone_number=%@&campus=%@&updated_at=%@", restaurant.server_id, restaurant.phoneNumber, CAMPUS, restaurant.updated_at];
        
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
        
        responseData = [[NSMutableData alloc] init];
        [connection start];
    });
}

+ (void)checkForNewRestaurant:(NSString *)category{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_RES_IN_CATEGORY]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        [theRequest setHTTPMethod:@"POST"];
        
        NSString * params = [NSString stringWithFormat:@"category=%@&campus=%@", category, CAMPUS];
        
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
        
        responseData = [[NSMutableData alloc] init];
        [connection start];
    });
}
+ (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Did receiveResponse");
}
+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
+ (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Failed to update restaurant");
    [connection start];
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Did finish loading");
    NSString * url = [[[connection currentRequest] URL] absoluteString];
    if([url isEqualToString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_RES_IN_CATEGORY]]){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        // 노티피케이션 전송
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter postNotificationName:@"checkForResInCategory" object:self userInfo:json];
    }else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_UPDATE]]){
        if([responseData length]==0){
            
        }else{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            [_restaurant setRestaurantFromDictionary:json];
            
            NSLog(@"%@", json);
            
            // 노티피케이션 전송. RestaurantViewController 에서 이 노티피케이션을 받아서 updateUI 함수를 실행. 뷰를 업데이트
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            
            [myNotificationCenter postNotificationName:@"updateUI" object:self userInfo:nil];
        }
    }
}
@end
