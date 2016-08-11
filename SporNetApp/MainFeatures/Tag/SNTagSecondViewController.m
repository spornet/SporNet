//
//  TagSecondViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNTagSecondViewController.h"
#import "TimeManager.h"
#import <AVUser.h>
#import <AVObject.h>
#import <AVQuery.h>
#import "SNTagCell.h"
#import <MJRefresh.h>
#import <DXPopover.h>
#import "ProgressHUD.h"
#import "SNUser.h"
#import "CheckInManager.h"
#import "SNSearchNearbyProfileViewController.h"
@interface SNTagSecondViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *allCheckIns;
@property (weak, nonatomic) IBOutlet UILabel *gymNameLabel;
@property (strong, nonatomic) IBOutlet UIView *popPanel;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property(strong) NSMutableArray *currentCheckins;
@property NSMutableArray *currentUserBasicInfos;
@end

@implementation SNTagSecondViewController
DXPopover *popover;
//NSMutableArray *currentCheckins;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"koukoukoukou");
    self.gymNameLabel.text = self.gymName;
    [_tableView registerNib:[UINib nibWithNibName:@"SNTagCell" bundle:nil] forCellReuseIdentifier:@"SNTagCell"];
    self.currentUserBasicInfos = [[NSMutableArray alloc]init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
    }];
    [self.tableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}
-(void)refresh {
    self.allCheckIns = [[CheckInManager defaultManager]refreshAndFetchAllCheckinsWithGymName:_gymName];
    self.currentCheckins = self.allCheckIns;
    [self fetchCurrentUserBasicInfoInBackground];
//    NSArray *unionOfObjects = [self.allCheckIns valueForKeyPath:@"@unionOfObjects.userID"];
//    for(NSString *str in unionOfObjects) NSLog(str);
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}

-(void)fetchCurrentUserBasicInfoInBackground {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.currentUserBasicInfos removeAllObjects];
        for(AVObject *checkin in self.currentCheckins) {
            AVQuery *query = [SNUser query];
            [query whereKey:@"userID" equalTo:[checkin objectForKey:@"userID"]];
            [self.currentUserBasicInfos addObject:[query findObjects][0]];
        }
    });
}
#pragma mark - table view delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCheckins.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNTagCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SNTagCell" forIndexPath:indexPath];
    [cell configureCellWithCheckinInfo:self.currentCheckins[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    if(indexPath.row >= self.currentUserBasicInfos.count) {
        [ProgressHUD show:@"Loading information. Please wait..."];
        AVQuery *query = [SNUser query];
        [query whereKey:@"userID" equalTo:[self.currentCheckins[indexPath.row] objectForKey:@"userID"]];
        vc.currentUserProfile = [query findObjects][0];
    } else {
        vc.currentUserProfile = self.currentUserBasicInfos[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
    [ProgressHUD dismiss];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterButtonClicked:(UIButton *)sender {
    if(popover == nil) {
        popover = [DXPopover popover];
    }
    popover.backgroundColor = [UIColor whiteColor];
    popover.cornerRadius = 8;
    [popover showAtPoint:CGPointMake(self.filterButton.frame.origin.x, self.filterButton.frame.origin.y+20) popoverPostion:DXPopoverPositionDown withContentView:_popPanel inView:self.view];
}
- (IBAction)tagSportButtonOnPopverClicked:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *checkin = (AVObject*)obj;
        return [[checkin objectForKey:@"sport"]integerValue] == _todaySport;
    }];
    self.currentCheckins = [[self.allCheckIns filteredArrayUsingPredicate:predicate]mutableCopy];
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
- (IBAction)myTimeButtonOnPopoverClicked:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *checkin = (AVObject*)obj;
        return [[checkin objectForKey:@"sportTimeSlot"]integerValue] == [[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue];
    }];
    self.currentCheckins = [[self.allCheckIns filteredArrayUsingPredicate:predicate]mutableCopy];
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
- (IBAction)allButtonOnPopoverClicked:(UIButton *)sender {
    self.currentCheckins = self.allCheckIns;
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
@end
