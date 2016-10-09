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
    if(fetchObjects.count == 0){
        
        return;
    }
    SNUser *basicInfo = fetchObjects.firstObject;
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    
    NSMutableArray *imageUrlArr = [[NSMutableArray alloc]init];
    NSArray *arr = [basicInfo objectForKey:@"PicUrls"];
    for(NSString *url in arr) {
        
        [imageUrlArr addObject:[[AVFile fileWithURL:url]getData]];
    }
    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][0], [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][1], [basicInfo objectForKey:@"gender"], [basicInfo objectForKey:@"dateOfBirth"], [basicInfo objectForKey:@"gradYear"], [basicInfo objectForKey:@"bestSport"], [basicInfo objectForKey:@"sportTimeSlot"],[basicInfo objectForKey:@"aboutMe"], imageUrlArr, nil] forKeys:[NSArray arrayWithObjects: @"firstName", @"lastName",@"gender", @"dateOfBirth",@"gradYear",@"bestSport",@"sportTimeSlot",@"aboutMe",@"photoes", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"plist writte successfully");
    } else {
        
        NSLog(@"plist failed");
    }

}
+(void)updateProfileInfoOnCloudInBackground {
    
#warning 需要重构代码，做一个从沙盒读取的工具类
        //更新的时候，得把NSInteger值转为NSNumber

    AVQuery *query = [SNUser query];
        //选取当前登陆用户的所有记录
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchedPrayers = [query findObjects];
    SNUser *user;
    if(fetchedPrayers.count)
    {
       user = fetchedPrayers[0];
    }
    else {
        user = [[SNUser alloc]init];
        user.voteNumber = 0;
        NSDictionary *schools = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emailToSchool" ofType:@"plist"]];
        NSString *lastComponet = [[[AVUser currentUser].email componentsSeparatedByString:@"@"]lastObject];
        NSArray *array = schools[lastComponet];
        [user setObject:[array firstObject] forKey:@"school"];
    }
    
    bool editProfile = [[NSUserDefaults standardUserDefaults]boolForKey:@"editUserProfile"];
    if (editProfile) {
        
        NSArray *imageUrls = [user objectForKey:@"PicUrls"];
        if (imageUrls) {
            
            for (NSString *imageUrl in imageUrls) {
                
                AVFile *imageFile = [AVFile fileWithURL:imageUrl];
                [imageFile getData];
                [imageFile deleteInBackground];
            }
            
            [user removeObjectsInArray:imageUrls forKey:@"PicUrls"];
        }
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"basicInfo" ofType:@"plist"];
    }else {
        
        
        [user setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
        [user setObject:dict[@"gradYear"] forKey:@"gradYear"];
        [user setObject:dict[@"gender"] forKey:@"gender"];
        [user setObject:dict[@"bestSport"] forKey:@"bestSport"];
        [user setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
        [user setObject:dict[@"dateOfBirth"] forKey:@"dateOfBirth"];
        [user setObject:dict[@"aboutMe"] forKey:@"aboutMe"];
        [user setObject:[AVUser currentUser].objectId forKey:@"userID"];
        [user setObject:[[AVUser currentUser]objectForKey:@"icon"] forKey:@"icon"];
        NSMutableArray *arrayM = [NSMutableArray array];
        for(NSData *data in dict[@"photoes"]) {
            AVFile *file = [AVFile fileWithData:data];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    [arrayM addObject:file.url];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [user setObject:arrayM forKey:@"PicUrls"];
                    [user save];
                    
                });
                
            }];
        }
        
        [[AVUser currentUser]setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
        [[AVUser currentUser]setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
        [[AVUser currentUser]setObject:dict[@"bestSport"] forKey:@"bestSport"];
        [[AVUser currentUser]setObject:user forKey:@"basicInfo"];
        [[AVUser currentUser]setObject:@(YES) forKey:@"User_Registered"];
        [[AVUser currentUser]saveInBackground];
        [user save];
        }

    NSLog(@"开始存储");
    
    
}
-(NSMutableArray*)fetchCurrentAllUserInfo {
    if(self.allUserInfo.count == 0){
        
        return [self refreshAndFetchAllUserInfo];
    }
    else {
        return self.allUserInfo;
    }
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
    [query includeKey:@"icon"];
    [query orderByDescending:@"voteNumber"];
    
    NSArray *users = [query findObjects];
    self.allUserInfo = [users mutableCopy];

    [ProgressHUD dismiss];
    return self.allUserInfo;
    
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
