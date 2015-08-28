//
//  RestaurantSuggestionViewController.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>
#import "CustomTableViewFooter.h"
#import "Campus.h"

@interface RestaurantSuggestionDetailViewController: UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) IBOutlet CustomTableViewFooter * footer;

@property (nonatomic, strong) Campus * campus;

- (void)setDetailItem:(BOOL)isByUser;
- (IBAction)cancelButtonClicked:(id)sender;

// Keyboard
-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

// Restaurant Suggestion Complete
-(void) setRestaurantSuggestionComplete:(NSDictionary *)dic;


@end
