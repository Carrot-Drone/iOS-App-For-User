//
//  UserRequestViewController.m
//  
//
//  Created by Sukwon Choi on 8/7/15.
//
//

#import "UserRequestViewController.h"
#import "UserRequestTableViewCell.h"

#import "Constants.h"
#import "ServerHelper.h"
#import "StaticHelper.h"

#import "CustomTitleView.h"
#import "CustomTableViewSection.h"

#define TEXT_VIEW_PLACEHOLDER @"문의사항을 적어주세요"

@interface UserRequestViewController (){

    UITextField * _emailTextField;
    UITextView * _requestTextView;
}

@end

@implementation UserRequestViewController
@synthesize tableView=_tableView;
@synthesize footerView=_footerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init TableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // dismiss Keyboard by tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // init requestButton
    [_footerView.button addTarget:self action:@selector(requestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView.button setTitle:@"문의하기" forState:UIControlStateNormal];
    
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
    [customTitleView.titleLabel setText:@"더 보기"];
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

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUserRequestCompleted:)
                                                 name:@"set_user_request"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    // Remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Button Clicked
- (void)requestButtonClicked:(id)sender{
    // Check for missing resource
    if(_emailTextField == nil || [_emailTextField.text isEqual:@""]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"이메일 주소를 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if(![_emailTextField.text containsString:@"@"]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"사용 가능한 이메일 주소를 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if(_requestTextView == nil || [_requestTextView.text isEqual:@""] || [_requestTextView.text  isEqual:TEXT_VIEW_PLACEHOLDER]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"문의사항을 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_user_request:_emailTextField.text details:_requestTextView.text];
    
    
    // GA
    [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"user_request" label:@""];
}
- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Notification
- (void)setUserRequestCompleted:(NSNotification *) note{
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] != 200){
        // 실패
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"문의내역 전송에 실패하였습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        // 성공
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"소중한 의견 감사합니다" message:@"" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomTableViewSection * sectionView = (CustomTableViewSection *)[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewSection" owner:nil options:nil][0];
    
    if(section == 0){
        [sectionView.titleLabel setText:@"문의하시는 분 이메일"];
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_email"]];
    }else {
        [sectionView.titleLabel setText:@"문의사항을 적어주세요"];
        [[sectionView imageView] setImage:[UIImage imageNamed:@"Icon_small_add_pen"]];
    }
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserRequestTableViewCell * cell;
    
    if(indexPath.section == 0){
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserRequestTableViewCell" owner:nil options:nil][1];
        cell.emailTextField.delegate = self;
        _emailTextField = cell.emailTextField;

    }else{
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserRequestTableViewCell" owner:nil options:nil][2];
        cell.requestTextView.delegate = self;
        _requestTextView = cell.requestTextView;
        // Set placeholder
        _requestTextView.text = TEXT_VIEW_PLACEHOLDER;
        _requestTextView.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

#pragma mark - TextField Delegate
// To be link with your TextField event "Editing Did Begin"
//  memoryze the current TextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

// To be link with your TextField event "Editing Did End"
//  release current TextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
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
- (void)moveTableViewUp{
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
        tableViewFrame.origin.y -= 120;
        requestButtonFrame.origin.y -= 120;
    }
    else{
        tableViewFrame.origin.y -= 120;
        requestButtonFrame.origin.y -= 120;
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
        tableViewFrame.origin.y += 120;
        requestButtonFrame.origin.y += 120;
    }
    else{
        tableViewFrame.origin.y += 120;
        requestButtonFrame.origin.y += 120;
    }
    
    // Apply new size of table view
    _tableView.frame = tableViewFrame;
    _footerView.frame = requestButtonFrame;
    [UIView commitAnimations];
    
}

@end
