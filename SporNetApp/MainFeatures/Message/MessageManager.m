//
//  MessageManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageManager.h"
#import <AVUser.h>
static MessageManager *center = nil;

@interface MessageManager ()


@end

@implementation MessageManager
+(instancetype)defaultManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^ {
        center = (MessageManager*)@"MessageManager";
        center = [[MessageManager alloc]init];
    });
    return center;
}
-(instancetype)init {
    //    if(_allPrayers == nil) {
    //        _allPrayers = [[NSMutableArray alloc]init];
    //        _prayerDic = [[NSMutableDictionary alloc]init];
    //    }
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"MessageManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}
-(NSMutableArray*)fetchAllConversations {
    return nil;
}
-(void)startMessageService {
    _client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId];
    [_client openWithCallback:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"成功打开实时通讯功能");
    }];
}
@end