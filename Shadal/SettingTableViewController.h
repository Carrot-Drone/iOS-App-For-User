//
//  SettingTableViewController.h
//  Shadal
//
//  Created by Sukwon Choi on 8/16/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingTableViewController : UIViewController <MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

-(IBAction)linkToFacebook:(id)sender;
-(IBAction)showEmail:(id)sender option:(BOOL)flag;
-(IBAction)talkPartyBannerClicked:(id)sender;

@end
