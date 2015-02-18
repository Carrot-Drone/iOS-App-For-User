//
//  SelectCampusViewController.m
//  Shadal
//
//  Created by Sukwon Choi on 2/10/15.
//  Copyright (c) 2015 Wafflestudio. All rights reserved.
//

#import "SelectCampusViewController.h"
#import "Static.h"
#import "Server.h"
#import "Constants.h"

@interface SelectCampusViewController (){
    NSMutableArray * campuses;
    NSIndexPath * lastSelected;
}

@end

@implementation SelectCampusViewController
@synthesize indicatorView;
@synthesize titleLabel, campusTableView;
@synthesize maintitleLabel, subtitleLabel;
@synthesize selectCampusButton, startButton;

@synthesize tabBarController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // save current data
    [Static saveData];
    
    campuses = [[NSMutableArray alloc] init];
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    // myNotificationCenter 객체를 이용해서 옵저버 등록
    [sendNotification addObserver:self selector:@selector(campuses:) name:@"campuses" object: nil];
    [sendNotification addObserver:self selector:@selector(start) name:@"start" object:nil];
    [Server campuses];
    
    // init button
    [startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [selectCampusButton addTarget:self action:@selector(selectCampusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // init tableView
    campusTableView.delegate = self;
    campusTableView.dataSource = self;
    
    // init indicator view
    [indicatorView stopAnimating];
    [indicatorView setHidden:YES];
    
    // init background color
    [self.view setBackgroundColor:MAIN_COLOR];
    
    // init buttons
    [selectCampusButton setBackgroundColor:[UIColor whiteColor]];
    [selectCampusButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    selectCampusButton.layer.cornerRadius = 5;

    
    [startButton setBackgroundColor:SUB_COLOR2];
    [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [startButton setUserInteractionEnabled:NO];
    startButton.layer.cornerRadius = 5;
}


// Notification from server
- (void)campuses:(NSNotification *)notification{
    NSDictionary * dic = [notification userInfo];
    
    [campuses removeAllObjects];
    for (NSDictionary * campus_info in dic) {
        [campuses addObject:campus_info];
    }
    [campusTableView reloadData];
}

- (void)startButtonClicked{
    [indicatorView startAnimating];
    [indicatorView setHidden:NO];
    [self performSelector:@selector(startLoading:) withObject:nil afterDelay:0.1f];
}
- (void)startLoading:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [Static setCampusInfo:[campuses objectAtIndex:lastSelected.row]];
        
        [Static loadData];
        
        [self start];
    });
}

- (void)start{
    [self dismissViewControllerAnimated:YES completion:nil];

    if(tabBarController != nil){
        tabBarController.selectedViewController = [tabBarController.viewControllers objectAtIndex:0];
    }
    
    
}

- (void)selectCampusButtonClicked{
    [selectCampusButton setHidden:YES];
    [campusTableView setHidden:NO];
    
    // remove maintitleLabel to rearrange contraint
    [maintitleLabel setHidden:YES];
    [subtitleLabel setHidden:YES];
    [titleLabel setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [campuses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"campusCell"];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"campusCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [[campuses objectAtIndex:indexPath.row] objectForKey:@"name_kor"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (lastSelected==indexPath) return; // nothing to do
    
    // deselect old
    UITableViewCell *old = [tableView cellForRowAtIndexPath:lastSelected];
    old.accessoryType = UITableViewCellAccessoryNone;
    
    // select new
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // keep track of the last selected cell
    lastSelected = indexPath;
    
    if(lastSelected != nil){
        [startButton setBackgroundColor:[UIColor whiteColor]];
        [startButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [startButton setUserInteractionEnabled:YES];
    }
}

@end
