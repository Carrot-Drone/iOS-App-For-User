//
//  AppDelegate.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <LibXL/LibXL.h>
#import "Restaurant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableDictionary * allData;

//@property (nonatomic) BookHandle book;

@end
