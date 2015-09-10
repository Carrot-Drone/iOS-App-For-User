//
//  RestaurantSuggestionViewController.m
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import "RestaurantSuggestionDetailViewController.h"
#import "RestaurantSuggestionSectionView.h"
#import "SelectCampusViewController.h"

#import "RSDCampusTableViewCell.h"
#import "RSDTextFieldTableViewCell.h"
#import "RSDPhoneNumberTableViewCell.h"
#import "RSDFlyerTableViewCell.h"
#import "CustomTableViewFooter.h"
#import "CustomTitleView.h"

#import "Constants.h"
#import "StaticHelper.h"
#import "ServerHelper.h"

#import "NSString+PHONENUMBERCategories.h"


#define TF_RESTAURANT_NAME  1
#define TF_PHONE_NUMBER     2
#define TF_OFFICE_HOURS     3

#define FLYER1       4
#define FLYER2       5
#define FLYER3       6
#define FLYER4       7

#define FLYER_BUTTON1       8
#define FLYER_BUTTON2       9
#define FLYER_BUTTON3       10
#define FLYER_BUTTON4       11

#define FLYER_DELETE_BUTTON1       12
#define FLYER_DELETE_BUTTON2       13
#define FLYER_DELETE_BUTTON3       14
#define FLYER_DELETE_BUTTON4       15

@interface RestaurantSuggestionDetailViewController (){
    NSArray * _sectionTitles;
    BOOL _isByUser;
    
    UITextField * _currentTextField;
    
    NSString * _restaurantName;
    NSString * _restaurantPhoneNumber;
    NSString * _restaurantOfficeHours;
    NSMutableArray * _images;
    
    UIImageView * _selected_flyer;
    
    RSDFlyerTableViewCell * _flyerCell;
}


@end

@implementation RestaurantSuggestionDetailViewController
@synthesize activityIndicator=_activityIndicator;
@synthesize tableView=_tableView;

@synthesize footer=_footer;

@synthesize campus=_campus;

- (void)setDetailItem:(BOOL)isByUser{
    _isByUser = isByUser;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init ActivityIndicator
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];

    
    // init TableView
    //_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    _tableView.backgroundColor = [UIColor whiteColor];
    
    // init Footer
    [_footer.button addTarget:self action:@selector(suggestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(_isByUser){
        [_footer.button setTitle:@"제보하기" forState:UIControlStateNormal];
    }else{
        [_footer.button setTitle:@"등록하기" forState:UIControlStateNormal];
    }
    
    // init TitleView
    [self initNavigationController];
    
    
    // dismiss Keyboard by tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
    
    // init CampusName
    _campus = [[StaticHelper staticHelper] campus];
    
    // init images
    _images = [[NSMutableArray alloc] init];
    
    // init sectionTitles
    if(_isByUser){
        NSArray * array1 = [[NSArray alloc] initWithObjects:@"캠퍼스", @"", @"* 필수", nil];
        NSArray * array2 = [[NSArray alloc] initWithObjects:@"음식점 이름", @"", @"* 필수", nil];
        NSArray * array3 = [[NSArray alloc] initWithObjects:@"음식점 전화번호", @"", @"", nil];
        NSArray * array4 = [[NSArray alloc] initWithObjects:@"전단지", @" (스캔 이미지일 경우 제일 좋습니다)", @"", nil];
        
        _sectionTitles = [[NSArray alloc] initWithObjects:array1, array2, array3, array4, nil];
        
    }else{
        NSArray * array1 = [[NSArray alloc] initWithObjects:@"캠퍼스", @"", @"* 필수", nil];
        NSArray * array2 = [[NSArray alloc] initWithObjects:@"음식점 이름", @"", @"* 필수", nil];
        NSArray * array3 = [[NSArray alloc] initWithObjects:@"음식점 전화번호", @"", @"* 필수", nil];
        NSArray * array4 = [[NSArray alloc] initWithObjects:@"영업시간", @"", @"* 필수", nil];
        NSArray * array5 = [[NSArray alloc] initWithObjects:@"전단지", @" (스캔 이미지일 경우 제일 좋습니다)", @"* 필수", nil];
        
        _sectionTitles = [[NSArray alloc] initWithObjects:array1, array2, array3, array4, array5, nil];
    }
    // init RightBarButton
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

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    // Register notification when restaurant suggestion is completed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setRestaurantSuggestionComplete:)
                                                 name:@"set_restaurant_suggestion"
                                               object:nil];

    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
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

# pragma mark -Button Clicked
- (IBAction)cancelButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)flyerButtonClicked:(UIButton *)sender{
    if(sender.tag == FLYER_BUTTON1){
        _selected_flyer = _flyerCell.imageView1;
    }else if(sender.tag == FLYER_BUTTON2){
        _selected_flyer = _flyerCell.imageView2;
    }else if(sender.tag == FLYER_BUTTON3){
        _selected_flyer = _flyerCell.imageView3;
    }else if(sender.tag == FLYER_BUTTON4){
        _selected_flyer = _flyerCell.imageView4;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.navigationBar.tintColor = [UIColor blueColor];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)deleteFlyerButtonClicked:(UIButton *)sender{
    if(sender.tag == FLYER_DELETE_BUTTON1){
        [_flyerCell.deleteButton1 setHidden:YES];
        [_images removeObject:_flyerCell.imageView1.image];
        [_flyerCell.imageView1 setImage:nil];
        [_flyerCell.smallImageView1 setHidden:NO];
        [_flyerCell.button1 setHidden:NO];
        [_flyerCell.button1 setUserInteractionEnabled:YES];
    }else if(sender.tag == FLYER_DELETE_BUTTON2){
        [_flyerCell.deleteButton2 setHidden:YES];
        [_images removeObject:_flyerCell.imageView2.image];
        [_flyerCell.imageView2 setImage:nil];
        [_flyerCell.smallImageView2 setHidden:NO];
        [_flyerCell.button2 setHidden:NO];
        [_flyerCell.button2 setUserInteractionEnabled:YES];
    }else if(sender.tag == FLYER_DELETE_BUTTON3){
        [_flyerCell.deleteButton3 setHidden:YES];
        [_images removeObject:_flyerCell.imageView3.image];
        [_flyerCell.imageView3 setImage:nil];
        [_flyerCell.smallImageView3 setHidden:NO];
        [_flyerCell.button3 setHidden:NO];
        [_flyerCell.button3 setUserInteractionEnabled:YES];
    }else if(sender.tag == FLYER_DELETE_BUTTON4){
        [_flyerCell.deleteButton4 setHidden:YES];
        [_images removeObject:_flyerCell.imageView4.image];
        [_flyerCell.imageView4 setImage:nil];
        [_flyerCell.smallImageView4 setHidden:NO];
        [_flyerCell.button4 setHidden:NO];
        [_flyerCell.button4 setUserInteractionEnabled:YES];
    }
}
- (void)suggestButtonClicked:(id)sender{
    // Check for missing resource
    if(_campus == nil){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"캠퍼스를 선택해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if(_restaurantName == nil || [_restaurantName isEqual:@""]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"음식점 이름을 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if((!_isByUser) && (_restaurantPhoneNumber == nil || [_restaurantPhoneNumber isEqual:@""])){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"음식점 전화번호를 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if((!_isByUser) && (_restaurantOfficeHours == nil || [_restaurantOfficeHours isEqual:@""])){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"음식점 영업시간을 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if((!_isByUser) && (_images == nil || [_images count]==0)){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"전단지 이미지를 입력해주세요" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    [_tableView setUserInteractionEnabled:NO];
    
    ServerHelper * serverHelper = [[ServerHelper alloc] init];
    [serverHelper set_restaurant_suggestion:[_campus serverID] name:_restaurantName phoneNumber:_restaurantPhoneNumber officeHours:_restaurantOfficeHours isSuggestedByRestaurant:!_isByUser images:_images];
    
    // GA
    if(_isByUser){
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"restaurant_suggestion_by_user" label:@""];
    }else{
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"restaurant_suggestion_by_restaurant" label:@""];
    }
    [self performSegueWithIdentifier:@"RestaurantSuggestionCompleteViewController" sender:self];
    
}


# pragma mark - TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == [_sectionTitles count]-1){
        //return 80;
        return 0;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RestaurantSuggestionSectionView * rssv = [[NSBundle mainBundle] loadNibNamed:@"RestaurantSuggestionSectionView" owner:nil options:nil][0];

    rssv.titleLabel.text = [[_sectionTitles objectAtIndex:section] objectAtIndex:0];
    rssv.detailLabel.text = [[_sectionTitles objectAtIndex:section] objectAtIndex:1];
    rssv.mendatoryLabel.text = [[_sectionTitles objectAtIndex:section] objectAtIndex:2];
    if(section == 0){
        rssv.imageView.image = [UIImage imageNamed:@"Icon_small_add_campus"];
    }else if(section == 1){
        rssv.imageView.image = [UIImage imageNamed:@"Icon_small_add_store"];
    }else if(section == 2){
        rssv.imageView.image = [UIImage imageNamed:@"Icon_small_add_call"];
    }else if(section == 3 && !_isByUser){
        rssv.imageView.image = [UIImage imageNamed:@"Icon_small_add_time"];
    }else{
        rssv.imageView.image = [UIImage imageNamed:@"Icon_small_add_advertisement_flyer"];
    }
    return rssv;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // if Last Section
    if(section == [_sectionTitles count]-1){
        return nil;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RSDCampusTableViewCell * cell = (RSDCampusTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomRSDTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [_campus nameKor];
        cell.backgroundColor = TAB_BAR_BG_COLOR;
        return cell;
    }else if(indexPath.section == 1){
        RSDTextFieldTableViewCell * cell = (RSDTextFieldTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomRSDTableViewCell" owner:nil options:nil][1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TAB_BAR_BG_COLOR;
        cell.textField.tag = TF_RESTAURANT_NAME;
        cell.textField.delegate = self;
        return cell;
    }else if(indexPath.section == 2){
        RSDTextFieldTableViewCell * cell = (RSDTextFieldTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomRSDTableViewCell" owner:nil options:nil][1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TAB_BAR_BG_COLOR;
        cell.textField.tag = TF_PHONE_NUMBER;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.delegate = self;
        return cell;
    }else if(indexPath.section == 3 && !_isByUser){
        RSDTextFieldTableViewCell * cell = (RSDTextFieldTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomRSDTableViewCell" owner:nil options:nil][1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TAB_BAR_BG_COLOR;
        cell.textField.tag = TF_OFFICE_HOURS;
        cell.textField.delegate = self;
        return cell;
    }else{
        RSDFlyerTableViewCell * cell = (RSDFlyerTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"CustomRSDTableViewCell" owner:nil options:nil][2];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.backgroundColor = TAB_BAR_BG_COLOR;
        
        cell.imageView1.tag = FLYER1;
        cell.imageView2.tag = FLYER2;
        cell.imageView3.tag = FLYER3;
        cell.imageView4.tag = FLYER4;
        
        cell.button1.tag = FLYER_BUTTON1;
        cell.button2.tag = FLYER_BUTTON2;
        cell.button3.tag = FLYER_BUTTON3;
        cell.button4.tag = FLYER_BUTTON4;
        
        cell.deleteButton1.tag = FLYER_DELETE_BUTTON1;
        cell.deleteButton2.tag = FLYER_DELETE_BUTTON2;
        cell.deleteButton3.tag = FLYER_DELETE_BUTTON3;
        cell.deleteButton4.tag = FLYER_DELETE_BUTTON4;
        
        [cell.button1 addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(flyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.deleteButton1 addTarget:self action:@selector(deleteFlyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteButton2 addTarget:self action:@selector(deleteFlyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteButton3 addTarget:self action:@selector(deleteFlyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteButton4 addTarget:self action:@selector(deleteFlyerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _flyerCell = cell;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"SelectCampusViewController" sender:self];
        
        // GA
        [ServerHelper sendGoogleAnalyticsEvent:@"UX" action:@"select_campus_in_restaurant_suggestion" label:@""];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3 && _isByUser){
        return 100;
    }else if(indexPath.section == 4 && !_isByUser){
        return 100;
    }else{
        return 51;
    }
}

#pragma mark - Image Resize
- (UIImage *)resizeImage:(UIImage *)captureImage ToSize:(CGSize)targetSize
{
    UIImage *sourceImage = captureImage;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}


#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    CGFloat scaleSize = 1;
    while(1){
        NSData* data = UIImageJPEGRepresentation(image, 0.0);
        if(data.length <= 100*1024 || scaleSize <= 0.1){
            NSLog(@"%ldKB", data.length / 1024);
            break;
        }
        scaleSize = pow(data.length/100.0*1024.0, 1/2)*0.9;
        // Compress data
        image = [self resizeImage:image ToSize:CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize)];
    }
    
    [_images addObject:image];
    [_selected_flyer setImage:image];
    [_selected_flyer setContentMode:UIViewContentModeScaleAspectFill];
    [_selected_flyer setClipsToBounds:YES];
    
    if(_selected_flyer.tag == FLYER1){
        [_flyerCell.deleteButton1 setHidden:NO];
        [_flyerCell.deleteButton1 setUserInteractionEnabled:YES];
        [_flyerCell.smallImageView1 setHidden:YES];
        [_flyerCell.button1 setHidden:YES];
    }
    if(_selected_flyer.tag == FLYER2){
        [_flyerCell.deleteButton2 setHidden:NO];
        [_flyerCell.deleteButton2 setUserInteractionEnabled:YES];
        [_flyerCell.smallImageView2 setHidden:YES];
        [_flyerCell.button2 setHidden:YES];
    }
    if(_selected_flyer.tag == FLYER3){
        [_flyerCell.deleteButton3 setHidden:NO];
        [_flyerCell.deleteButton3 setUserInteractionEnabled:YES];
        [_flyerCell.smallImageView3 setHidden:YES];
        [_flyerCell.button3 setHidden:YES];
    }
    if(_selected_flyer.tag == FLYER4){
        [_flyerCell.deleteButton4 setHidden:NO];
        [_flyerCell.deleteButton4 setUserInteractionEnabled:YES];
        [_flyerCell.smallImageView4 setHidden:YES];
        [_flyerCell.button4 setHidden:YES];
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        navigationController.navigationBar.barTintColor = MAIN_COLOR;
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

#pragma mark -TextField Delegate
// To be link with your TextField event "Editing Did Begin"
//  memoryze the current TextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
}

// To be link with your TextField event "Editing Did End"
//  release current TextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _currentTextField = nil;
    
    if(textField.tag == TF_RESTAURANT_NAME){
        _restaurantName = textField.text;
    }else if(textField.tag == TF_PHONE_NUMBER){
        _restaurantPhoneNumber = textField.text;
    }else if(textField.tag == TF_OFFICE_HOURS){
        _restaurantOfficeHours = textField.text;
    }
}
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
    }
    if(textField.tag == TF_PHONE_NUMBER){
        if (range.length <= 0)
        {
            // Inserting
            textField.text = [NSString phoneNumberFormattedString:textField.text];
        }
    }
    
    return YES;
}

#pragma mark -Prepare Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"RestaurantSuggestionCompleteViewController"]){
        [[segue destinationViewController] setDetailItem:_isByUser];
    }else if([segue.identifier isEqualToString:@"SelectCampusViewController"]){
        [(SelectCampusViewController *)[[segue destinationViewController] topViewController] setDetailItem:true];
    }
}

#pragma mark - Notification

-(void)setRestaurantSuggestionComplete:(NSNotification *)note{
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
    [_tableView setUserInteractionEnabled:YES];
    
    NSDictionary * json = [note userInfo];
    if([[json objectForKey:@"response"] statusCode] != 200){
        if(_isByUser){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"제보에 실패했습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"등록에 실패했습니다" message:@"잠시 후 다시 시도해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}

#pragma mark - Keyboard Notification

-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = _tableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    _tableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    if (_currentTextField)
    {
        CGRect textFieldRect = [_tableView convertRect:_currentTextField.bounds fromView:_currentTextField];
        [_tableView scrollRectToVisible:textFieldRect animated:NO];
    }
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = _tableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    _tableView.frame = frame;
    
    [UIView commitAnimations];
}

@end
