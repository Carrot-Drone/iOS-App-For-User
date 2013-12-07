//
//  UIImage+UIImage_Customized.h
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 7..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Customized)

+ (UIImage *)imageNamed_advanced:(NSString *)name;
+ (UIImage *)imageNamed_advanced:(NSString *)name option:(int)index;

@end
