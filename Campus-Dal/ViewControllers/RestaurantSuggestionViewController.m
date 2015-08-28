//
//  RestaurantSuggestionViewController.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RestaurantSuggestionViewController.h"

#import "RestaurantSuggestionDetailViewController.h"

#import "CustomTitleView.h"
#import "RSTableViewCell.h"
#import "RSTableViewFooterView.h"

#import "Constants.h"
#import "ServerHelper.h"

@interface RestaurantSuggestionViewController (){
    BOOL _isByUser;
}

@end

@implementation RestaurantSuggestionViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init TableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44.0;
    _tableView.separatorColor = [UIColor clearColor];
    //RSTableViewFooterView * rsfv = (RSTableViewFooterView *)[[NSBundle mainBundle] loadNibNamed:@"RSTableViewFooterView" owner:nil options:nil][0];
    //_tableView.tableFooterView = rsfv;
    
    // init Navigation Controller
    [self initNavigationController];
    
    // init RightBarButtonItem
    [self setRightBarButtonItem];
}

- (void)setRightBarButtonItem{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Icon_action_bar_cancel"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"음식점추가 / 입점문의"];
    self.navigationItem.titleView = customTitleView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"음식점추가 / 입점문의 화면"];
}

# pragma Button Clicked
- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)suggestionButtonClicked:(UIButton *)sender{
    
    if(sender.tag == 0){
        _isByUser = YES;
        [self performSegueWithIdentifier:@"RSDetailViewController" sender:self];
    }else{
        _isByUser = NO;
        [self performSegueWithIdentifier:@"RSDetailViewController" sender:self];
    }
}

#pragma mark -Prepare Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"RSDetailViewController"]){
        [[segue destinationViewController] setDetailItem:_isByUser];
    }
}


# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RSTableViewCell * cell;
    
    if(cell == nil) {
        cell = (RSTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"RSTableViewCell" owner:nil options:nil][0];
    }
    
    if(indexPath.row == 0){
        cell.subLabel.text = @"여기 음식 참 맛있는데...";
        cell.mainLabel1.text = @"학교 주변 맛집이 추가되었으면";
        cell.mainLabel2.text = @" 좋겠다구요?";
        [cell.imageView setImage:[UIImage imageNamed:@"Icon_add_store"]];
        [cell.suggestionButton setTitle:@"음식점 제보하기" forState:UIControlStateNormal];
        cell.suggestionButton.tag = indexPath.row;
        

    }else{
        cell.subLabel.text = @"수수료 0원, 입점비용 0원, 완전 무료!";
        cell.mainLabel1.text = @"캠퍼스:달 서비스에 입점하고 싶으세요?";
        [cell.mainLabel2 removeFromSuperview];
        [cell.imageView setImage:[UIImage imageNamed:@"Icon_add_chef"]];
        [cell.suggestionButton setTitle:@"음식점 등록하기" forState:UIControlStateNormal];
        cell.suggestionButton.tag = indexPath.row;
        
        // Set Cutom Table Separator
        CGFloat separatorInset; // Separator x position
        CGFloat separatorHeight;
        CGFloat separatorWidth;
        CGFloat separatorY;
        UIImageView *separator_top;
        UIColor *separatorBGColor;
        
        separatorY      = 0;
        separatorHeight = (1.0 / [UIScreen mainScreen].scale);  // This assures you to have a 1px line height whatever the screen resolution
        separatorWidth  = 10000;
        separatorInset  = 0.0f;
        separatorBGColor  = DIVIDER_COLOR2;
        
        
        separator_top = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, separatorY, separatorWidth,separatorHeight)];
        separator_top.backgroundColor = separatorBGColor;
        [cell addSubview: separator_top];
    }
    [cell.suggestionButton addTarget:self action:@selector(suggestionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
