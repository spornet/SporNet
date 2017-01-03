//
//  FriendsMomentModel.h
//  SporNetApp
//
//  Created by Peng on 1/3/17.
//  Copyright © 2017 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    
    UserSportRunning = 0,
    UserSportFitness,
    UserSportSoccer,
    UserSportBasketball,
    UserSportYoga,
    
} UserSportType;

@interface FriendsMomentModel : NSObject


@property (nonatomic, copy)   NSString *profileName;
@property (nonatomic, copy)   NSString *statusTime;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, assign) UserSportType sportType;
@property (nonatomic, strong) NSString *statusMessage;
@property (nonatomic, copy)   NSString *popularityCount;
@property (nonatomic, strong) NSArray *momentsPics;

@end
