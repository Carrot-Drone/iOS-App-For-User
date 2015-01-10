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
#import "Reachability.h"

@implementation Server{
}

static Restaurant * _restaurant;
static NSMutableData * responseData;

+(BOOL)isConnected{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}

+(void)updateRestaurant:(Restaurant *)restaurant{
    if(![Server isConnected]){
        return;
    }
    _restaurant = restaurant;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_UPDATE]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        [theRequest setHTTPMethod:@"POST"];
        
        NSString * params = [NSString stringWithFormat:@"restaurant_id=%d&phone_number=%@&campus=%@&updated_at=%@", restaurant.server_id, restaurant.phoneNumber, s_campus, restaurant.updated_at];
        
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
    if(![Server isConnected]){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_RES_IN_CATEGORY]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        [theRequest setHTTPMethod:@"POST"];
        
        NSString * params = [NSString stringWithFormat:@"category=%@&campus=%@", category, s_campus];
        
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
        
        responseData = [[NSMutableData alloc] init];
        [connection start];
    });
}

+ (void)flyersInRestaurant:(Restaurant *)restaurant{
    if(![Server isConnected]){
        return;
    }
    _restaurant = restaurant;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, FLYERS_FOR_RES]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        [theRequest setHTTPMethod:@"POST"];
        
        NSString * params = [NSString stringWithFormat:@"restaurant_id=%d&phone_number=%@&campus=%@", restaurant.server_id, restaurant.phoneNumber, s_campus];
        
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
        
        if(json == NULL){
            NSLog(@"Received json is NULL");
            return;
        }
        // 노티피케이션 전송
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter postNotificationName:@"checkForResInCategory" object:self userInfo:json];
        
    }else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CHECK_FOR_UPDATE]]){
        if([responseData length]==0){
            
        }else{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if(json != NULL)
                [_restaurant setRestaurantFromDictionary:json];
        }
        
        // 노티피케이션 전송. RestaurantViewController 에서 이 노티피케이션을 받아서 updateUI 함수를 실행. 뷰를 업데이트
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        
        [myNotificationCenter postNotificationName:@"updateUI" object:self userInfo:nil];
    }else{
    }
}

+(NSArray *)allRestaurants{
    NSString * dataURL = [NSString stringWithFormat:@"%@%@?campus=%@", WEB_BASE_URL, ALL_DATA, s_campus];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return json;
    
}
@end
