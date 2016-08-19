//
//  SNChatViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNChatViewController.h"
#import "SNMessageViewCell.h"
#import "ChatCell.h"
#import "SNChatModelFrame.h"
#import "MessageManager.h"
@interface SNChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray *messages;
@property NSMutableArray *frameArr;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet UILabel *talkToLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBoxBottomConstraint;

@end

@implementation SNChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.talkToLabel.text = [_conversation.basicInfo objectForKey:@"name"];
    _frameArr = [[NSMutableArray alloc]init];
    self.messages = [[self.conversation.conversation queryMessagesFromCacheWithLimit:100] mutableCopy];
    for(AVIMMessage *message in self.messages) {
        SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
        frame.chat = message;
        [_frameArr addObject:frame];
    }
    
    //set message manager delegate
    [MessageManager defaultManager].client.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}
-(void)keyboardWillChange:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if([self.messageInputTextView isFirstResponder]) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.toolBoxBottomConstraint.constant = keyboardSize.height;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"get cell");
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    if(indexPath.row == 0) [cell configureCellWithMessage:_messages[0] previousMessage:nil receiver:_conversation.basicInfo];
    else [cell configureCellWithMessage:_messages[indexPath.row] previousMessage:_messages[indexPath.row - 1] receiver:_conversation.basicInfo];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrolllinggggg!");
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
    NSLog(@"get height");
    NSLog(@"%f", [self.frameArr[indexPath.row] cellH]);
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

    [self.conversation.conversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
        if (error) {
            // 此时聊天服务不可用。
            NSLog(@"聊天不可用");
            [ProgressHUD showError:@"聊天不可用"];
        }
        else{
            [self.messages addObject:textMessage];
            SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
            frame.chat = textMessage;
            [_frameArr addObject:frame];
            [self.tableView reloadData];
            NSLog(@"发送成功");
            self.messageInputTextView.text = @"";
            [ProgressHUD showSuccess:@"发送成功"];
            [self dismissKeyboard];
        }
    }];
}
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    NSLog(@"笑死我了");
}
@end
