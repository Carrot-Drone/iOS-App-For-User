//
//  Constants.h
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#ifndef Campus_Dal_Constants_h
#define Campus_Dal_Constants_h

// Server
#define IS_TEST_APK                         YES
#if(IS_TEST_APK == YES)
    #define WEB_BASE_URL                    @"http://shadal.kr:3000/"
#else
    #define WEB_BASE_URL                    @"http://shadal.kr/"
#endif

#define GET_CAMPUSES_LIST                   @"campuses"
#define GET_RESTAURANTS                     @"campus/:campus_id/restaurants"
#define GET_RESTAURANTS_LIST_IN_CATEGORY    @"campus/:campus_id/category/:category_id/restaurants"
#define GET_RESTAURANT                      @"restaurant/:restaurant_id"
#define SET_USER_PREFERENCE                 @"restaurant/:restaurant_id/preference"
#define SET_CALLLOG                         @"call_logs"
#define SET_DEVICE                          @"device"
#define SET_CAMPUS_RESERVATION              @"campus_reservation"
#define SET_RESTAURANT_CORRECTION           @"restaurant/:restaurant_id/restaurant_correction"
#define SET_RESTAURANT_SUGGESTION           @"restaurant_suggestion"
#define SET_USER_REQUEST                    @"user_request"
#define GET_MINIMUM_VERSION                 @"minimum_app_version"


#endif
