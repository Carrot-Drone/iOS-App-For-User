//
//  MasterViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "CustomTitleView.h"

#import "Restaurant.h"
#import "CategoryCell.h"
#import "AppDelegate.h"


@interface MasterViewController () {
    NSMutableArray * categories;
    NSDictionary * allData;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // reset default tint color
    self.navigationController.navigationBar.tintColor = nil;

    // init data
    allData = [(AppDelegate *)[[UIApplication sharedApplication] delegate] allData];
    categories = [[NSMutableArray alloc] init];
    
    [categories addObject:@"치킨"];
    [categories addObject:@"피자"];
    [categories addObject:@"중국집"];
    [categories addObject:@"한식/분식"];
    [categories addObject:@"도시락/돈까스"];
    [categories addObject:@"족발/보쌈"];
    [categories addObject:@"냉면"];
    [categories addObject:@"기타"];
    
    // custom title view
    UIView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    self.navigationItem.titleView = customTitleView;
    
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:114/255.0 blue:51/255.0 alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)showEmail{
    
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
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categories count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell * cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:@""];
    
    if(cell == nil){
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if(indexPath.row == [categories count]){
        cell.categoryLabel.text = @"Contact Us";
    }else{
        cell.categoryLabel.text = [categories objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [categories count]){
        [self showEmail];
        
    }else{
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DetailViewController * viewController = (DetailViewController *)[segue destinationViewController];
        viewController.category = [categories objectAtIndex:indexPath.row];
        [viewController setDetailItem:[allData objectForKey:viewController.category]];
        
        CustomTitleView * titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][1];
        
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        UIImage * categoryImg;
        switch (index) {
            case 0:
                categoryImg = [UIImage imageNamed:@"iconChic.png"];
                break;
            case 1:
                categoryImg = [UIImage imageNamed:@"iconPizza.png"];
                break;
            case 2:
                categoryImg = [UIImage imageNamed:@"iconChinese.png"];
                break;
            case 3:
                categoryImg = [UIImage imageNamed:@"iconBab.png"];
                break;
            case 4:
                categoryImg = [UIImage imageNamed:@"iconDosirak.png"];
                break;
            case 5:
                categoryImg = [UIImage imageNamed:@"iconBossam.png"];
                break;
            case 6:
                categoryImg = [UIImage imageNamed:@"iconNoodle.png"];
                break;
            case 7:
                categoryImg = [UIImage imageNamed:@"iconEtc.png"];
                break;
            default:
                break;
        }
        
        titleView.categoryImageView.image = categoryImg;
        titleView.categoryLabel.text = [categories objectAtIndex:index];
        viewController.navigationItem.titleView = titleView;
    }
}

@end
