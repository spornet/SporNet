//
//  MockUser.h
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@interface MockUser : NSObject
@property NSString *name;
@property NSString *school;
@property enum BestSports bestSport;
@property enum SportTimeSlot sportTimeSlot;
@property NSData *photo;
+(id)initWithName:(NSString*)name school:(NSString*)school bestSport:(BestSports)bestSport spotTimeSlot:(SportTimeSlot)sportTimeSlot photo:(NSData*)photo;
@end
