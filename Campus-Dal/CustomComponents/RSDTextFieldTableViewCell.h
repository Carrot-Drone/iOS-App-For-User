//
//  RSTextFieldTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/6/15.
//
//

#import <UIKit/UIKit.h>

@interface RSDTextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField * textField;

@end
