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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
- (IBAction)showEmail:(id)sender{
    if(![MFMailComposeViewController canSendMail] ) {
        NSLog(@"Cannot send mail\n%s", __PRETTY_FUNCTION__) ;
        return ;
    }

    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [[controller navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];

    [controller setToRecipients:[NSArray arrayWithObject:[[Static campusInfo] objectForKey:@"email"]]];
    [controller setSubject:[NSString stringWithFormat:@"[%@][iOS][맛집제보]", [[Static campusInfo] objectForKey:@"name_kor_short"]]];
    [controller setMessageBody:@"" isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:NULL];
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = HIGHLIGHT_COLOR;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        if(indexPath.row==0){
            [self linkToFacebook:self];
        }else if(indexPath.row==1){
            [self showEmail:self];
        }
    }
    if(indexPath.section==2){
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
