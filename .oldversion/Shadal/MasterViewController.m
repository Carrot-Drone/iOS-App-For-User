//
//  MasterViewController.m
//  Shadal
//
//  Created by SukWon Choi on 13. 10. 2..
//  Copyright (c) 2013년 Wafflestudio. All rights reserved.
//

#import "UIImage+IMAGECategories.h"

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "CustomTitleView.h"

#import "Restaurant.h"
#import "RestaurantCell.h"
#import "CategoryCell.h"
#import "AppDelegate.h"

#import "Constants.h"
#import "Static.h"
#import "Server.h"


@interface MasterViewController () {
    NSMutableArray * categories;
    NSDictionary * allData;
    
    NSMutableArray *searchResults;
    
    NSInteger selectedRow;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // reset default tint color
    self.navigationController.navigationBar.tintColor = nil;

    // init data
    categories = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc] init];
    
    [categories addObject:@"치킨"];
    [categories addObject:@"피자"];
    [categories addObject:@"중국집"];
    [categories addObject:@"한식/분식"];
    [categories addObject:@"도시락/돈까스"];
    [categories addObject:@"족발/보쌈"];
    [categories addObject:@"냉면"];
    [categories addObject:@"기타"];
    
    // custom title view
    
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    if ([Static campusInfo] != nil){
        customTitleView.subTitleLabel.text = [[Static campusInfo] objectForKey:@"name_kor"];
    }
    self.navigationItem.titleView = customTitleView;
    
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // init tableView
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    // hide search bar
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    // set color of bounce area
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = SEARCH_BAR_BACKGROUND_COLOR;
    [self.tableView addSubview:topview];
    
    // set search bar
    UISearchBar * searchBar = self.searchDisplayController.searchBar;
    searchBar.translucent = NO;
    searchBar.backgroundImage = [UIImage image1x1WithColor:SEARCH_BAR_BACKGROUND_COLOR];

}
-(void)viewWillAppear:(BOOL)animated{
    // update title view
    CustomTitleView * customTitleView = (CustomTitleView *)self.navigationItem.titleView;
    NSDictionary * campusInfo = [Static campusInfo];
    if (campusInfo != nil){
        customTitleView.subTitleLabel.text = [campusInfo objectForKey:@"name_kor"];
    }
    
    // init allData
    allData = [Static allData];
    [self.tableView reloadData];
    
    
    // GA
    [Server sendGoogleAnalyticsScreen:@"메인 화면"];
}
-(void)viewDidAppear:(BOOL)animated{
    if([Static campus]==nil){
        // No campus has selected
        [self performSegueWithIdentifier:@"selectCampus" sender:self];
    }
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResults removeAllObjects];
    for(id key in allData){
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        [searchResults addObjectsFromArray:[[allData objectForKey:key] filteredArrayUsingPredicate:resultPredicate]];
    }
    [searchResults sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(Restaurant *)obj1 compare:(Restaurant*) obj2];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [categories count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        // 음식점을 검색하는 경우.
        RestaurantCell * cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
        
        if(cell == nil){
            NSArray * array;
            array = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:nil options:nil];
            cell = [array objectAtIndex:0];
        }
        
        Restaurant * res = [searchResults objectAtIndex:indexPath.row];
        [cell setResIcons:res];
        cell.restaurantLabel.text = res.name;
        return cell;
    }
    CategoryCell * cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:@""];
    
    if(cell == nil){
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.categoryImage.image = [self getCategoryImage:(int)indexPath.row];
    cell.categoryLabel.text = [categories objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        selectedRow = indexPath.row;
        [self performSegueWithIdentifier:@"Restaurant" sender:self];
    }else{
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    NSInteger realInt = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    if(realInt % 2 == 0)
        cell.backgroundColor = BACKGROUND_COLOR;
    else
        cell.backgroundColor = HIGHLIGHT_COLOR;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DetailViewController * viewController = (DetailViewController *)[segue destinationViewController];
        viewController.category = [categories objectAtIndex:indexPath.row];
        [viewController setDetailItem:[allData objectForKey:viewController.category]];
        
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        CustomTitleView * titleView;
        if(index==0 || index == 1|| index == 6 || index==7){
            titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][1];
        }else if(index==2){
            titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][1];
        }
        else{
            titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][1];
        }
    
        UIImage * categoryImg = [self getCategoryImage:(int)index];
        
        titleView.categoryImageView.image = categoryImg;
        titleView.categoryLabel.text = [categories objectAtIndex:index];
        viewController.navigationItem.titleView = titleView;
        
        // GA
        [Server sendGoogleAnalyticsEvent:@"UX" action:@"category_clicked" label:viewController.category];
        
    }else if ([[segue identifier] isEqualToString:@"Restaurant"]) {
        Restaurant * res = [searchResults objectAtIndex:selectedRow];
        [[segue destinationViewController] setDetailItem:res];
        
        // GA
        [Server sendGoogleAnalyticsEvent:@"UX" action:@"searched_res_clicked" label:res.name];
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
-(UIImage *)getCategoryImage:(int)index{
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
    return categoryImg;
    
}
@end
