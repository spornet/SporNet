//
//  SNUser.h
//  SporNetApp
//
//  Created by 浦明晖 on 6/30/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//
#import "AVObject.h"
#import <AVOSCloud/AVOSCloud.h>


static NSString *const kStudnetKeyGender = @"gender";
static NSString *const kStudentKeyName = @"name";
static NSString *const kStudentKeyGradYear = @"gradYear";
static NSString *const kBestSport = @"bestSport";
static NSString *const kSportTimeSlot =@"sportTimeSlot";
static NSString *const kAboutMe = @"aboutMe";

typedef enum{
    GenderUnkonwn = 0,
    GenderMale = 1,
    GenderFamale
}GenderType;
typedef NS_ENUM(NSInteger, BestSports) {
    BestSportsJogging = 1,
    BestSportsMuscle,
    BestSportsSoccer,
    BestSportsBasketball,
    BestSportsYoga
};
typedef NS_ENUM(NSInteger, SportTimeSlot) {
    SportTimeSlotMorning = 0,
    SportTimeSlotNoon,
    SportTimeSlotAfternoon,
    SportTimeSlotNight
};
@interface SNUser : AVObject<AVSubclassing>

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, assign) GenderType gender;
@property (nonatomic, assign) NSInteger gradYear;
@property(nonatomic, assign) AVUser *user;
@property(nonatomic, assign) BestSports bestSport;
@property(nonatomic, assign) SportTimeSlot sportTimeSlot;
@property(nonatomic, assign) NSString *aboutMe;
@end
