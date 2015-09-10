//
//  NSDictionary+SAFEACCESSCategories.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary(SAFEACCESSCategories)
- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
@end
