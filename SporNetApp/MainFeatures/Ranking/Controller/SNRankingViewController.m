//
//  RankingViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNRankingViewController.h"
#import "rankingCell.h"
#import "MockUser.h"
@interface SNRankingViewController ()

@property (strong, nonatomic) IBOutlet UITableView    *tableView;
@property (strong, nonatomic) IBOutlet UILabel        *titleLabel;
//currently selected sport.
@property (nonatomic        ) enum     BestSports     currentSport;
//mock data of all users.
@property (nonatomic, strong) NSArray        *mockUsers;
//users of currently selected sport.
@property (nonatomic, strong) NSMutableArray *currentUsers;
//array of 5 sport images.
@property (nonatomic        ) NSArray        *sportArray;
//array of 5 sport images on selection state.
@property (nonatomic        ) NSArray        *sportArraySelected;
//array of 5 sport titles.
@property (nonatomic        ) NSArray        *titles;
@end

@implementation SNRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register ranking cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"rankingCell" bundle:nil] forCellReuseIdentifier:@"rankingCell"];
    //initilize current users as nil and current sport as basketball.
    self.currentUsers = [[NSMutableArray alloc]init];
    self.currentSport = BestSportsBasketball;
}
#pragma mark: tableview delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentUsers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rankingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"rankingCell"];
    [cell configureCellWithUser:self.currentUsers[indexPath.row] Ranking:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (IBAction)sportButtonClicked:(UIButton *)sender {
    self.currentSport = sender.tag;
}
/**
 *  setter of currentsport when property "currentSport" value changed. This setter method will 1) reset the already highlighted sport button 2) hightlight the current sport button 3)generate a new currentusers based on their best sport. 4) reload tableview.
 */
-(void)setCurrentSport:(enum BestSports )currentSport {
    if(_currentSport != 0) {
    UIButton *button = (UIButton*)[[self.view viewWithTag:10]viewWithTag:(NSInteger)_currentSport];
    [button setBackgroundImage:self.sportArray[(NSInteger)_currentSport-1] forState:normal];
    }
    UIButton *newButton = (UIButton*)[[self.view viewWithTag:10]viewWithTag:(NSInteger)currentSport];
    [newButton setBackgroundImage:self.sportArraySelected[(NSInteger)currentSport-1] forState:normal];
    _currentSport = currentSport;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ TOP", self.titles[currentSport-1]];
    [self.currentUsers removeAllObjects];
    for(MockUser *user in self.mockUsers) {
        if((int)user.bestSport == _currentSport) {
            [self.currentUsers addObject:user];
        }
    }
    [self.tableView reloadData];
}

#pragma mark: getter of some properties.
-(NSArray*)sportArraySelected {
    _sportArraySelected = @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]];
    return _sportArraySelected;
}
//getter of sportArray
-(NSArray*)sportArray {
    _sportArray = @[[UIImage imageNamed:@"jogging"], [UIImage imageNamed:@"muscle"], [UIImage imageNamed:@"soccer"], [UIImage imageNamed:@"basketball"], [UIImage imageNamed:@"yoga"]];
    return _sportArray;
}
//getter of titles
-(NSArray*)titles {
    _titles = @[@"RUNNING", @"FITNESS", @"SOCCER", @"BASKETBALL", @"YOGA"];
    return _titles;
}
//getter of mockUsers: generate mock data for users.
-(NSArray*)mockUsers {
    if(_mockUsers != nil) {
        return _mockUsers;
    }
    MockUser *user1 = [MockUser initWithName:@"Yamada Ryosuke" school:@"Boston University" bestSport:BestSportsSoccer spotTimeSlot:SportTimeSlotMorning photo:UIImagePNGRepresentation([UIImage imageNamed:@"user1"])];
    MockUser *user2 = [MockUser initWithName:@"Yuto Nagagima" school:@"MIT" bestSport:BestSportsJogging spotTimeSlot:SportTimeSlotAfternoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user2"])];
    MockUser *user3 = [MockUser initWithName:@"Chinen Smith" school:@"Harvard" bestSport:BestSportsMuscle spotTimeSlot:SportTimeSlotNight photo:UIImagePNGRepresentation([UIImage imageNamed:@"user3"])];
    MockUser *user4 = [MockUser initWithName:@"Kevin Oven" school:@"Norhteastern University" bestSport:BestSportsYoga spotTimeSlot:SportTimeSlotNoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user4"])];
    MockUser *user5 = [MockUser initWithName:@"Dork Staples" school:@"Norhteastern University" bestSport:BestSportsMuscle spotTimeSlot:SportTimeSlotAfternoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user5"])];
    MockUser *user6 = [MockUser initWithName:@"Andrew Kagayaki" school:@"MIT" bestSport:BestSportsBasketball spotTimeSlot:SportTimeSlotMorning photo:UIImagePNGRepresentation([UIImage imageNamed:@"user6"])];
    MockUser *user7 = [MockUser initWithName:@"Gakki Lopze" school:@"Harvard" bestSport:BestSportsYoga spotTimeSlot:SportTimeSlotAfternoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user7"])];
    MockUser *user8 = [MockUser initWithName:@"Jenny Coles" school:@"Boston University" bestSport:BestSportsBasketball spotTimeSlot:SportTimeSlotNight photo:UIImagePNGRepresentation([UIImage imageNamed:@"user8"])];
    MockUser *user9 = [MockUser initWithName:@"Zhiyang Han" school:@"Tufts University" bestSport:BestSportsBasketball spotTimeSlot:SportTimeSlotMorning photo:UIImagePNGRepresentation([UIImage imageNamed:@"user9"])];
    MockUser *user10 = [MockUser initWithName:@"Yamashita Oitta" school:@"Boston University" bestSport:BestSportsBasketball spotTimeSlot:SportTimeSlotNoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user10"])];
    MockUser *user11 = [MockUser initWithName:@"Hellen Potter" school:@"Boston College" bestSport:BestSportsJogging spotTimeSlot:SportTimeSlotNoon photo:UIImagePNGRepresentation([UIImage imageNamed:@"user9"])];
    _mockUsers = @[user1, user2, user3, user4,user5, user6, user7, user8, user9, user10, user11];
    return _mockUsers;
}

@end
