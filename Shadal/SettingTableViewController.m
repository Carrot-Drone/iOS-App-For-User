//
//  SettingTableViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 8/16/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SelectCampusViewController.h"

#import "Constants.h"
#import "Static.h"
#import "CustomTitleView.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    
    self.navigationItem.title = @"더보기";
    
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    
    // init titleView
    CustomTitleView * titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][2];
    titleView.categoryImageView.image = [UIImage imageNamed:@"BotIconMore"];
    titleView.categoryLabel.text = @"더보기";
    self.navigationItem.titleView = titleView;

}
-(void)viewWillAppear:(BOOL)animated{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}
-(IBAction)linkToFacebook:(id)sender{
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"https://facebook.com/snushadal"]];
}
// if flag is true, send mail to individual's campus email
// else if flag is false, send mail to campusdal email
- (IBAction)showEmail:(id)sender option:(BOOL)flag{
    if(![MFMailComposeViewController canSendMail] ) {
        NSLog(@"Cannot send mail\n%s", __PRETTY_FUNCTION__) ;
        [[[UIAlertView alloc] initWithTitle:nil message:@"등록된 메일 계정이 없습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
        return ;
    }

    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [[controller navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];

    if(flag){
        [controller setToRecipients:[NSArray arrayWithObject:[[Static campusInfo] objectForKey:@"email"]]];
        [controller setSubject:[NSString stringWithFormat:@"[%@][iOS][맛집제보]", [[Static campusInfo] objectForKey:@"name_kor_short"]]];
    }else{
        [controller setToRecipients:[NSArray arrayWithObject:@"campusdal@gmail.com"]];
        [controller setSubject:@"[캠달팀에 제보하기]"];
    }
    
    [controller setMessageBody:@"" isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:NULL];
}
-(IBAction)talkPartyBannerClicked:(id)sender{
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: TALK_PARTY_BANNER]];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Canceled");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail Failed");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0) return @"참여하기";
    else if(section == 1) return @"다른 캠퍼스 선택하기";
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            [cell.textLabel setText:@"페이스북"];
        }else if(indexPath.row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            [cell.textLabel setText:@"맛집 제보하기"];
        }else if(indexPath.row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            [cell.textLabel setText:@"캠달팀에 문의하기"];
        }
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell.textLabel setText:@"캠퍼스 바꾸기"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = HIGHLIGHT_COLOR;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            [self linkToFacebook:self];
        }else if(indexPath.row==1){
            [self showEmail:self option:YES];
        }else if(indexPath.row==2){
            [self showEmail:self option:NO];
        }
    }
    if(indexPath.section==1){
        if(indexPath.row==0){
            
            // Init all navigation controller to reset res data
            for(UIViewController *viewController in self.tabBarController.viewControllers)
            {
                if([viewController isKindOfClass:[UINavigationController class]])
                    [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            }
            
            // Save Curren Data
            [Static saveData];
            
            // Person selectCampus VC
            [self performSegueWithIdentifier:@"selectCampus" sender:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"selectCampus"]){
        SelectCampusViewController * vc =  segue.destinationViewController;
        vc.tabBarController = self.tabBarController;
    }
}
@end
