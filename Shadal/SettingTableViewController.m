//
//  SettingTableViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 8/16/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "SettingTableViewController.h"

#import "Constants.h"
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
    CustomTitleView * titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][1];
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
-(IBAction)linkToYongon:(id)sender{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/kr/app/syadal-yeongeon-kaempeoseu/id787858927?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
    
}
- (IBAction)showEmail:(id)sender{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@"swchoi06@wafflestudio.com"]];
    [controller setSubject:@"없는 배달음식 추천하기"];
    [controller setMessageBody:@"ex) 미쳐버린 파닭은 왜 없나요ㅠㅠ" isHTML:NO];
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
            [self linkToYongon:self];
        }
    }
}
@end
