//
//  RestaurantSuggestionSelectCampusViewController.m
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import "RestaurantSuggestionSelectCampusViewController.h"
#import "RestaurantSuggestionDetailViewController.h"

#import "Campus.h"

#import "StaticHelper.h"

@interface RestaurantSuggestionSelectCampusViewController (){
    NSArray * _campuses;
}

@end

@implementation RestaurantSuggestionSelectCampusViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init TableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // init Campuses
    _campuses = [[StaticHelper staticHelper] campuses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - ButtonClicked
-(void)campusSelected:(Campus *)selectedCampus{
    RestaurantSuggestionDetailViewController * vc = (RestaurantSuggestionDetailViewController *)[self presentingViewController];
    
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_campuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CampusCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CampusCell"];
    }
    
    Campus * campus = [_campuses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [campus nameKor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Campus * selectedCampus = [_campuses objectAtIndex:indexPath.row];
    [self campusSelected:selectedCampus];
}


@end
