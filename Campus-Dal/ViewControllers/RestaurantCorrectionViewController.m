//
//  RestaurantCorrectionViewController.m
//  
//
//  Created by Sukwon Choi on 8/12/15.
//
//

#import "RestaurantCorrectionViewController.h"
#import "RestaurantCorrectionCell.h"
#import "CustomTitleView.h"

#import "Restaurant.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#define TEXT_VIEW_PLACEHOLDER @"수정사항을 적어주세요"

@interface RestaurantCorrectionViewController (){
    NSArray * _titles;
    UITextView * _textView;
    NSMutableDictionary * _cells;
    Restaurant * _restaurant;
}

@end

@implementation RestaurantCorrectionViewController

@synthesize tableView=_tableView;
@synthesize footerView=_footerView;

- (void)setDetailItem:(Restaurant *)restaurant{
    _restaurant = restaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init tableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44.0;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.bounces = NO;
    
    // dismiss Keyboard by tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // init footerView
    [_footerView.button setTitle:@"수정 사항 보내기" forState:UIControlStateNormal];
    [_footerView.button addTarget:self action:@selector(sendRestaurantCorrectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // init titles;
    _titles = [[NSArray alloc] initWithObjects:@"이 매장이 없어졌어요", @"메뉴 정보가 틀려요", @"전단지가 잘 안보여요", @"매장 전화번호가 틀려요", @"영업시간 정보가 틀려요", nil];
    
    // init cells
    _cells = [[NSMutableDictionary alloc] init];
    
    // init Navigation Controller
    [self initNavigationController];
    
    // init Right Bar Button
    [self setRightBarButtonItem];
}

- (void)initNavigationController{
    // init navigation bar
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // custom title view
    CustomTitleView * customTitleView;
    customTitleView = [[NSBundle mainBundle] loadNibNamed:@"CustomTitleView" owner:nil options:nil][0];
    [customTitleView.titleLabel setText:@"매장정보 수정"];
    self.navigationItem.titleView = customTitleView;
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
- (void)viewWillAppear:(BOOL)animated{
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setRestaurantCorrectionCompleted:)
                                                 name:@"set_restaurant_correction"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - ButtonClicked
- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendRestaurantCorrectionButtonClicked:(id)sender{
    // Check for missing resource
    UITextView * textView = [[_cells objectForKey:@"textView"] textView];
    if([[textView text] isEqualToString:@""] || [[textView text] isEqualToString:TEXT_VIEW_PLACEHOLDER]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"수정사항을 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSMutableString * correction = [[NSMutableString alloc] initWithString:@""];
    for(int i=0;i<=4; i++){
        RestaurantCorrectionCell * cell = [_cells objectForKey:[NSString stringWithFormat:@"cell%d",i]];
        if(cell.isSelected){
            [correction appendString:cell.titleLabel.text];
            [correction appendString:@"\n"];
        }
    }
    
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_restaurant_correction:_restaurant.serverID majorCorrection:correction details:textView.text];
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"restaurant_correction" label:@""];
}

# pragma mark - Notification
- (void)setRestaurantCorrectionCompleted:(NSNotification *) note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] != 200){
        // 실패
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"수정사항 전송에 실패하였습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        // 성공
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"소중한 정보 감사합니다" message:@"" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
# pragma mark - TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 5;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 52;
    }else{
        return 150;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        RestaurantCorrectionCell * section = (RestaurantCorrectionCell *)[[NSBundle mainBundle] loadNibNamed:@"RestaurantCorrectionCell" owner:nil options:nil][2];
        [section.sectionImageView setImage:[UIImage imageNamed:@"Icon_small_add_pen"]];
        section.sectionTitleLabel.text = @"자세한 수정사항을 적어주세요";
        return section;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RestaurantCorrectionCell * cell = (RestaurantCorrectionCell *)[[NSBundle mainBundle] loadNibNamed:@"RestaurantCorrectionCell" owner:nil options:nil][0];

        cell.titleLabel.text = [_titles objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_cells setObject:cell forKey:[NSString stringWithFormat:@"cell%d", indexPath.row]];
        return cell;
    }else{
        RestaurantCorrectionCell * cell = (RestaurantCorrectionCell *)[[NSBundle mainBundle] loadNibNamed:@"RestaurantCorrectionCell" owner:nil options:nil][1];

        cell.textView.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _textView = cell.textView;
        // Set placeholder
        _textView.text = TEXT_VIEW_PLACEHOLDER;
        _textView.textColor = [UIColor lightGrayColor];
        [_cells setObject:cell forKey:@"textView"];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1) return;
    
    RestaurantCorrectionCell * cell = (RestaurantCorrectionCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    if(cell.isSelected){
        [cell.imageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_selected"]];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"Icon_list_bar_check_box_normal"]];
    }
}


#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    // Set placeholder
    if ([textView.text isEqualToString:TEXT_VIEW_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    // move table view up
    [self moveTableViewUp];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    // Set placeholder
    if ([textView.text isEqualToString:@""]) {
        textView.text = TEXT_VIEW_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    // move table view down
    [self moveTableViewDown];
}

# pragma mark - Move Table View Up and Down

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)moveTableViewUp{
    // Disable Touch
    for(int i=0;i<=4; i++){
        RestaurantCorrectionCell * cell = [_cells objectForKey:[NSString stringWithFormat:@"cell%d",i]];
        cell.userInteractionEnabled = NO;
    }
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect tableViewFrame = _tableView.frame;
    CGRect requestButtonFrame = _footerView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        tableViewFrame.origin.y -= 270;
        requestButtonFrame.origin.y -= 270;
    }
    else{
        tableViewFrame.origin.y -= 270;
        requestButtonFrame.origin.y -= 270;
    }
    
    // Apply new size of table view
    _tableView.frame = tableViewFrame;
    _footerView.frame = requestButtonFrame;
    [UIView commitAnimations];

}

- (void)moveTableViewDown{

    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect tableViewFrame = _tableView.frame;
    CGRect requestButtonFrame = _footerView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        tableViewFrame.origin.y += 270;
        requestButtonFrame.origin.y += 270;
    }
    else{
        tableViewFrame.origin.y += 270;
        requestButtonFrame.origin.y += 270;
    }
    
    // Apply new size of table view
    _tableView.frame = tableViewFrame;
    _footerView.frame = requestButtonFrame;
    [UIView commitAnimations];
    
    
    // Enable Touch
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for(int i=0;i<=4; i++){
            RestaurantCorrectionCell * cell = [_cells objectForKey:[NSString stringWithFormat:@"cell%d",i]];
            cell.userInteractionEnabled = YES;
        }
    });

}

@end
