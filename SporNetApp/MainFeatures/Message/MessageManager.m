//
//  MessageManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageManager.h"
#import <AVUser.h>
#import "SNChatModelFrame.h"
#import "SNChatModel.h"
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
    NSString *selfId = [[[AVUser currentUser] objectForKey:@"basicInfo"]objectId];
    AVIMConversationQuery *query = [_client conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[selfId]];
    query.cachePolicy = kAVIMCachePolicyCacheElseNetwork;
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", error);
        for(AVIMConversation *conversation in objects) {
            NSString *talkToId;
            if([conversation.members[0] isEqualToString:selfId]) {
                talkToId = conversation.members[1];
            } else talkToId = conversation.members[0];
            AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:talkToId];
            NSLog(@"objectid is %@", talkToId);
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
    return _allConversations;
}

-(NSMutableArray*)fetchMessagesWithUserId:(NSString*)userId {
    
    return nil;
}
-(void)startMessageService {
    _client = [[AVIMClient alloc] initWithClientId:[[[AVUser currentUser] objectForKey:@"basicInfo"]objectId]];
    [_client openWithCallback:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"成功打开实时通讯功能");
        [self refreshAllConversations];
    }];
}
@end