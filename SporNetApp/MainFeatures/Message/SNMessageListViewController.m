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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageListCell" forIndexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

@end
