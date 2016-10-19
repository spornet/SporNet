//
//  SNChatViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNChatViewController.h"
#import "ChatCell.h"
#import "SNChatModelFrame.h"
#import "MessageManager.h"
@interface SNChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *frameArr;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet UILabel *talkToLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBoxBottomConstraint;

@end

@implementation SNChatViewController

- (NSMutableArray *)frameArr {
    
    if (_frameArr == nil) {
        
        _frameArr = [NSMutableArray array];
    }
    
    return _frameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    AVObject *myself;
    if ([self.conversation.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.friendBasicInfo];
    } else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.myInfo];
    }
    
    [myself fetch];
    self.talkToLabel.text = [myself objectForKey:@"name"];

    self.messages = [[self.conversation.conversation queryMessagesFromCacheWithLimit:100] mutableCopy];
    for(AVIMMessage *message in self.messages) {
        SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
        frame.chat = message;
        [self.frameArr addObject:frame];
    }
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self scrollToBottom];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MessageManager defaultManager].myClient.delegate = self;
}
-(void)keyboardWillChange:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if([self.messageInputTextView isFirstResponder]) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.toolBoxBottomConstraint.constant = keyboardSize.height;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:[self.view viewWithTag:1]];
    }

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    AVObject *myself;
    if ([self.conversation.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.friendBasicInfo];
    } else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.myInfo];
    }
    
    [myself fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        if(indexPath.row == 0) [cell configureCellWithMessage:_messages[0] previousMessage:nil receiver:object loadingStatus:[self.frameArr[indexPath.row] alreadySent]];
        else [cell configureCellWithMessage:_messages[indexPath.row] previousMessage:_messages[indexPath.row - 1] receiver:object loadingStatus:[self.frameArr[indexPath.row] alreadySent]];
    }];
    
    
    return cell;
}

-(void)tableViewTapped {
    [self dismissKeyboard];
}
//dismiss keyboard with animation
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.toolBoxBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.frameArr[indexPath.row] cellH];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [self sendMessageWithMessage:_messageInputTextView.text];
        return NO;
    }
    return YES;
}

-(void)sendMessageWithMessage:(NSString*)message {
    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:message attributes:nil];
    [self.messages addObject:textMessage];
    
    SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
    frame.chat = textMessage;
    frame.alreadySent = NO;
    [_frameArr addObject:frame];
    [self.tableView reloadData];
    [self scrollToBottom];
    self.messageInputTextView.text = @"";
    
    [self.conversation.conversation sendMessage:textMessage progressBlock:^(NSInteger percentDone) {
        
    } callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            // 此时聊天服务不可用。
            NSLog(@"聊天不可用");
            [ProgressHUD showError:@"聊天不可用"];
        }
        else{
            frame.alreadySent = YES;
//            [self.tableView reloadData];
            
        }

    }];
    
    if ([self.delegate respondsToSelector:@selector(didSendMessage)]) {
        
        [self.delegate didSendMessage];
    }

}

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [self.messages addObject:message];
    SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
    frame.chat = message;
    [_frameArr addObject:frame];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    if (!self.messages.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow: self.messages.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
@end
