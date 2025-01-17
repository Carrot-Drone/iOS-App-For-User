//
//  FavoriteTableViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 8/12/14.
//  Copyright (c) 2014 Wafflestudio. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Constants.h"
#import "Static.h"
#import "Server.h"
#import "CustomTitleView.h"
#import "RestaurantViewController.h"
@interface FavoriteViewController (){
    NSMutableArray * categories;
}

@end

@implementation FavoriteViewController
@synthesize favoriteRes, tableView;

- (void)setDetailItem:(id)detailItem{
    favoriteRes = (NSMutableDictionary *)detailItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    categories = [[NSMutableArray alloc] init];
    [categories addObject:@"치킨"];
    [categories addObject:@"피자"];
    [categories addObject:@"중국집"];
    [categories addObject:@"한식/분식"];
    [categories addObject:@"도시락/돈까스"];
    [categories addObject:@"족발/보쌈"];
    [categories addObject:@"냉면"];
    [categories addObject:@"기타"];
    
    favoriteRes = [[NSMutableDictionary alloc] init];
    
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // init titleView
    CustomTitleView * titleView  = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][2];
    titleView.categoryImageView.image = [UIImage imageNamed:@"BotIconStar"];
    titleView.categoryLabel.text = @"즐겨찾기";
    self.navigationItem.titleView = titleView;
    
}
-(void)viewWillAppear:(BOOL)animated{
    // GA
    [Server sendGoogleAnalyticsScreen:@"즐겨찾기 화면"];
    
    // init Favorite Res array
    for(id key in favoriteRes){
        NSMutableArray * array = [favoriteRes objectForKey:key];
        if([array count]!=0)
            [array removeAllObjects];
    }
    
    NSDictionary* allData = [Static allData];
    for(id key in [allData allKeys]){
        NSArray * restaurants = [allData objectForKey:key];
        for(Restaurant * res in restaurants){
            if(res.isFavorite){
                if([favoriteRes objectForKey:key]!=nil){
                    [[favoriteRes objectForKey:key] addObject:res];
                }else{
                    [favoriteRes setObject:[NSMutableArray arrayWithObject:res] forKey:key];
                }
            }
        }
    }
    if([self totalNumberOfRestaurant]==0){
        self.tableView.hidden = YES;
        self.view.backgroundColor = BACKGROUND_COLOR;
    }else{
        self.tableView.hidden = NO;
    }
    [[self tableView] reloadData];
    
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(favoriteRes == nil) return 0;
    return [[favoriteRes objectForKey:[categories objectAtIndex:section]] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * category = [categories objectAtIndex:section];
    if([favoriteRes objectForKey:category] && [[favoriteRes objectForKey:category] count]!=0){
        return category;
    }else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantCell";
    
    RestaurantCell * cell = (RestaurantCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray * array;
        array = [[NSBundle mainBundle] loadNibNamed:@"RestaurantCell" owner:nil options:nil];
        cell = (RestaurantCell*)[array objectAtIndex:0];
    }
    Restaurant * res = [[favoriteRes objectForKey:[categories objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell.restaurantLabel setText:res.name];
    res.isFavorite = NO;
    [cell setResIcons:res];
    res.isFavorite = YES;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Restaurant" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Restaurant"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Restaurant * res = [[favoriteRes objectForKey:[categories objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:res];
        
        // GA
        [Server sendGoogleAnalyticsEvent:@"UX" action:@"res_in_favorite_clicked" label:res.name];
    }
}

- (NSInteger) totalNumberOfRestaurant{
    int cnt = 0;
    for(id key in favoriteRes){
        cnt += [[favoriteRes objectForKey:key] count];
    }
    return (NSInteger)cnt;
}
@end
