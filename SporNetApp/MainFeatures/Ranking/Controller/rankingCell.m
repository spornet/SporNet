//
//  rankingCell.m
//  SporNetApp
//
//  Created by Peng Wang on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "rankingCell.h"
#import "globalMacros.h"
@implementation rankingCell

NSArray *sportPicArray;
- (void)awakeFromNib {
    // Initialize the cell
    
    [super awakeFromNib];
    
    self.userImageView.clipsToBounds = YES;
    [self.userImageView.layer setCornerRadius:self.userImageView.frame.size.width / 2.0];
    self.userBestSportColorView.clipsToBounds = YES;
    [self.userBestSportColorView.layer setCornerRadius:28];
    //initialize sportPicArray
    sportPicArray = @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]];
    //initialize ranking label.
    self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, 40, 40)];
}
//congigure each cell with the the user information and his ranking.
-(void)configureCellWithUser:(SNUser*)user Ranking:(NSInteger)ranking {
    
    NSLog(@"user count %ld", user.voteNumber);

    self.userNameLabel.text = user.name;
    self.userSchoolLabel.text = [user objectForKey:@"school"];

        
    self.userPopulartyCount.text = [NSString stringWithFormat:@"%ld",user.voteNumber];

    
    [self.userBestSportColorView setBackgroundColor:SPORTSLOT_COLOR_ARRAY[(int)user.sportTimeSlot]];
    AVFile *file = [user objectForKey:@"icon"];
    self.userImageView.image = [UIImage imageWithData:[file getData]];
    
    self.bestSportImageView.image = sportPicArray[(int)user.bestSport-1];
    
        [self.rankLabel removeFromSuperview];
        if(ranking == 0) self.medalImageView.image = [UIImage imageNamed:@"medalGold"];
        else if(ranking == 1) self.medalImageView.image = [UIImage imageNamed:@"medalSilver"];
        else if (ranking == 2) self.medalImageView.image = [UIImage imageNamed:@"medalBronze"];
        //if user's ranking is out of 3, replace medal image wit rankLabel.
        
        else {
            self.rankLabel.text = [NSString stringWithFormat:@"NO.%ld", ranking + 1];
            self.medalImageView.image = nil;
            [self.medalImageView addSubview:self.rankLabel];
        }
    
}

@end
