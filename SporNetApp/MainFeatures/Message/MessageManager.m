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

@property(nonatomic) NSMutableArray *allConversations;
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
    _allConversations = [[NSMutableArray alloc]init];
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"MessageManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}

-(void)refreshAllConversations {
    AVIMConversationQuery *query = [_client conversationQuery];
//    [query getConversationById:@"57b47aea0a2b580057f48855" callback:^(AVIMConversation *conversation, NSError *error) {
//        [self.allConversations addObject:conversation];
//    }];
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", error);
        for(AVIMConversation *conversation in objects) {
            AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:@"57a4e327a3413100632ca7e0"];
            NSLog(@"objectid is %@", conversation.members[1]);
            [user fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                Conversation *c = [[Conversation alloc]init];
                NSLog(@"这个人名字是 %@", [user objectForKey:@"name"]);
                c.basicInfo = user;
                c.conversation = conversation;
                [self.allConversations addObject:c];
            }];
        }
    }];
}
-(NSMutableArray*)fetchAllCurrentConversations {
    [self refreshAllConversations];
    
    
    return _allConversations;
}
-(void)startMessageService {
    _client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId];
    [_client openWithCallback:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"成功打开实时通讯功能");
    }];
}
@end