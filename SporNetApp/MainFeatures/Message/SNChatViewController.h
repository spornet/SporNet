//
//  SNChatViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@protocol SNChatViewControllerDelegate <NSObject>

@optional

- (void)didSendMessage;

@end

@interface SNChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVIMClientDelegate>
@property (nonatomic, assign)id <SNChatViewControllerDelegate>delegate; 
@property(strong) Conversation *conversation;
@end
