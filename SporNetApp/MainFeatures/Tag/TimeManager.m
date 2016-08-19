//
//  TimeManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/1/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "TimeManager.h"
static NSDateFormatter *timeFormatter = nil;
static NSDateFormatter *dateFormatter = nil;
@implementation TimeManager
+(NSString*)getTimeStringFromNSDate:(NSDate*)date {
    if(timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm";
    }
    return [timeFormatter stringFromDate:date];
}
+(NSString*)getDateString:(NSDate*)date {
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";;
    }
    return [dateFormatter stringFromDate:date];
}
+(NSString*)getTimeLabelString:(NSDate*)checkinTime refreshTime:(NSDate*)refreshTime {
    NSString *result;
    NSTimeInterval distanceSeconds = -[checkinTime timeIntervalSinceDate:refreshTime];
    if(distanceSeconds < 60) result = [NSString stringWithFormat:@"%lds ago", (long)distanceSeconds];
    else if (distanceSeconds < 3600) result = [NSString stringWithFormat:@"%ldmin ago", (long)distanceSeconds / 60];
    else result = [NSString stringWithFormat:@"%ldhr ago", (long)distanceSeconds/3600];
    return result;
}


+ (NSString *)getConvastionTimeStr:(NSDate *)sendDate
{
    // 1.获取日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 2.获取当前时间
    NSDate *currentDate = [NSDate date];
    // 3.获取当前时间的年月日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 4.获取发送时间
    //    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    // 5.获取发送时间的年月日
    NSDateComponents *sendComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sendDate];
    NSInteger sendYear = sendComponents.year;
    NSInteger sendMonth = sendComponents.month;
    NSInteger sendDay = sendComponents.day;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    
    if (currentYear == sendYear &&
        currentMonth == sendMonth &&
        currentDay == sendDay) {// 今天发送的
        fmt.dateFormat = @"Today HH:mm";
    }else if(currentYear == sendYear &&
             currentMonth == sendMonth &&
             currentDay+1 == sendDay){// 昨天发的
        fmt.dateFormat = @"Yesterday HH:mm";
    }else{// 前天以前发的
        fmt.dateFormat = @"MM:dd";
    }
    
    return [fmt stringFromDate:sendDate];
}

+(NSInteger)calculateAgeByBirthday:(NSDate*)birthday {
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:[NSDate date]
                                       options:0];
    return [ageComponents year];
}
@end
