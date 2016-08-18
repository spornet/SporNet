//
//  SNMessageListViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMessageListViewController.h"
#import "MessageListCell.h"
#import "MessageManager.h"

@interface SNMessageListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *conversationList;

@end

@implementation SNMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    
    //打开message功能
    [[MessageManager defaultManager] startMessageService];
    [MessageManager defaultManager].client.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated {
    self.conversationList = [[MessageManager defaultManager] fetchAllCurrentConversations];
    NSLog(@"len is %ld", self.conversationList.count);
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationList.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageListCell" forIndexPath:indexPath];
    //cell.userNameLabel.text = [[_conversationList[indexPath.row] members]objectAtIndex:1];
    cell.userNameLabel.text = [[_conversationList[indexPath.row] basicInfo] objectForKey:@"name"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

@end
