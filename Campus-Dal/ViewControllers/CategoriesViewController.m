//
//  SecondViewController.m
//  Campus-Dal
//
//  Created by Sukwon Choi on 8/4/15.
//  Copyright (c) 2015 Carrot&Drone. All rights reserved.
//

#import "CategoriesViewController.h"

#import "RestaurantsViewController.h"
#import "FlyerViewController.h"
#import "RestaurantViewController.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "CategoryModel.h"
#import "Restaurant.h"
#import "Menu.h"

#import "CustomTitleView.h"
#import "CategoriesTableViewCell.h"
#import "CategoriesTableViewFooter.h"
#import "RestaurantsTableViewCell.h"

#import "UIImage+IMAGECategories.h"

@interface CategoriesViewController (){
    NSArray * _categories;
    NSArray * _categoriesImageName;
    CategoryModel * _selectedCategory;
    Restaurant * _selectedRestaurant;
    
    NSMutableArray * _searchResults;
}

@end

@implementation CategoriesViewController

@synthesize tableView=_tableView;
@synthesize searchController=_searchController;

- (void)restaurantSuggestionButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"RestaurantSuggestionViewController" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init table view
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    
    CategoriesTableViewFooter * ctvf = (CategoriesTableViewFooter *)[[NSBundle mainBundle] loadNibNamed:@"CategoriesTableViewFooter" owner:nil options:nil][0];
    NSString * campusName = [[[StaticHelper staticHelper] campus] nameKor];
    NSString * administrator = [[[StaticHelper staticHelper] campus] administrator];
    if(administrator == nil || [administrator isEqualToString:@""]){
        administrator = @"캠퍼스:달";
    }
    [ctvf.subLabel1 setText:[NSString stringWithFormat:@"%@ 주변 음식점 정보의 수정 및 관리는", campusName]];
    [ctvf.subLabel2 setText:[NSString stringWithFormat:@"%@에서 관리합니다", administrator]];
    _tableView.tableFooterView = ctvf;
    
    // init categories image name
    _categoriesImageName = [[NSArray alloc] initWithObjects:@"Icon_list_food_chicken", @"Icon_list_food_pizza", @"Icon_list_food_chinese_dishes", @"Icon_list_food_korean_dishes", @"Icon_list_food_lunch",  @"Icon_list_food_jokbal", @"Icon_list_food_cold_noodles",@"Icon_list_food_etc",  nil];
    
    // init search results
    _searchResults = [[NSMutableArray alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    [_searchController.searchBar setPlaceholder:@"음식점 이름이나 메뉴를 검색하세요"];
    self.view.backgroundColor = MAIN_COLOR;
    [[UISearchBar appearance] setBackgroundImage:[UIImage image1x1WithColor:MAIN_COLOR]];
    _tableView.tableHeaderView = _searchController.searchBar;
    _tableView.backgroundColor =[UIColor clearColor];
    self.definesPresentationContext = YES;
    

    // init navigation controller
    [self initNavigationController];
    
    
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // init add left bar button item
    [self setLeftBarButtonItem];
    
    // remove border in nav bar
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"음식점"];
    self.navigationItem.titleView = customTitleView;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setLeftBarButtonItem{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Icon_action_bar_plus"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restaurantSuggestionButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = barButton;
}
- (void)viewWillAppear:(BOOL)animated{
    _categories = [[StaticHelper staticHelper] allData];
    [_tableView reloadData];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"카테고리 화면"];
}

# pragma mark - Search Bar Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString];
    [self.tableView reloadData];
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    [_searchResults removeAllObjects];
    NSArray * allData = [[StaticHelper staticHelper] allData];
    for(CategoryModel * category in allData){
        for(Restaurant * restaurant in category.restaurants){
            BOOL flag = NO;
            if([restaurant.name containsString:searchText]){
                flag = YES;
            }
            for(NSArray * section in restaurant.menus){
                for(Menu * menu in section){
                    if([menu.name containsString:searchText]){
                        flag = YES;
                    }
                }
            }
            if(flag){
                [_searchResults addObject:restaurant];
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [_tableView.tableFooterView setHidden:YES];
    _tableView.backgroundColor =[UIColor whiteColor];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if(searchBar.text == nil || [searchBar.text isEqualToString:@""]){
        [_tableView.tableFooterView setHidden:NO];
        _tableView.backgroundColor =[UIColor clearColor];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, -200, 0)];
    }
    
}

# pragma mark - ButtonClicked

- (void)categorySelected:(CategoryModel *)selectedCategory{
    _selectedCategory = selectedCategory;
    [self performSegueWithIdentifier:@"RestaurantsViewController" sender:self];
}
- (void)restaurantSelected:(Restaurant *)selectedRestaurant{
    _selectedRestaurant = selectedRestaurant;
    [self performSegueWithIdentifier:@"RestaurantViewController" sender:self];
}
- (void)flyerButtonClicked:(UIButton *)sender{
    _selectedRestaurant = [_searchResults objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:@"FlyerViewController" sender:self];
}
# pragma mark -PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RestaurantsViewController"]) {
        [[segue destinationViewController] setDetailItem:_selectedCategory];
    }else if([[segue identifier] isEqualToString:@"RestaurantViewController"]){
        RestaurantViewController * rvc = (RestaurantViewController *)[segue destinationViewController];
        rvc.hidesBottomBarWhenPushed = YES;
        [rvc setDetailItem:_selectedRestaurant];
    }else if([[segue identifier] isEqualToString:@"FlyerViewController"]){
        FlyerViewController * vc = (FlyerViewController *)[[segue destinationViewController] topViewController];
        [vc setDetailItem:_selectedRestaurant];
    }
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [_searchResults count];
    } else {
        return [_categories count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.active) {
        RestaurantsTableViewCell * cell = (RestaurantsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
        if(cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RestaurantsTableViewCell" owner:nil options:nil][0];
        }
        
        Restaurant * restaurant = [_searchResults objectAtIndex:indexPath.row];
        
        cell.retentionLabel.text = [restaurant retentionString];
        cell.nameLabel.text = [restaurant name];
        cell.flyerButton.hidden = ![[restaurant hasFlyer] boolValue];
        cell.flyerButton.tag = indexPath.row;
        [cell.flyerButton addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // Set Cutom Table Separator
        CGFloat separatorInset; // Separator x position
        CGFloat separatorHeight;
        CGFloat separatorWidth;
        CGFloat separatorY;
        UIImageView *separator_bottom;
        UIColor *separatorBGColor;
        
        //separatorY      = cell.frame.size.height;
        separatorY          = 50;
        separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
        separatorWidth  = 10000;
        separatorInset  = 0.0f;
        separatorBGColor  = [UIColor colorWithRed: 204.0/255.0 green: 204.0/255.0 blue: 204.0/255.0 alpha:1.0];
        
        
        separator_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, separatorY, separatorWidth,separatorHeight)];
        separator_bottom.backgroundColor = separatorBGColor;
        [cell addSubview: separator_bottom];
        
        return cell;
    }
    
    CategoriesTableViewCell * cell = (CategoriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CategoriesTableViewCell" owner:nil options:nil][0];
    }
    
    // Set Cutom Table Separator
    CGFloat separatorInset; // Separator x position
    CGFloat separatorHeight;
    CGFloat separatorWidth;
    CGFloat separatorY;
    UIImageView *separator_bottom;
    UIColor *separatorBGColor;
    
    //separatorY      = cell.frame.size.height;
    separatorY          = 50;
    separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
    separatorWidth  = 10000;
    separatorInset  = 0.0f;
    separatorBGColor  = [UIColor colorWithRed: 204.0/255.0 green: 204.0/255.0 blue: 204.0/255.0 alpha:1.0];
    
    
    separator_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, separatorY, separatorWidth,separatorHeight)];
    separator_bottom.backgroundColor = separatorBGColor;
    [cell addSubview: separator_bottom];
    
    
    CategoryModel * category = [_categories objectAtIndex:indexPath.row];
    NSString * categoryImageName = [_categoriesImageName objectAtIndex:indexPath.row];
    
    cell.categoryLabel.text = [category title];
    [cell.categoryImageView setImage:[UIImage imageNamed:categoryImageName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.searchController.active){
        Restaurant * selectedRestaurant = [_searchResults objectAtIndex:indexPath.row];
        [self restaurantSelected:selectedRestaurant];
        
        // GA
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"res_in_search_clicked" label:[selectedRestaurant.serverID stringValue]];
    }else{
        CategoryModel * category = [_categories objectAtIndex:indexPath.row];
        [self categorySelected:category];
        
        // GA
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"category_in_categories_clicked" label:[category.serverID stringValue]];
    }
    
}

@end
