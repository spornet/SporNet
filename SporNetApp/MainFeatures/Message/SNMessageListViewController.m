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
/**
 *  Message List TableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  Notification Button
 */
@property (weak, nonatomic) IBOutlet UIButton *bellButton;
/**
 *  Badge View on the Notification Button
 */
@property (weak, nonatomic) IBOutlet UIView *bellBadgeView;
/**
 *  Contains all Current User's Converstaion Model
 */
@property (nonatomic, strong) NSMutableArray *conversationList;


@end

@implementation SNMessageListViewController

#pragma mark - Lazy Load

- (NSMutableArray *)conversationList {
    
    if (_conversationList == nil) {
        
        _conversationList = [NSMutableArray array];
    }
    
    return _conversationList;
}

#pragma mark - View Delegate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //Load Cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    
    //Open Current Message
    
    [[MessageManager defaultManager] startMessageService];
    [MessageManager defaultManager].client.delegate = self;
    [MessageManager defaultManager].delegate = self;
    //set badge view of notification icon (the bell)
    self.bellBadgeView.layer.masksToBounds = YES;
    self.bellBadgeView.layer.cornerRadius = self.bellBadgeView.frame.size.width / 2.0;
    self.bellBadgeView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [MessageManager defaultManager].client.delegate = self;
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES; 
}

-(void)didFinishRefreshing {
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    [self.tableView reloadData];
    [ProgressHUD dismiss];
}

#pragma mark - UITableView Delegate


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

#pragma mark - IMClient Delegate

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    if([message.text isEqualToString:@"Lets Play Sport Together"]) {
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

#pragma mark - Private Methods

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
