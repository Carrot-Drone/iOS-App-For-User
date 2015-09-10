//
//  Constants.h
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#ifndef Campus_Dal_Constants_h
#define Campus_Dal_Constants_h

// System
#define DEVICE_TYPE                         @"ios"

// Font
#define MAIN_FONT                   @"HelveticaNeue-Light"
#define MAIN_FONT_BOLD              @"HelveticaNeue-Bold"
#define NANUMGOTHIC                 @"NanumGothicOTF"
#define NANUMGOTHIC_BOLD            @"NanumGothicOTFBold"

// Color
#define MAIN_COLOR                  (UIColor *)[UIColor colorWithRed:251/255.0 green:112/255.0 blue:16/255.0 alpha:1.0]
#define TAB_BAR_BG_COLOR            (UIColor *)[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]
#define SECTION_HEADER_BG_COLOR     (UIColor *)[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]
#define ADD_FLYER_BG_COLOR          (UIColor *)[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]
#define PHONE_CALL_BG_COLOR         (UIColor *)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1]
#define WHITE_BG_COLOR              (UIColor *)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define LIGHT_BG_COLOR              (UIColor *)[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]
#define LIKE_GAUGE_COLOR            (UIColor *)[UIColor colorWithRed:76/255.0 green:217/255.0 blue:192/255.0 alpha:1.0]
#define TEXT_VIEW_BG_COLOR          (UIColor *)[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]
#define TEXT_VIEW_BORDER_COLOR      (UIColor *)[UIColor colorWithRed:266/255.0 green:266/255.0 blue:266/255.0 alpha:1.0]
#define DARK_BG_COLOR               (UIColor *)[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0];

#define DIVIDER_COLOR1              (UIColor *)[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]
#define DIVIDER_COLOR2              (UIColor *)[UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0]
#define DIVIDER_COLOR3              (UIColor *)[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]

#define POINT_COLOR         (UIColor *)[UIColor colorWithRed:255/255.0 green:9/255.0 blue:9/255.0 alpha:1.0]
#define DARK_GRAY           (UIColor *)[UIColor darkGrayColor]
#define LiGHT_GRAY          (UIColor *)[UIColor lightGrayColor]

#define DARK_BACKGROUND     (UIColor *)[UIColor darkGrayColor]
#define LIGHT_BACKGORUND    (UIColor *)[UIColor lightGrayColor]

#define BUTTON_BACKGROUND   (UIColor *)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.12]


// Server
#define WEB_BASE_URL                    @"http://shadal.kr/"
//#define WEB_BASE_URL                    @"http://shadal.kr:3000/"

#define GET_CAMPUS                          @"campus/:campus_id"
#define GET_CAMPUSES_LIST                   @"campuses"
#define GET_RESTAURANTS                     @"campus/:campus_id/restaurants"
#define GET_RESTAURANTS_LIST_IN_CATEGORY    @"campus/:campus_id/category/:category_id/restaurants"
#define GET_RESTAURANT                      @"restaurant/:restaurant_id"
#define GET_RECOMMENDED_RESTAURANTS         @"campus/:campus_id/recommended_restaurants"
#define SET_USER_PREFERENCE                 @"restaurant/:restaurant_id/preference"
#define SET_CALLLOG                         @"call_logs"
#define SET_DEVICE                          @"device"
#define SET_CAMPUS_RESERVATION              @"campus_reservation"
#define SET_RESTAURANT_CORRECTION           @"restaurant/:restaurant_id/restaurant_correction"
#define SET_RESTAURANT_SUGGESTION           @"restaurant_suggestion"
#define SET_USER_REQUEST                    @"user_request"
#define GET_MINIMUM_VERSION                 @"minimum_app_version"

// Homepage
#define HOME_PAGE                           @"http://www.campusdal.co.kr/"

// GA
#define ANALYTICS_ID                @"UA-61963094-1"

// Flurry
#define FLURRY_API_KEY              @"9WVZS5X9X9B53CZ562FN"

#endif
