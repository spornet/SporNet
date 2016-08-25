//
//  SNFriendRequestListViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNFriendRequestListViewController.h"
#import "SNFriendRequestCell.h"
@interface SNFriendRequestListViewController ()
@property NSMutableArray *currentFriendRequstList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation SNFriendRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"SNFriendRequestCell" bundle:nil] forCellReuseIdentifier:@"SNFriendRequestCell"];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    //return self.currentFriendRequstList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNFriendRequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SNFriendRequestCell" forIndexPath:indexPath];
//    [cell configureCellWithConversation:self.currentFriendRequstList[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
@end
