//
//  Server.m
//  Shadal
//
//  Created by Sukwon Choi on 6/25/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "Server.h"
#import "Constants.h"
#import "Static.h"
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
        NSString * params = [NSString stringWithFormat:@"restaurant_id=%d&phone_number=%@&campus=%@&updated_at=%@", restaurant.server_id, restaurant.phoneNumber, [Static campus], restaurant.updated_at];
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        responseData = [[NSMutableData alloc] init];

        [connection start];
        
        /*
        NSString * url_address = [NSString stringWithFormat:@"%@%@?restaurant_id=%d&phone_number=%@&campus=%@&updated_at=%@", WEB_BASE_URL, CHECK_FOR_UPDATE, restaurant.server_id, restaurant.phoneNumber, [Static campus], restaurant.updated_at];
        url_address = [url_address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:url_address];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
        
        responseData = [[NSMutableData alloc] init];
        [connection start];
        
         */
        
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
        NSString * params = [NSString stringWithFormat:@"category=%@&campus=%@", category, [Static campus]];
        [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
//        NSLog(@"%@", [NSString stringWithFormat:@"%@%@?category=%@&campus=%@", WEB_BASE_URL, CHECK_FOR_RES_IN_CATEGORY, category, [Static campus]]);
        responseData = [[NSMutableData alloc] init];
        [connection start];
        
    });
}

+ (void)campuses{
    if(![Server isConnected]){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CAMPUSES]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
        NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        
        NSLog(@"Connection Start");
        
        responseData = [[NSMutableData alloc] init];
        [connection start];
    });
}

+ (void)sendCallLog:(NSString *)params{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, NEW_CALL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    [connection start];
}

+ (void)updateUUID{
    if(![Server isConnected]){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?campus=%@&uuid=%@&device=ios", WEB_BASE_URL, UPDATE_UUID, [Static campus], [Static UUID]]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
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
    NSLog(@"Failed to update restaurant %@", [error description]);
    NSLog(@"%@", [[[connection currentRequest] URL]absoluteString]);
    [connection start];
}

+ (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Did finish loading");
    NSString * url = [[[connection currentRequest] URL] absoluteString];
    NSLog(@"%@", url);
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
    }else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, CAMPUSES]]){
        if([responseData length]==0){
            
        }else{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if([json count]==0){
                [connection start];
            }else{
                // 노티피케이션 전송
                NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
                [myNotificationCenter postNotificationName:@"campuses" object:self userInfo:json];
            }
        }
    }else if([url isEqualToString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, NEW_CALL]]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSNumber numberWithBool:YES] forKey:@"callBool"];
        [prefs setObject:nil forKey:@"params"];
    }
}

+(NSArray *)allRestaurants{
    NSString * dataURL = [NSString stringWithFormat:@"%@%@?campus=%@", WEB_BASE_URL, ALL_DATA, [Static campus]];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return json;
}
@end
