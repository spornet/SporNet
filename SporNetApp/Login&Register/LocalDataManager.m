//
//  LocalDataManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/9/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "LocalDataManager.h"
#import <AVObject.h>
#import <AVUser.h>
#import <AVQuery.h>
#import <AVFile.h>
#import "SNUser.h"
#import "ProgressHUD.h"
static LocalDataManager *center = nil;

@interface LocalDataManager ()

@property(nonatomic) NSMutableArray *allUserInfo;
@end
@implementation LocalDataManager
+(instancetype)defaultManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^ {
        center = (LocalDataManager*)@"LocalDataManager";
        center = [[LocalDataManager alloc]init];
    });
    return center;
}
-(instancetype)init {
//    if(_allPrayers == nil) {
//        _allPrayers = [[NSMutableArray alloc]init];
//        _prayerDic = [[NSMutableDictionary alloc]init];
//    }
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"LocalDataManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}


+(void)fetchProfileInfoFromCloud {
    AVQuery *query = [SNUser query];
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchObjects = [query findObjects];
    if(fetchObjects.count == 0) return;
    SNUser *basicInfo = fetchObjects[0];
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"basicInfo.plist"];
    
    NSMutableArray *imageDataArr = [[NSMutableArray alloc]init];
    NSMutableArray *arr = [basicInfo objectForKey:@"PicUrls"];
    for(NSString *url in arr) {
        [imageDataArr addObject:[[AVFile fileWithURL:url]getData]];
    }
    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][0], [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][1], [basicInfo objectForKey:@"gender"], [basicInfo objectForKey:@"dateOfBirth"], [basicInfo objectForKey:@"gradYear"], [basicInfo objectForKey:@"bestSport"], [basicInfo objectForKey:@"sportTimeSlot"],[basicInfo objectForKey:@"aboutMe"], imageDataArr, nil] forKeys:[NSArray arrayWithObjects: @"firstName", @"lastName",@"gender", @"dateOfBirth",@"gradYear",@"bestSport",@"sportTimeSlot",@"aboutMe",@"photoes", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"plist writte successfully");
    } else {
        NSLog(@"plist failed");
    }

}
+(void)updateProfileInfoOnCloudInBackground {
        //更新的时候，得把NSInteger值转为NSNumber
    AVQuery *query = [SNUser query];
        //选取当前登陆用户的所有记录
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchedPrayers = [query findObjects];
    SNUser *user;
    if(fetchedPrayers.count) user = fetchedPrayers[0];
    else {
        user = [[SNUser alloc]init];
        user.voteNumber = 0;
        NSDictionary *schools = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emailToSchool" ofType:@"plist"]];
        [user setObject:schools[[[[AVUser currentUser].email componentsSeparatedByString:@"@"]lastObject]] forKey:@"school"];
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"basicInfo.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"basicInfo" ofType:@"plist"];
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [user setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
    [user setObject:dict[@"gradYear"] forKey:@"gradYear"];
    [user setObject:dict[@"gender"] forKey:@"gender"];
    [user setObject:dict[@"bestSport"] forKey:@"bestSport"];
    [user setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
    [user setObject:dict[@"dateOfBirth"] forKey:@"dateOfBirth"];
    [user setObject:dict[@"aboutMe"] forKey:@"aboutMe"];
    [user setObject:[AVUser currentUser].objectId forKey:@"userID"];
    [user setObject:[[AVUser currentUser]objectForKey:@"icon"] forKey:@"icon"];
    [[AVUser currentUser]setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
    [[AVUser currentUser]setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
    [[AVUser currentUser] setObject:dict[@"bestSport"] forKey:@"bestSport"];
    [[AVUser currentUser]setObject:user forKey:@"basicInfo"];
    [[AVUser currentUser]saveInBackground];
    //delete all previous images
    NSMutableArray *arr = [user objectForKey:@"ProfilePhotoes"];
    for(AVFile *file in arr) [file deleteInBackground];
    [user removeObjectsInArray:arr forKey:@"ProfilePhotoes"];
    //add all current images
    for(NSData *data in dict[@"photoes"]) {
        AVFile *file = [AVFile fileWithData:data];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [user addObject:file.url forKey:@"PicUrls"];
            [user save];
            NSLog(@"嘎嘎嘎");
        }];
    }
    NSLog(@"开始存储");
//    //save
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"存储成功哈哈哈");
//        } else {
//            NSLog(@"存储失败");
//            NSLog(@"失败原因%@", error);
//        }
//    }];
    
}
-(NSMutableArray*)fetchCurrentAllUserInfo {
    if(_allUserInfo.count == 0) return [self refreshAndFetchAllUserInfo];
    else return _allUserInfo;
}
-(NSMutableArray*)fetchUserInfoBySportType:(NSInteger)sportType {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *user = (AVObject*)obj;
        return [[user objectForKey:@"bestSport"]integerValue] == sportType;
    }];
    return [[_allUserInfo filteredArrayUsingPredicate:predicate]mutableCopy];

}
-(NSMutableArray*)refreshAndFetchAllUserInfo {
    [ProgressHUD show:@"Fetching Data. Please wait..."];
    AVQuery *query = [SNUser query];
    [query orderByDescending:@"voteNumber"];
    self.allUserInfo = [[query findObjects]mutableCopy];
    [ProgressHUD dismiss];
    return _allUserInfo;
    
}
-(BOOL)filterError:(NSError *)error{
    if (error) {
        NSLog(@"%@", error);
        return NO;
    } else {
        return YES;
    }
}
@end
