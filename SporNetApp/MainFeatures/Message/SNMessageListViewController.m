//
//  SNMessageListViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMessageListViewController.h"
#import "MessageListCell.h"

#import "ProgressHUD.h"
#import "SNChatViewController.h"
#import "SNFriendRequestListViewController.h"
@interface SNMessageListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *conversationList;

@end

@implementation SNMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"Loading your message box..."];
    self.navigationController.navigationBar.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    //打开message功能
    [[MessageManager defaultManager] startMessageService];
    [MessageManager defaultManager].client.delegate = self;
    [MessageManager defaultManager].delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [MessageManager defaultManager].client.delegate = self;
    //[[MessageManager defaultManager]refreshAllConversations];
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    [_tableView reloadData];
}
-(void)didFinishRefreshing {
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    [_tableView reloadData];
    [ProgressHUD dismiss];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationList.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageListCell" forIndexPath:indexPath];
    [cell configureCellWithConversation:self.conversationList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Conversation *c = _conversationList[indexPath.row];
    SNChatViewController *vc = [[SNChatViewController alloc]init];
    vc.conversation = c;
    c.unreadMessageNumber = 0;

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    NSLog(@"RECEIVED");
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    for(Conversation *c in self.conversationList) {

        if([c.conversation.conversationId isEqualToString:message.conversationId]) {
            c.unreadMessageNumber++;
            break;
        }
    }
    [self.tableView reloadData];
}
-(void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    NSLog(@"UNREAD");
}
- (IBAction)bellButtonClicked:(UIButton *)sender {
    SNFriendRequestListViewController *vc = [[SNFriendRequestListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
