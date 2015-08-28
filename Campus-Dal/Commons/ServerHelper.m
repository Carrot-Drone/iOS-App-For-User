//
//  ServerHelper.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "ServerHelper.h"
#import "StaticHelper.h"
#import "Constants.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation ServerHelper{
    
}

// Sync
- (NSArray *)get_campuses_list_sync{
    if(![self isConnected]){
        return nil;
    }
    
    NSString * dataURL = [NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_CAMPUSES_LIST];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
    if(data != nil){
        NSError * error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        return json;
    }else{
        NSLog(@"Campuses data is null");
        return nil;
    }
}
- (NSArray *)get_restaurants_sync:(NSNumber *)campusID{
    if(![self isConnected]){
        return nil;
    }
    
    NSString * dataURL = [NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RESTAURANTS];
    dataURL = [dataURL stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return json;
}

- (NSDictionary *)get_recommended_restaurants_sync:(NSNumber *)campusID{
    if(![self isConnected]){
        return nil;
    }
    
    NSString * dataURL = [NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RECOMMENDED_RESTAURANTS];
    dataURL = [dataURL stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return json;
}

// Async
- (void)get_campuses_list{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_CAMPUSES_LIST];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableArray *returnArray   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         
         if(returnArray != nil || [returnArray count] != 0){
             NSArray * campuses_data = returnArray;
             NSMutableArray * campuses = [[NSMutableArray alloc] init];
             for(NSDictionary * campus_dic in campuses_data){
                 Campus * campus = [[Campus alloc] initWithDictionary:campus_dic];
                 [campuses addObject:campus];
             }
             [[StaticHelper staticHelper] saveCampuses:campuses];
         }

     }];
}
- (void)get_campus:(NSNumber *)campusID{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_CAMPUS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    NSMutableString * mutableUrlString = [NSMutableString stringWithString:urlString];
    
    NSURL *url = [NSURL URLWithString:mutableUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         NSLog(@"%@", [returnDict objectForKey:@"name_kor"]);
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_campus" object:self userInfo:returnDict];
     }];
}
- (void)get_restaurants:(NSNumber *)campusID{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RESTAURANTS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableArray *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                         [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableArray alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         NSMutableDictionary * json = [[NSMutableDictionary alloc] initWithObjectsAndKeys:returnDict, @"restaurants", response, @"response", nil];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_restaurants" object:self userInfo:json];
     }];
}
- (void)get_restaurants_list_in_category:(NSNumber *)campusID categoryID:(NSNumber *)categoryID{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RESTAURANTS_LIST_IN_CATEGORY];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":category_id" withString:[categoryID stringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];

    /* No parameters
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    */
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableArray *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableArray alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         NSMutableDictionary * json = [[NSMutableDictionary alloc] initWithObjectsAndKeys:returnDict, @"restaurants", response, @"response", nil];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_restaurants_list_in_category" object:self userInfo:json];
     }];
}
- (void)get_restaurant:(NSNumber *)restaurantID updatedAt:(NSString *)updatedAt{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RESTAURANT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":restaurant_id" withString:[restaurantID stringValue]];
    NSMutableString * mutableUrlString = [NSMutableString stringWithString:urlString];

    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"updated_at", updatedAt]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    
    [mutableUrlString appendString:@"?"];
    [mutableUrlString appendString:requestParams];
    
    NSURL *url = [NSURL URLWithString:mutableUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_restaurant" object:self userInfo:returnDict];
     }];
}
- (void)get_recommended_restaurants:(NSNumber *)campusID{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_RECOMMENDED_RESTAURANTS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":campus_id" withString:[campusID stringValue]];
    NSMutableString * mutableUrlString = [NSMutableString stringWithString:urlString];
    
    NSURL *url = [NSURL URLWithString:mutableUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
         [json setObject:response forKey:@"response"];
         [json setObject:returnDict forKey:@"recommendedRestaurants"];
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_recommended_restaurants" object:self userInfo:json];
     }];
    
}
- (void)set_user_preference:(NSNumber *)restaurantID preference:(NSNumber *)preference{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_USER_PREFERENCE];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":restaurant_id" withString:[restaurantID stringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"preference", [preference intValue]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_user_preference" object:self userInfo:returnDict];
     }];
}
- (void)set_call_log:(NSNumber *)campusID categoryID:(NSNumber *)categoryID restaurantID:(NSNumber *)restaurantID numberOfCalls:(NSNumber *)numberOfCalls hasRecentCall:(BOOL)hasRecentCall{
    
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_CALLLOG];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"campus_id", [campusID intValue]]];
    if(categoryID != nil) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"category_id", [categoryID intValue]]];
    }
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"restaurant_id", [restaurantID intValue]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"number_of_calls", [numberOfCalls intValue]]];
    if(hasRecentCall){
        [pairs addObject:[NSString stringWithFormat:@"%@=1", @"has_recent_call"]];
    }else{
        [pairs addObject:[NSString stringWithFormat:@"%@=0", @"has_recent_call"]];
    }
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_call_log" object:self userInfo:returnDict];
     }];
    
}
- (void)set_device:(NSNumber *)campusID deviceType:(NSString *)deviceType{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_DEVICE];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"campus_id", [campusID intValue]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"device_type", deviceType]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_device" object:self userInfo:returnDict];
     }];
    
}
- (void)set_campus_reservation:(NSString *)campusName phoneNumber:(NSString *)phoneNumber{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_CAMPUS_RESERVATION];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"campus_name", campusName]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"phone_number", phoneNumber]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_campus_reservation" object:self userInfo:returnDict];
     }];
    
}
- (void)set_restaurant_correction:(NSNumber *)restaurantID majorCorrection:(NSString *)majorCorrection details:(NSString *)details{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSString * urlString =[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_RESTAURANT_CORRECTION];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":restaurant_id" withString:[restaurantID stringValue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"major_correction", majorCorrection]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"details", details]];


    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_restaurant_correction" object:self userInfo:returnDict];
     }];
    
}
- (void)set_restaurant_suggestion:(NSNumber *)campusID name:(NSString *)name phoneNumber:(NSString *)phoneNumber officeHours:(NSString *)officeHours isSuggestedByRestaurant:(BOOL)isSuggestedByRestaurant images:(NSArray *)images{
    
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSMutableArray * imageData = [[NSMutableArray alloc] init];
    for(UIImage * image in images){
        NSData *png = UIImageJPEGRepresentation(image, 1.0);
        //NSString * data = [png base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //get the data into a string
        NSString* data = [NSString stringWithFormat:@"%@", png];
        //remove whitespace from the string
        data = [data stringByReplacingOccurrencesOfString:@" " withString:@""];
        //remove < and > from string
        data = [data substringWithRange:NSMakeRange(1, [data length]-2)];
        NSString * base64String = [[data dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];

        [imageData addObject:base64String];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_RESTAURANT_SUGGESTION]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%d", @"campus_id", [campusID intValue]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"name", name]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"phone_number", phoneNumber]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"office_hours", officeHours]];
    if(isSuggestedByRestaurant){
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"is_suggested_by_restaurant", @"true"]];
    }else{
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"is_suggested_by_restaurant", @"false"]];
    }
    for(NSString * image in imageData){
        [pairs addObject:[NSString stringWithFormat:@"files[]=%@", image]];
    }
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];

    
    NSMutableData * data = (NSMutableData *)[requestParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_restaurant_suggestion" object:self userInfo:returnDict];
     }];

    return;
}
- (void)set_user_request:(NSString *)emails details:(NSString *)details{
    // Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, SET_USER_REQUEST]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"uuid", [[StaticHelper staticHelper] uuid]]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"email", emails]];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", @"details", details]];
    
    NSString *requestParams = [pairs componentsJoinedByString:@"&"];
    [request setHTTPBody:[requestParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                       [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options: NSJSONReadingMutableContainers
                                                                        error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"set_user_request" object:self userInfo:returnDict];
     }];
}
- (void)get_minimum_app_version{// Check For Internet Connection
    if(![self isConnected]){
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_BASE_URL, GET_MINIMUM_VERSION]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    // Send Async Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody     = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSMutableDictionary *returnDict   = [NSJSONSerialization JSONObjectWithData:
                                              [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: &error];
         if(returnDict == nil){
             returnDict = [[NSMutableDictionary alloc] init];
         }
         if(response == nil){
             response = [[NSHTTPURLResponse alloc] init];
         }
         [returnDict setValue:response forKey:@"response"];
         
         // 노티피케이션 전송
         NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
         [myNotificationCenter postNotificationName:@"get_minimum_app_version" object:self userInfo:returnDict];
     }];
}



- (BOOL)isConnected{
    TMReachability *networkReachability = [TMReachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"Internet is not connected");
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"인터넷 연결을 확인해주세요" delegate:[ServerHelper class] cancelButtonTitle:@"확인" otherButtonTitles: nil];
        //[alertView show];
        
        return NO;
    } else {
        return YES;
    }
}


// GA Event Tracking
+ (void)sendGoogleAnalyticsEvent:(NSString *)category action:(NSString *)action label:(NSString *)label {

    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:ANALYTICS_ID];
    if([[StaticHelper staticHelper] campus] != nil){
        Campus * campus = [[StaticHelper staticHelper] campus];
        if(campus != nil && [campus serverID] != 0){
            [tracker set:[GAIFields customDimensionForIndex:1] value:[[[StaticHelper staticHelper] campus] nameKorShort]];
        }
    }
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
}

// GA Screen View
+ (void) sendGoogleAnalyticsScreen:(NSString *)screenName {
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:ANALYTICS_ID];
    if([[StaticHelper staticHelper] campus] != nil){
        Campus * campus = [[StaticHelper staticHelper] campus];
        if(campus != nil && [campus serverID] != 0){
            [tracker set:[GAIFields customDimensionForIndex:1] value:[[[StaticHelper staticHelper] campus] nameKorShort]];
        }
    }
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


@end
