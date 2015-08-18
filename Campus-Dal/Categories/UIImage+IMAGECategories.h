//
//  UIImage+IMAGECategories.h
//  UIKitCategories
//
//  Created by SukWon Choi on 13. 8. 27..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(IMAGECategories)
+ (UIImage *)image1x1WithColor:(UIColor *)color;
+ (UIImage *)imageWithUIView:(UIView *)view;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
