//
//  ServerHelper.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "ServerHelper.h"

@implementation ServerHelper

- (NSURLConnection *)get_campuses_list:(BOOL)all{
    if(![self isConnected]){
        return nil;
    }
    return nil;
}
- (NSURLConnection *)get_restaurants:(NSNumber *)campusID{
    if(![self isConnected]){
        return nil;
    }
    return nil;
}
- (NSURLConnection *)get_restaurants_list_in_category:(NSNumber *)campusID categoryID:(NSNumber *)categoryID{
    if(![self isConnected]){
        return nil;
    }
    return nil;
}
- (NSURLConnection *)get_restaurant:(NSNumber *)restaurantID updatedAt:(NSString *)updatedAt uuid:(NSString *)uuid{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_user_preference:(NSNumber *)restaurantID preference:(NSNumber *)preference uuid:(NSString *)uuid{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_call_log:(NSNumber *)campusID categoryID:(NSNumber *)categoryID restaurantID:(NSNumber *)restaurantID numberOfCalls:(NSNumber *)numberOfCalls uuid:(NSString *)uuid{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_device:(NSNumber *)campusID deviceType:(NSString *)deviceType uuid:(NSString *)uuid{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_campus_reservation:(NSString *)campusName phoneNumber:(NSString *)phoneNumber{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_restaurant_correction:(NSNumber *)restaurantID majorCorrection:(NSString *)majorCorrection details:(NSString *)details{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_restaurant_suggestion:(NSNumber *)campusID name:(NSString *)name phoneNumber:(NSString *)phoneNumber officeHours:(NSString *)officeHours isSuggestedByRestaurant:(BOOL)isSuggestedByRestaurant images:(NSArray *)images{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)set_user_request:(NSString *)emails details:(NSString *)details uuid:(NSString *)uuid{
    if(![self isConnected]){
        return nil;
    }
    return nil;
    
}
- (NSURLConnection *)get_minimum_app_version{
    if(![self isConnected]){
        return nil;
    }
    return nil;
}



- (BOOL)isConnected{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"인터넷 연결을 확인해주세요" delegate:[ServerHelper class] cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"There IS NO internet connection");
        
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}

@end
