//
//  DetailViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "DetailViewController.h"
#import "RestaurantCell.h"
#import "Restaurant.h"

#import "Constants.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize resArray;

- (void)setDetailItem:(id)detailItem{
    resArray = (NSMutableArray *)detailItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [resArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RestaurantCell * cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    Restaurant * res = [resArray objectAtIndex:indexPath.row];
    
    cell.restaurantLabel.text = res.name;
    
    if(res.flyer){
        cell.secondImage.image = [UIImage imageNamed:@"flyer"];
        if(res.coupon){
            cell.firstImage.image = [UIImage imageNamed:@"coupon"];
        }else{
            cell.firstImage.hidden = YES;
        }
    }else{
        cell.firstImage.hidden = YES;
        if(res.coupon){
            cell.secondImage.image = [UIImage imageNamed:@"coupon"];
        }else{
            cell.secondImage.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Restaurant" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Restaurant"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[resArray objectAtIndex:indexPath.row]];
    }
}

@end
