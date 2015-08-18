//
//  RSCustomView.h
//  
//
//  Created by Sukwon Choi on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface RSTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel * subLabel;
@property (nonatomic, strong) IBOutlet UILabel * mainLabel1;
@property (nonatomic, strong) IBOutlet UILabel * mainLabel2;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;
@property (nonatomic, strong) IBOutlet UIButton * suggestionButton;

@end
