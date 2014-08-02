//
//  MasterViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "Restaurant.h"

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if(indexPath.row == [categories count]){
        cell.textLabel.text = @"Contact Us";
    }else{
        cell.textLabel.text = [categories objectAtIndex:indexPath.row];
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
    }
}

@end
