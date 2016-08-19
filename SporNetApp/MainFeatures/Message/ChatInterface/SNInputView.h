//
//  SNInputView.h
//  Messaging
//
//  Created by Peng on 8/16/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNInputViewDelegate <NSObject>

@optional

- (void)viewMessageContentDidClick:(NSString *)message;

@end

@interface SNInputView : UIView
@property (weak, nonatomic) IBOutlet UITextField *messageContentField;

@property (nonatomic, weak)id<SNInputViewDelegate> delegate;

+ (instancetype)viewWithNib; 

@end
