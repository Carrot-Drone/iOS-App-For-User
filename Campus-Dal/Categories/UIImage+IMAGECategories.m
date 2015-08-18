//
//  UIImage+IMAGECategories.m
//  UIKitCategories
//
//  Created by SukWon Choi on 13. 8. 27..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "UIImage+IMAGECategories.h"

@implementation UIImage(IMAGECategories)
+ (UIImage *)image1x1WithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithUIView:(UIView *)view
{
  CGSize screenShotSize = view.bounds.size;
  UIImage *img;  
  UIGraphicsBeginImageContext(screenShotSize);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [view drawLayer:view.layer inContext:ctx];
  img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
    
  return img;
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
