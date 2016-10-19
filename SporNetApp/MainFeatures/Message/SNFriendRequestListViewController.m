//
//  SNFriendRequestListViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNFriendRequestListViewController.h"
#import "SNFriendRequestCell.h"
#import "SNSearchNearbyProfileViewController.h"
#import "SNUser.h"
@interface SNFriendRequestListViewController ()
@property NSMutableArray *currentFriendRequstList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation SNFriendRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"SNFriendRequestCell" bundle:nil] forCellReuseIdentifier:@"SNFriendRequestCell"];

    self.currentFriendRequstList = [[MessageManager defaultManager]fetchAllCurrentFriendRequests];
    [MessageManager defaultManager].delegate = self;
    [MessageManager defaultManager].myClient.delegate = self;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.currentFriendRequstList == 0) {
        
        [[MessageManager defaultManager] refreshAllFriendRequest];
    }
    
}

- (void)didFinishRefreshing {
    
    self.currentFriendRequstList = [[MessageManager defaultManager]fetchAllCurrentFriendRequests];
    
    [self.tableView reloadData]; 

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentFriendRequstList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNFriendRequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SNFriendRequestCell" forIndexPath:indexPath];

    [cell configureCellWithConversation:self.currentFriendRequstList[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    Conversation *c = self.currentFriendRequstList[indexPath.row];
    
    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    [user fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        vc.currentUserProfile = (SNUser *)object;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Message Manager Delegate

-(void)didAcceptFriendRequest {
    self.currentFriendRequstList = [[MessageManager defaultManager]fetchAllCurrentFriendRequests];
    [self.tableView reloadData];
}

//#pragma mark - UIClient Delegate
//-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
//    if([message.text isEqualToString:@"Lets Play Sport Together"]) {
//        NSLog(@"收到一条好友请求");
//        AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:conversation.creator];
//        [user fetch];
//        
//        Conversation *c = [[Conversation alloc]init];
//        c.basicInfo = user;
//        c.conversation = conversation;
//        
//        [self.currentFriendRequstList addObject:c];
//        [self.tableView reloadData];
//        
//    }
//}
@end
