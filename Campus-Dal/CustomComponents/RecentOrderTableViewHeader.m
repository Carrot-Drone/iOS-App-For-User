//
//  CustomTableViewHeader.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RecentOrderTableViewHeader.h"

#import "Constants.h"
#import "UIColor+COLORCategories.h"

@implementation RecentOrderTableViewHeader

@synthesize callLogsLabel=_callLogsLabel;
@synthesize restaurantNameLabel=_restaurantNameLabel;
@synthesize recentOrderLabel=_recentOrderLabel;

@synthesize sortByCallLogsButton=_sortByCallLogsButton;
@synthesize sortByRecentOrderButton=_sortByRecentOrderButton;
@synthesize sortByNameButton=_sortByNameButton;
@synthesize sortByCallLogsImageView=_sortByCallLogsImageView;
@synthesize sortByNameImageView=_sortByNameImageView;
@synthesize sortByRecentOrderImageView=_sortByRecentOrderImageView;

-(void)awakeFromNib{
    self.backgroundColor = SECTION_HEADER_BG_COLOR;
    
    [_callLogsLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_callLogsLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_restaurantNameLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_restaurantNameLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    [_recentOrderLabel setFont:[UIFont fontWithName:MAIN_FONT size:13]];
    [_recentOrderLabel setTextColor:[UIColor colorWithRGBHex:0x727272]];
    
    [_sortByCallLogsImageView setImage:[UIImage imageNamed:@"Icon_list_recent_arrow"]];
    [_sortByNameImageView setImage:[UIImage imageNamed:@"Icon_list_recent_arrow"]];
    [_sortByRecentOrderImageView setImage:[UIImage imageNamed:@"Icon_list_recent_arrow"]];
    
    [_sortByCallLogsImageView setBackgroundColor:[UIColor clearColor]];
    [_sortByNameImageView setBackgroundColor:[UIColor clearColor]];
    [_sortByRecentOrderImageView setBackgroundColor:[UIColor clearColor]];
}

@end
