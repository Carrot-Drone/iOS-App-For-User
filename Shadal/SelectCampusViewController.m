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

@interface SelectCampusViewController (){
    NSMutableArray * campuses;
    NSIndexPath * lastSelected;
}

@end

@implementation SelectCampusViewController
@synthesize indicatorView;
@synthesize titleLabel, campusTableView;
@synthesize selectCampusButton, startButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    campuses = [[NSMutableArray alloc] init];
    
    // myNotificationCenter 객체 생성 후 defaultCenter에 등록
    NSNotificationCenter *sendNotification = [NSNotificationCenter defaultCenter];
    
    // myNotificationCenter 객체를 이용해서 옵저버 등록
    [sendNotification addObserver:self selector:@selector(campuses:) name:@"campuses" object: nil];
    
    [Server campuses];
    
    // init button
    [startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [selectCampusButton addTarget:self action:@selector(selectCampusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // init tableView
    campusTableView.delegate = self;
    campusTableView.dataSource = self;
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
    [Static setCampusInfo:[campuses objectAtIndex:lastSelected.row]];
    [Static loadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectCampusButtonClicked{
    [selectCampusButton setHidden:YES];
    [campusTableView setHidden:NO];
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
}
@end
