//
//  Constants.h
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 8..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#ifndef Shadal_Constants_h
#define Shadal_Constants_h

#define SEOUL_FONT_L(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"SeN-CL") size:(CGFloat)(_size_)])
#define SEOUL_FONT_EB(_size_) ((UIFont *)[UIFont fontWithName:(NSString *)(@"SeN-CEB") size:(CGFloat)(_size_)])


//#define WEB_BASE_URL                @"http://localhost:3000"
#define WEB_BASE_URL                @"http://services.snu.ac.kr:3111"
#define NEW_CALL                    @"/new_call"
#define CHECK_FOR_UPDATE            @"/checkForUpdate"
#define CHECK_FOR_RES_IN_CATEGORY   @"/checkForResInCategory"

#define CAMPUS @"Gwanak"
//#define WEB_BASE_URL2 @"http://services.snu.ac.kr:3111/new_menu"

#endif