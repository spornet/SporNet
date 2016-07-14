//
//  MockUser.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MockUser.h"

@implementation MockUser
//mock user initializers
+(id)initWithName:(NSString*)name school:(NSString*)school bestSport:(BestSports)bestSport spotTimeSlot:(SportTimeSlot)sportTimeSlot photo:(NSData*)photo {
    MockUser *user = [[MockUser alloc]init];
    user.name = name;
    user.school = school;
    user.bestSport = bestSport;
    user.sportTimeSlot = sportTimeSlot;
    user.photo = photo;
    return  user;
}
+(id)initWithName:(NSString*)name school:(NSString*)school todasySport:(BestSports)todaySport spotTimeSlot:(SportTimeSlot)sportTimeSlot photo:(NSData*)photo {
    MockUser *user = [[MockUser alloc]init];
    user.name = name;
    user.school = school;
    user.todaySport = todaySport;
    user.sportTimeSlot = sportTimeSlot;
    user.photo = photo;
    return  user;
}
@end
