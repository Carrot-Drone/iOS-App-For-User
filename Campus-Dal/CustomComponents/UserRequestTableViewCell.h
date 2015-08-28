//
//  UserRequestTableViewCell.h
//  
//
//  Created by Sukwon Choi on 8/7/15.
//
//

#import <UIKit/UIKit.h>

@interface UserRequestTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView * sectionImage;
@property (nonatomic, strong) IBOutlet UILabel * sectionLabel;
@property (nonatomic, strong) IBOutlet UITextField * emailTextField;
@property (nonatomic, strong) IBOutlet UITextView * requestTextView;

@end
