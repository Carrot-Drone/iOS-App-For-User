//
//  AboutViewController.h
//  
//
//  Created by Sukwon Choi on 8/4/15.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@end
