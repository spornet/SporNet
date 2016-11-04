//
//  SNMessageListViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMessageListViewController.h"
#import "MessageListCell.h"
#import "ProgressHUD.h"
#import "SNChatViewController.h"
#import "SNFriendRequestListViewController.h"
#import "SNContactViewController.h"
#import "SNUser.h"

@interface SNMessageListViewController () <AVIMClientDelegate>
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

@property (nonatomic, assign) NSInteger badgeValue;

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
    [[MessageManager defaultManager] startMessageService];
    sleep(3);
    [MessageManager defaultManager].delegate = self;
    //Open Current Message

    //set badge view of notification icon (the bell)
    self.bellBadgeView.layer.masksToBounds = YES;
    self.bellBadgeView.layer.cornerRadius = self.bellBadgeView.frame.size.width / 2.0;
    self.bellBadgeView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [MessageManager defaultManager].myClient.delegate = self;

    self.conversationList = [[MessageManager defaultManager]fetchAllCurrentConversations];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES; 
}

#pragma marks - MessageManager Delegate

-(void)didFinishRefreshing {
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    [self.tableView reloadData];
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
    Conversation *c = self.conversationList[indexPath.row];
    SNChatViewController *vc = [[SNChatViewController alloc]init];
    vc.conversation = c;
    c.unreadMessageNumber = 0;
    
    self.badgeValue = 0;
    self.navigationController.tabBarItem.badgeValue = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IMClient Delegate

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(nonnull AVIMTypedMessage *)message{
    if([message.text isEqualToString:@"Lets Play Sport Together"]) {
        
        AVQuery *query1 = [SNUser query];
        [query1 whereKey:@"name" equalTo:conversation.creator];
        NSArray *queryArray1 = [query1 findObjects];
        SNUser *myself = queryArray1[0];
        
        AVQuery *query2 = [SNUser query];
        [query2 whereKey:@"name" equalTo:conversation.clientId];
        NSArray *queryArray2 = [query2 findObjects];
        SNUser *friend = queryArray2[0];
        
        Conversation *c = [[Conversation alloc]init];
        
        c.myInfo = myself.objectId;
        c.friendBasicInfo = friend.objectId;
        c.conversation = conversation;
        
        [[[MessageManager defaultManager]fetchAllCurrentFriendRequests] addObject:c];
        self.bellBadgeView.hidden = NO;
   
    }else if ([message.text isEqualToString:@"I've added you as my friend. Let's start to chat!"])
    {
        
        [[MessageManager defaultManager] refreshAllConversations];
        [self.tableView reloadData];

    }
        self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
        for(Conversation *c in self.conversationList) {
            
            if([c.conversation.conversationId isEqualToString:message.conversationId]) {
                c.unreadMessageNumber++;
                self.badgeValue++;
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.badgeValue];
                
                [self.tableView reloadData]; 
                break;
            }
        
        
    }
}


- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    
    NSLog(@"message unread %ld", unread);
    if (unread <= 0) {
        return;
    }
    [conversation queryMessagesFromServerWithLimit:unread callback:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        for (AVIMTypedMessage *message in objects) {
            
            if ([message.text isEqualToString:@"Lets Play Sport Together"]) {
                
                AVQuery *query1 = [SNUser query];
                [query1 whereKey:@"name" equalTo:conversation.creator];
                NSArray *queryArray1 = [query1 findObjects];
                SNUser *myself = queryArray1[0];
                
                AVQuery *query2 = [SNUser query];
                [query2 whereKey:@"name" equalTo:conversation.clientId];
                NSArray *queryArray2 = [query2 findObjects];
                SNUser *friend = queryArray2[0];
                
                Conversation *c = [[Conversation alloc]init];
                
                NSLog(@"myself id %@, myfriend id %@", myself.objectId, friend.objectId);
                
                c.myInfo = myself.objectId;
                c.friendBasicInfo = friend.objectId;
                c.conversation = conversation;
                
                [[[MessageManager defaultManager]fetchAllCurrentFriendRequests] addObject:c];
                self.bellBadgeView.hidden = NO;
                
            }else if ([message.text isEqualToString:@"I've added you as my friend. Let's start to chat!"])
            {
                
                [[MessageManager defaultManager] refreshAllConversations];
                [self.tableView reloadData];
                
            }
            
        }
        
    }];
    
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    for(Conversation *c in self.conversationList) {
        
        if([c.conversation.conversationId isEqualToString:conversation.conversationId]) {
            c.unreadMessageNumber+=unread;
            self.badgeValue+=unread;
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.badgeValue];
            [conversation queryMessagesFromServerWithLimit:unread callback:^(NSArray *objects, NSError *error) {
                if (!error && objects.count) {
                    
                    NSLog(@"objects %@", objects);
                }
            }];
            [self.tableView reloadData];
            break;
        }
        
    }
    [conversation markAsReadInBackground];
}

- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    NSLog(@"%@", @"消息已送达。"); // 打印消息
}

- (void)imClientResuming:(AVIMClient *)imClient {
    
    [[MessageManager defaultManager] startMessageService];
    
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
