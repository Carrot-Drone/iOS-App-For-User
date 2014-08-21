//
//  Constants.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#ifndef Shadal_Constants_h
#define Shadal_Constants_h


// #define Design component
#define SEOUL_FONT_L(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"08SeoulNamsanL") size:(CGFloat)(_size_)])
#define SEOUL_FONT_EB(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"SeoulNamsanEB") size:(CGFloat)(_size_)])
#define SEOUL_FONT_L_TAB(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"SeN-CL") size:(CGFloat)(_size_)])
#define SEOUL_FONT_EB_TAB(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"SeN-CEB") size:(CGFloat)(_size_)])


// color
//#define MAIN_COLOR (UIColor *)[UIColor colorWithRed:252/255.0 green:73/255.0 blue:13/255.0 alpha:1.0]
#define MAIN_COLOR (UIColor *)[UIColor colorWithRed:242/255.0 green:53/255.0 blue:0/255.0 alpha:1.0]
#define SUB_COLOR (UIColor *)[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]

#define BAR_TINT_COLOR (UIColor *)[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]

#define BACKGROUND_COLOR (UIColor *)[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define HIGHLIGHT_COLOR (UIColor *)[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0]

//#define WEB_BASE_URL                @"http://localhost:3000"
#define WEB_BASE_URL                @"http://www.shadal.kr"
#define NEW_CALL                    @"/new_call"
#define CHECK_FOR_UPDATE            @"/checkForUpdate"
#define CHECK_FOR_RES_IN_CATEGORY   @"/checkForResInCategory"
#define FLYERS_FOR_RES              @"/flyersForRes"
#define ALL_DATA                   [NSString stringWithFormat:@"/campus/%@.json", CAMPUS]

#define CAMPUS @"Gwanak"
//#define WEB_BASE_URL2 @"http://services.snu.ac.kr:3111/new_menu"

#endif