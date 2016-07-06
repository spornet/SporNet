//
//  rankingCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "rankingCell.h"

@implementation rankingCell

- (void)awakeFromNib {
    // Initialization code
    self.userImageView.clipsToBounds = YES;
    [self.userImageView.layer setCornerRadius:23];
    self.userBestSportColorView.clipsToBounds = YES;
    [self.userBestSportColorView.layer setCornerRadius:28];
    self.sportTimeColorArray = @[[UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.0], [UIColor colorWithRed:1.00 green:0.85 blue:0.40 alpha:1.0], [UIColor colorWithRed:0.96 green:0.70 blue:0.42 alpha:1.0],[UIColor colorWithRed:0.02 green:0.25 blue:0.40 alpha:1.0]];
    self.sportPicArray = @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]];
    self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, 40, 40)];
}

-(void)configureCellWithUser:(MockUser*)user Ranking:(NSInteger)ranking {
    self.userNameLabel.text = user.name;
    self.userSchoolLabel.text = user.school;
    [self.userBestSportColorView setBackgroundColor:self.sportTimeColorArray[(int)user.sportTimeSlot]];
    self.userImageView.image = [UIImage imageWithData:user.photo];
    self.bestSportImageView.image = self.sportPicArray[(int)user.bestSport-1];
    [self.rankLabel removeFromSuperview];
    if(ranking == 0) self.medalImageView.image = [UIImage imageNamed:@"medalGold"];
    else if(ranking == 1) self.medalImageView.image = [UIImage imageNamed:@"medalSilver"];
    else if (ranking == 2) self.medalImageView.image = [UIImage imageNamed:@"medalBronze"];
    else {
        self.rankLabel.text = [NSString stringWithFormat:@"NO.%ld", ranking + 1];
        self.medalImageView.image = nil;
        [self.medalImageView addSubview:self.rankLabel];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
