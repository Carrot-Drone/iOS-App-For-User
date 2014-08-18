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

@interface DetailViewController (){
    NSMutableArray * resWithFlyer;
    NSMutableArray * resWithoutFlyer;
}

@end

@implementation DetailViewController

@synthesize resArray, category;

- (void)setDetailItem:(id)detailItem{
    resArray = (NSMutableArray *)detailItem;
}

- (void)updateViewData{
    [Server checkForNewRestaurant:category];
}

- (void)updateUI:(NSNotification *)notification{
    self.tableView.backgroundColor = BACKGROUND_COLOR;
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
    [resWithFlyer removeAllObjects];
    [resWithoutFlyer removeAllObjects];
    
    for(Restaurant * res in resArray){
        if(res.has_flyer){
            [resWithFlyer addObject:res];
        }else{
            [resWithoutFlyer addObject:res];
        }
    }
    
    [resWithFlyer sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    [resWithoutFlyer sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    
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
    
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self.tableView setBackgroundColor:BACKGROUND_COLOR];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self updateViewData];
    });
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    // myNotificationCenter 객체를 이용해서 옵저버 등록
    [sendNotification addObserver:self selector:@selector(updateUI:) name:@"checkForResInCategory" object: nil];
    
    // init objects
    resWithFlyer = [[NSMutableArray alloc] init];
    resWithoutFlyer = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [resArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    
    [resWithFlyer removeAllObjects];
    [resWithoutFlyer removeAllObjects];
    
    for(Restaurant * res in resArray){
        if(res.has_flyer){
            [resWithFlyer addObject:res];
        }else{
            [resWithoutFlyer addObject:res];
        }
    }
    
    [resWithFlyer sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    [resWithoutFlyer sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
    
    [self.tableView reloadData];
    
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [resWithFlyer count];
    }else{
        return [resWithoutFlyer count];
    }
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
    
    Restaurant * res;
    if(indexPath.section ==0){
        res = [resWithFlyer objectAtIndex:indexPath.row];
    }else{
        res = [resWithoutFlyer objectAtIndex:indexPath.row];
    }
    [cell setResIcons:res];
    cell.restaurantLabel.text = res.name;
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([resWithFlyer count]==0) return @"";
    if(section == 0){
        return @"전단지";
    }else{
        return @"일반";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Restaurant" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Restaurant"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Restaurant * res;
        if(indexPath.section == 0) res = [resWithFlyer objectAtIndex:indexPath.row];
        else res = [resWithoutFlyer objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setDetailItem:res];
    }
}


- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSInteger retInt = 0;
	if (!indexPath.section)
	{
		return indexPath.row;
	}
	for (int i=0; i<indexPath.section;i++)
	{
		retInt += [tableView numberOfRowsInSection:i];
	}
    
	return retInt + indexPath.row;
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    NSInteger realInt = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    if(realInt % 2 == 0)
        cell.backgroundColor = BACKGROUND_COLOR;
    else
        cell.backgroundColor = HIGHLIGHT_COLOR;
}
@end