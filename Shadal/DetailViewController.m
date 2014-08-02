//
//  DetailViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "RestaurantCell.h"
#import "Restaurant.h"
#import "Server.h"

#import "Constants.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize resArray, category;

- (void)setDetailItem:(id)detailItem{
    NSLog(@"%@", category); 
    resArray = (NSMutableArray *)detailItem;
}


- (void)updateViewData{
    [Server checkForNewRestaurant:category];
}

- (void)updateUI:(NSNotification *)notification{
    NSDictionary * dictionary = [notification userInfo];
    
    // Add New Restaurant
    for(NSDictionary * restaurant in dictionary){
        BOOL isNew = true;
        for(Restaurant * res in resArray){
            if([res.name isEqualToString:[restaurant objectForKey:@"name"]]
               && [res.phoneNumber isEqualToString:[restaurant objectForKey:@"phone_number"]])
               {
                isNew = false;
                break;
            }
        }
        if(isNew){
            Restaurant * newRes = [[Restaurant alloc] initWithName:[restaurant objectForKey:@"name"] phoneNumber:[restaurant objectForKey:@"phone_number"]];
            [resArray addObject:newRes];
        }
    }
    
    // Remove deleted Restaurant
    NSMutableArray * resShouldRemoved = [[NSMutableArray alloc] init];
    for(Restaurant * res in resArray){
        BOOL isRemoved = true;
        for(NSDictionary * restaurant in dictionary){
            if(([res.name isEqualToString:[restaurant objectForKey:@"name"]]
                   && [res.phoneNumber isEqualToString:[restaurant objectForKey:@"phone_number"]])
               ){
                // update Res info based on new Res
                // Only for meta data. If you push in to the real Restaurant view, it will then update it's content
                res.has_flyer = [[restaurant objectForKey:@"has_flyer"] boolValue];
                res.has_coupon = [[restaurant objectForKey:@"has_coupon"] boolValue];
                isRemoved = false;
                break;
            }
        }
        if(isRemoved){
            [resShouldRemoved addObject:res];
        }
    }
    for(Restaurant * res in resShouldRemoved){
        [resArray removeObject:res];
    }
    
    [resArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    
    
    //update tableView
    [[self tableView] reloadData];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self updateViewData];
    });
    
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    // myNotificationCenter 객체를 이용해서 옵저버 등록
    [sendNotification addObserver:self selector:@selector(updateUI:) name:@"checkForResInCategory" object: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [resArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    
    [[self tableView] reloadData];
    
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
    
    if(res.has_flyer){
        cell.secondImage.image = [UIImage imageNamed:@"flyer"];
        if(res.has_coupon){
            cell.firstImage.image = [UIImage imageNamed:@"coupon"];
        }else{
            cell.firstImage.hidden = YES;
        }
    }else{
        cell.firstImage.hidden = YES;
        if(res.has_coupon){
            cell.secondImage.image = [UIImage imageNamed:@"coupon"];
        }else{
            cell.secondImage.hidden = YES;
        }
    }
    NSLog(@"%@ %d %d", res.name, res.has_coupon, res.has_flyer);
    
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
