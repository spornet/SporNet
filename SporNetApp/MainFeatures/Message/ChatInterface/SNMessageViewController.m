//
//  SNMessageViewController.m
//  Messaging
//
//  Created by Peng on 8/15/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMessageViewController.h"
#import "SNInputView.h"
#import "SNMessageViewCell.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width


@interface SNMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate >

/**
 *  Message Content TableView
 */
@property (nonatomic, weak) UITableView *messageContentTable;
/**
 *  InputView (UITextfield + SendButton)
 */
@property (nonatomic, weak) SNInputView *sn_inputView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation SNMessageViewController

#pragma marks - Lazy Load

- (UITableView *)messageContentTable {
    
    if (_messageContentTable == nil) {
        
        CGRect tableViewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        
        _messageContentTable = tableView;
    }
    
    return _messageContentTable;
}

- (SNInputView *)sn_inputView {
    
    if (_sn_inputView == nil) {
        
        SNInputView *inputView = [SNInputView viewWithNib];
        inputView.messageContentField.delegate = self;
        inputView.backgroundColor = [UIColor grayColor];
        inputView.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
        [self.view addSubview:inputView];
        
        _sn_inputView = inputView;
    }
    
    return _sn_inputView;
}

- (NSMutableArray *)modelArray {
    
    if (_modelArray == nil) {
        
        _modelArray = [NSMutableArray array];
        
    }
    
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add Subviews
    [self messageContentTable];
    [self sn_inputView];
    
    // Get All the Chatting History
    [self reloadAllChatMessages];
    
    // Change Keyboard Frame
    [self observeKeyboardChange];
    
    // Listening to the Conversation Delegate
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToBottom];
}

#pragma marks - UITableView Delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SNMessageViewCell *cell = [SNMessageViewCell cellWithTableView:tableView];
    SNChatModelFrame *modelFrame = self.modelArray[indexPath.row];
    
    cell.modelFrame = modelFrame;
    
    return cell;
}


#pragma marks - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Send Message
    
    // TextField set to nil
    
    textField.text = nil;
    
    // Reload All Messages
    
    [self reloadAllChatMessages];
    
    return YES;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

#pragma mark - UIScorllViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Private Methods
- (void)observeKeyboardChange
{
    [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue: [NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      //
                                                      NSLog(@"%s, line = %d,note =%@", __FUNCTION__, __LINE__, note);
                                                
                                                      CGFloat endY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
                                                      CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                      
                                                      CGFloat tempY = endY - self.view.bounds.size.height;
                                                      CGRect tempF = CGRectMake(0, tempY, self.view.bounds.size.width, self.view.bounds.size.height);
                                                      self.view.frame = tempF;
                                                      [UIView animateWithDuration:duration animations:^{
                                                          [self.view setNeedsLayout];
                                                      }];
                                                      
                                                      
                                                  }];
}

- (void)reloadAllChatMessages
{
    // 首先刷新的时候要移除已有的对象
    [self.modelArray removeAllObjects];
    
   

    // Add All history chat messages
    
    
    
    // 刷新表格
    [self.messageContentTable reloadData];
    
    // 滚到最下面
    [self scrollToBottom];
}

- (void)scrollToBottom
{
    if (!self.modelArray.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow: self.modelArray.count - 1 inSection:0];
    [self.messageContentTable scrollToRowAtIndexPath: lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end









