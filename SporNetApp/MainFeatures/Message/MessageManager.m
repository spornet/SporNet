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
#import <UIKit/UIKit.h>
#define selfId [[[AVUser currentUser] objectForKey:@"basicInfo"]objectId]
static MessageManager *center = nil;

@interface MessageManager ()

@property(nonatomic) NSMutableArray *allConversations;
@property(nonatomic) NSMutableArray *allFriendRequsts;
@property(nonatomic) NSMutableDictionary *allContacts;
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

    _allConversations = [[NSMutableArray alloc]init];
    _allFriendRequsts = [[NSMutableArray alloc]init];
    _allContacts = [[NSMutableDictionary alloc]init];
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"MessageManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}

-(void)refreshAllConversations{
    [ProgressHUD show:@"Fetching conversations. Please wait..."];
    AVIMConversationQuery *query = [_client conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[selfId]];
    [query whereKey:@"status" equalTo:@1];
    query.cachePolicy = kAVIMCachePolicyNetworkElseCache;
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"gagaga");
        for(AVIMConversation *conversation in objects) {
            NSString *talkToId;
            if([conversation.members[0] isEqualToString:selfId]) {
                talkToId = conversation.members[1];
            } else talkToId = conversation.members[0];
            AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:talkToId];
            NSLog(@"objectid is %@", talkToId);
            [user fetch];
            Conversation *c = [[Conversation alloc]init];
            NSLog(@"这个人名字是 %@", [user objectForKey:@"name"]);
            c.basicInfo = user;
            c.conversation = conversation;
            c.unreadMessageNumber = 0;
            [self.allConversations addObject:c];
            //NSLog([user objectForKey:@"name"]);
//            [user fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//                Conversation *c = [[Conversation alloc]init];
//                NSLog(@"这个人名字是 %@", [user objectForKey:@"name"]);
//                c.basicInfo = user;
//                c.conversation = conversation;
//                c.unreadMessageNumber = 0;
//                [self.allConversations addObject:c];
//            }];
        }
        [self.delegate didFinishRefreshing];
    }];
}
-(void)refreshAllFriendRequest{
    [ProgressHUD show:@"Fetching friend requests. Please wait..."];
    AVIMConversationQuery *query = [_client conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[selfId]];
    [query whereKey:@"status" notEqualTo:@1];
    //[query whereKey:@"c" notEqualTo:selfId];
    query.cachePolicy = kAVIMCachePolicyNetworkElseCache;
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", error);
        for(AVIMConversation *conversation in objects) {
            NSString *talkToId;
            if([conversation.members[0] isEqualToString:selfId]) {
                talkToId = conversation.members[1];
            } else talkToId = conversation.members[0];
            AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:talkToId];
            NSLog(@"objectid is %@", talkToId);
            [user fetch];
            Conversation *c = [[Conversation alloc]init];
            NSLog(@"这个人名字是 %@", [user objectForKey:@"name"]);
            c.basicInfo = user;
            c.conversation = conversation;
            c.unreadMessageNumber = 0;
            [self.allFriendRequsts addObject:c];
        }
    }];
}

-(NSMutableArray*)fetchAllCurrentFriendRequests {
    NSLog(@"更新好友请求");
    return _allFriendRequsts;
}

-(NSMutableArray*)fetchAllCurrentConversations {
//    NSLog(@"更新");
    return [[_allConversations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSDate *date1 = ((Conversation*)obj1).conversation.lastMessageAt;
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[((Conversation*)obj1).conversation queryMessagesFromCacheWithLimit:1][0] sendTimestamp]];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[[((Conversation*)obj2).conversation queryMessagesFromCacheWithLimit:1][0] sendTimestamp]];
//        NSDate *date2 = ((Conversation*)obj2).conversation.lastMessageAt;
        return [date2 compare:date1];
    }]mutableCopy];
    //return _allConversations;
}

-(NSMutableArray*)fetchMessagesWithUserId:(NSString*)userId {
    return nil;
}

-(NSMutableDictionary*)fetchAllContacts {
    for(NSString *sport in SPORT_ARRAY) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
            Conversation *c = (Conversation*)obj;
            return [[c.basicInfo objectForKey:@"bestSport"] intValue] == ([SPORT_ARRAY indexOfObject:sport] + 1);
        }];
        NSArray *arr = [self.allConversations filteredArrayUsingPredicate:predicate];
        //NSMutableArray *sortedArray = [[arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]mutableCopy];
        NSArray *sorted = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [[[(Conversation*)obj1 basicInfo] objectForKey:@"name"] caseInsensitiveCompare:[[(Conversation*)obj2 basicInfo] objectForKey:@"name"]];
        }];
        if(arr.count) [self.allContacts setObject:[sorted mutableCopy] forKey:sport];
    }
    return self.allContacts;
}
-(void)startMessageService {
    _client = [[AVIMClient alloc] initWithClientId:[[[AVUser currentUser] objectForKey:@"basicInfo"]objectId]];
    [_client openWithCallback:^(BOOL succeeded, NSError *error) {
        NSLog(@"成功打开实时通讯功能");
        [self refreshAllConversations];
        [self refreshAllFriendRequest];
    }];
}

-(void)sendAddFrendRequst:(NSString*)clientId {
    [_client createConversationWithName:@"friend request" clientIds:@[selfId, clientId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
        AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"I'd love to add you as my friend"attributes:nil];
        [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
            [ProgressHUD showSuccess:@"You've successfully sent friend request."];
        }];
    }];
}
-(void)acceptFriendRequest:(Conversation*)c{
    [c.conversation update:@{@"status":@1} callback:^(BOOL succeeded, NSError *error) {
        AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"I've added you as my friend. Let's start to chat!" attributes:nil];
        [c.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
            [ProgressHUD showSuccess:@"You've successfully sent friend request."];
            [self.allFriendRequsts removeObject:c];
            [self.allConversations addObject:c];
            [self.delegate didAcceptFriendRequest];
        }];
    }];
}
@end