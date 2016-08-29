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
#import "SNContactViewController.h"
@interface SNMessageListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *conversationList;
@property (weak, nonatomic) IBOutlet UIButton *bellButton;
@property (weak, nonatomic) IBOutlet UIView *bellBadgeView;


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
    //set badge view of notification icon (the bell)
    self.bellBadgeView.layer.masksToBounds = YES;
    self.bellBadgeView.layer.cornerRadius = self.bellBadgeView.frame.size.width / 2.0;
    self.bellBadgeView.hidden = YES;
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
    if([message.text isEqualToString:@"I'd love to add you as my friend"]) {
        NSLog(@"收到一条好友请求");
        
        AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:conversation.creator];
        [user fetch];
        Conversation *c = [[Conversation alloc]init];
        c.basicInfo = user;
        c.conversation = conversation;
        
        [[[MessageManager defaultManager]fetchAllCurrentFriendRequests] addObject:c];
        self.bellBadgeView.hidden = NO;
    }
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
    self.bellBadgeView.hidden = YES;
}
- (IBAction)contactButtonClicked:(id)sender {
    SNContactViewController *vc = [[SNContactViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
