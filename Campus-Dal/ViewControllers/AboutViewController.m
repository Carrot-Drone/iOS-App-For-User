//
//  AboutViewController.m
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import "AboutViewController.h"
#import "CustomTitleView.h"
#import "CustomCurrentCampusCell.h"
#import "CustomTableViewSection.h"

#import "UIColor+COLORCategories.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"


@implementation AboutViewController{
    NSArray * _sectionArray;
    NSArray * _rowArray;
    NSString * _currentCampus;
}

@synthesize tableView=_tableView;

- (void)viewDidLoad{
    // init _currentCampus
    _currentCampus = [[[StaticHelper staticHelper] campus] nameKor];
    
    // init TableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor  clearColor];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    // init Section and Row Data
    _sectionArray = [NSArray arrayWithObjects:@"현재 캠퍼스", @"다른 캠퍼스 선택하기", @"문의하기", nil];
    _rowArray = [NSArray arrayWithObjects:@"",[NSArray arrayWithObject:@"캠퍼스 바꾸기"],[NSArray arrayWithObject:@"캠달 팀에 문의하기"],nil];
    
    // init Navigation Controller
    [self initNavigationController];
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"더 보기"];
    self.navigationItem.titleView = customTitleView;
}

- (void)viewWillAppear:(BOOL)animated{
    _currentCampus = [[[StaticHelper staticHelper] campus] nameKor];

    [_tableView reloadData];
    
    // GA
    [ServerHelper sendGoogleAnalyticsScreen:@"더보기 화면"];
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomTableViewSection * sectionView = (CustomTableViewSection *)[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewSection" owner:nil options:nil][0];
    
    [sectionView.titleLabel setText:[_sectionArray objectAtIndex:section]];
    if(section == 0){
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_campus"]];
    }else if(section == 1){
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_change"]];
    }else if(section == 2){
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_call"]];
    }
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 50;
    }else{
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CustomCurrentCampusCell * cell = (CustomCurrentCampusCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomCurrentCampusCell" owner:nil options:nil][0];

        // 현재 캠퍼스
        cell.backgroundColor = tableView.backgroundColor;
        cell.currentCampus.text = _currentCampus;
        cell.userInteractionEnabled = NO;
        return cell;
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AboutCell"];
        
        // set cell
        [cell.textLabel setFont:[UIFont fontWithName:MAIN_FONT size:18]];
        [cell.textLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
        
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
        
        if(indexPath.row == 0){
            UIImageView *separator_top;
            
            separator_top = [[UIImageView alloc] initWithFrame:CGRectMake(separatorInset, 0, separatorWidth,separatorHeight)];
            separator_top.backgroundColor = separatorBGColor;
            
            [cell addSubview: separator_top];
        }
        [cell.textLabel setText:[[_rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = TAB_BAR_BG_COLOR;
        
        return cell;
    }
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if(indexPath.section == 1){
         if(indexPath.row == 0){
             // 캠퍼스 바꾸기
             [self performSegueWithIdentifier:@"SelectCampusViewController" sender:self];
             
             // GA
             [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"select_campus_in_about" label:@""];
        }
     }else if(indexPath.section == 2){
         if(indexPath.row == 0){
             // 캠달팀에 문의하기
             [self performSegueWithIdentifier:@"UserRequestViewController" sender:self];
         }
     }
 }

@end
