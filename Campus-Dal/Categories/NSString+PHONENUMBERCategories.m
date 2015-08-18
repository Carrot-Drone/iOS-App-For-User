//
//  NSString+PHONENUMBERCategories.m
//  
//
//  Created by Sukwon Choi on 8/18/15.
//
//

#import "NSString+PHONENUMBERCategories.h"

@implementation NSString(PHONENUMBERCategories)
+ (NSString *)phoneNumberFormattedString:(NSString *)phoneNumber{
    NSString * formattedString;
    
    NSString *pureString = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
    
    
    // return if null string
    if([pureString length] == 0) return @"";
    
    // If phone number doesn't start with '0', ex) 1544-0000
    if([pureString characterAtIndex:0] != '0'){
        if([pureString length] < 4){
            formattedString = pureString;
        }else{
            formattedString = [NSString stringWithFormat:@"%@-%@", [pureString substringToIndex:4], [pureString substringFromIndex:4]];
        }
        return formattedString;
    }
    
    // Else
    if([pureString length] < 2){
        return pureString;
    }else if([pureString length] == 2){
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@)", pureString];
        }else{
            formattedString = pureString;
        }
    }else if([pureString length] < 5){
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@) %@", [pureString substringToIndex:2], [pureString substringFromIndex:2]];
        }else{
            formattedString = [NSString stringWithFormat:@"(%@) %@", [pureString substringToIndex:3], [pureString substringFromIndex:3]];
        }
    }else if([pureString length] == 5){
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:2], [pureString substringWithRange:NSMakeRange(2, 3)], [pureString substringFromIndex:5]];
        }else{
            formattedString = [NSString stringWithFormat:@"(%@) %@", [pureString substringToIndex:3], [pureString substringFromIndex:3]];
        }
    }else if([pureString length] < 9){
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:2], [pureString substringWithRange:NSMakeRange(2, 3)], [pureString substringFromIndex:5]];
        }else{
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:3], [pureString substringWithRange:NSMakeRange(3, 3)], [pureString substringFromIndex:6]];
        }
    }else if([pureString length] == 9){
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:2], [pureString substringWithRange:NSMakeRange(2, 4)], [pureString substringFromIndex:6]];
        }else{
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:3], [pureString substringWithRange:NSMakeRange(3, 3)], [pureString substringFromIndex:6]];
        }
    }else{
        if([pureString characterAtIndex:1] == '2'){
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:2], [pureString substringWithRange:NSMakeRange(2, 4)], [pureString substringFromIndex:6]];
        }else{
            formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [pureString substringToIndex:3], [pureString substringWithRange:NSMakeRange(3, 4)], [pureString substringFromIndex:7]];
        }
    }
    
    return formattedString;
}
@end
