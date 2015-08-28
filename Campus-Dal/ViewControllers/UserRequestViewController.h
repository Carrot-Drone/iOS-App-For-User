//
//  UserRequestViewController.h
//  
//
//  Created by Sukwon Choi on 8/7/15.
//
//

#import <UIKit/UIKit.h>
#import "CustomTableViewFooter.h"

@interface UserRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet CustomTableViewFooter * footerView;
- (IBAction)cancelButtonClicked:(id)sender;

@end
