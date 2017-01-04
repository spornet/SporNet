//
//  SNFriendsShareCell.m
//  SporNetApp
//
//  Created by Peng on 1/2/17.
//  Copyright © 2017 Peng Wang. All rights reserved.
//

#import "SNFriendsShareCell.h"

@interface SNFriendsShareCell()

@property (weak, nonatomic) IBOutlet UIImageView *UserProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserSportTypePic;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserLatestStatusTime;
@property (weak, nonatomic) IBOutlet UILabel *UserPopularityCount;
@property (weak, nonatomic) IBOutlet UITextView *UserStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *UserSharedPhotoes;

@property (nonatomic, strong) NSArray *sportsArray;

@end

@implementation SNFriendsShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.UserProfileImage.clipsToBounds = YES;
    [self.UserProfileImage.layer setCornerRadius:self.UserProfileImage.frame.size.width / 2.0];
    self.UserSportTypePic.clipsToBounds = YES;
    [self.UserSportTypePic.layer setCornerRadius:28];
    //initialize sportPicArray
    self.sportsArray = @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]];
}

- (void)setMomentModel:(FriendsMomentModel *)momentModel {
    
    _momentModel = momentModel;
    
    self.UserProfileImage.image = momentModel.profileImage;
    self.UserSportTypePic.image = self.sportsArray[momentModel.sportType];
    self.UserName.text = momentModel.profileName;
    self.UserLatestStatusTime.text = momentModel.statusTime;
    self.UserPopularityCount.text = momentModel.popularityCount;
    
    
}



@end











