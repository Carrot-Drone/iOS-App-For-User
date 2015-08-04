//
//  UIImage+UIImage_Customized.m
//  Shadal
//
//  Created by Sukwon Choi on 2013. 12. 7..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "UIImage+UIImage_Customized.h"

@implementation UIImage (UIImage_Customized)

+ (UIImage *)imageNamed_advanced:(NSString *)name{
    UIImage * tmpImage;
    
    tmpImage = [self imageNamed:name];
    if(tmpImage != nil) return tmpImage;
    
    tmpImage = [self imageNamed:[NSString stringWithFormat:@"%@.jpg", name]];
    if(tmpImage != nil) return tmpImage;
    
    tmpImage = [self imageNamed:[NSString stringWithFormat:@"%@.gif", name]];
    if(tmpImage != nil) return tmpImage;
    
    return nil;
}

+ (UIImage *)imageNamed_advanced:(NSString *)name option:(int)index{
    UIImage * tmpImage;
    tmpImage = [self imageNamed_advanced:[NSString stringWithFormat:@"%@_%d", name, index]];
    return tmpImage;
}
+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

@end
