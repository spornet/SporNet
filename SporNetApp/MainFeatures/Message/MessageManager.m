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
#import "SNUser.h"
static MessageManager *center = nil;

@interface MessageManager ()

@property(nonatomic) NSMutableArray *allFriendRequsts;
@property(nonatomic, strong) NSMutableArray *allConversations;

@property(nonatomic) NSMutableDictionary *allContacts;
@property(nonatomic) NSMutableArray *myFriends;
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

//    _allConversations = [[NSMutableArray alloc]init];
    _allFriendRequsts = [[NSMutableArray alloc]init];
    _allContacts = [[NSMutableDictionary alloc]init];
    _myFriends = [NSMutableArray array];
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"MessageManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}

- (NSMutableArray *)allConversations {
    
    if (_allConversations == nil) {
        
        _allConversations = [NSMutableArray array];
    }
    return _allConversations;
}

/**
 *  Find All Current User's Consersations
 */
-(void)refreshAllConversations{
    
    if (!SELF_ID) {
        
        return;
    }
    
    AVIMConversationQuery *query = [self.myClient conversationQuery];

    [query whereKey:@"m" containsAllObjectsInArray:@[SELF_ID]];
    [query whereKey:@"status" equalTo:@1];
    query.cachePolicy = kAVIMCachePolicyNetworkOnly;

    
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            
            NSString *friendID;
            for(AVIMConversation *conversation in objects) {
                
                friendID = conversation.members.lastObject;
                
                Conversation *c = [[Conversation alloc]init];
                c.myInfo = conversation.members.firstObject;
                c.friendBasicInfo = friendID;
                c.conversation = conversation;
                c.unreadMessageNumber = 0;
                [self.allConversations addObject:c];
                
                if ([self.delegate respondsToSelector:@selector(didFinishRefreshing)]) {
                    
                    [self.delegate didFinishRefreshing];
                }
            }
        
        
    }];
}
-(void)refreshAllFriendRequest{
    
    AVIMConversationQuery *query = [self.myClient conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[SELF_ID]];
    [query whereKey:@"status" notEqualTo:@1];
    
    query.cachePolicy = kAVIMCachePolicyNetworkElseCache;
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        for(AVIMConversation *conversation in objects) {
            
            if (objects.count) {
                
                Conversation *c = [[Conversation alloc]init];
                c.myInfo = conversation.members.firstObject;
                c.friendBasicInfo = conversation.members.lastObject;
                c.conversation = conversation;
                c.unreadMessageNumber = 0;
                [self.allFriendRequsts addObject:c];
            }
            
            if ([self.delegate respondsToSelector:@selector(didFinishRefreshing)]) {
                
                [self.delegate didFinishRefreshing];
            }
        }
    }];
}

-(NSMutableArray*)fetchAllCurrentFriendRequests {
    return _allFriendRequsts;
}

-(NSMutableArray*)fetchAllCurrentConversations {
    return [[self.allConversations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[((Conversation*)obj1).conversation queryMessagesFromCacheWithLimit:1][0] sendTimestamp]];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[[((Conversation*)obj2).conversation queryMessagesFromCacheWithLimit:1][0] sendTimestamp]];
        return [date2 compare:date1];
    }]mutableCopy];
}

-(NSMutableArray*)fetchMessagesWithUserId:(NSString*)userId {
    return nil;
}

-(NSMutableDictionary*)fetchAllContacts {
    for(NSString *sport in SPORT_ARRAY) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
            Conversation *c = (Conversation*)obj;
            
            AVObject *myself;
            if ([c.myInfo isEqualToString:SELF_ID]) {
                
                myself = [AVObject objectWithClassName:@"SNUser" objectId:c.friendBasicInfo];
            } else {
                
                myself = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
            }
            
            [myself fetch];
            
            return [[myself objectForKey:@"bestSport"] intValue] == ([SPORT_ARRAY indexOfObject:sport] + 1);
        }];
        NSArray *arr = [self.allConversations filteredArrayUsingPredicate:predicate];
        
        NSArray *sorted = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            AVObject *myself;
            AVObject *myself2;
            Conversation *userC = (Conversation *)obj1;
            Conversation *user2C = (Conversation *)obj2;
            if ([userC.myInfo isEqualToString:SELF_ID] && [user2C.myInfo isEqualToString:SELF_ID]) {
                
                myself = [AVObject objectWithClassName:@"SNUser" objectId:userC.friendBasicInfo];
                myself2 = [AVObject objectWithClassName:@"SNUser" objectId:user2C.friendBasicInfo];
            } else {
                
                myself = [AVObject objectWithClassName:@"SNUser" objectId:userC.myInfo];
                myself2 = [AVObject objectWithClassName:@"SNUser" objectId:user2C.myInfo];

            }
            
            [myself fetch];
            
            [myself2 fetch];
            
            return [[myself objectForKey:@"name"] caseInsensitiveCompare:[myself2 objectForKey:@"name"]];
        }];
        if(arr.count) [self.allContacts setObject:[sorted mutableCopy] forKey:sport];
    }
    return self.allContacts;
}

/**
 *  Find Current User from the Disk and Open Messaging Function
 */
-(void)startMessageService {
    
    self.myClient = [[AVIMClient alloc]initWithClientId:[AVUser currentUser].objectId];
    [self.myClient openWithCallback:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            NSLog(@"error, %@", error.description);
        }
    }];

    

}

-(void)sendAddFrendRequst:(NSString*)clientId {
    
    NSLog(@"Friend Client %@", clientId);
    
    [self.myClient openWithCallback:^(BOOL succeeded, NSError *error) {
       
        [self.myClient createConversationWithName:@"friend request" clientIds:@[clientId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"Lets Play Sport Together"attributes:nil];
            [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                [ProgressHUD showSuccess:@"You've successfully sent friend request."];
                
                //Send Notification Push
                AVQuery *query = [AVInstallation query];
                [query whereKey:@"Owner" equalTo:clientId];
                
                AVPush *push = [[AVPush alloc]init];
                [push setMessage:@"You've Got a Friend Request"];
                [push setQuery:query];
                [push sendPushInBackground];
                
            }];
        }];
        
    }];
    
}
-(void)acceptFriendRequest:(Conversation*)c{
    [c.conversation update:@{@"status":@1, @"name":@"New Conversation"} callback:^(BOOL succeeded, NSError *error) {
        AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"I've added you as my friend. Let's start to chat!" attributes:nil];
        [ProgressHUD showSuccess:@"You've add a new friend."];
  
            [c.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                
                [self AddFriendRelationship:c];
                
                [self.allFriendRequsts removeObject:c];
                [self.allConversations addObject:c];
                if ([self.delegate respondsToSelector:@selector(didAcceptFriendRequest)]) {
                    
                    [self.delegate didAcceptFriendRequest];
                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Add_NEW_FRIEND" object:nil];
                
            }];
        }];
}

- (void)AddFriendRelationship:(Conversation *)c {
    
    AVObject *myself = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    
    AVObject *myFriend = [AVObject objectWithClassName:@"SNUser" objectId:c.friendBasicInfo];
    
    AVQuery *queryFriend = [AVInstallation query];
    AVQuery *queryMyself = [AVInstallation query];

    
    [myself fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        [queryFriend whereKey:@"Owner" equalTo:myFriend.objectId];
        AVPush *push = [[AVPush alloc]init];
        [push setMessage:@"You've Made a New Friend"];
        [push setQuery:queryFriend];
        [push sendPushInBackground];
        NSMutableArray *myselfFriends = [NSMutableArray array];
        
        NSArray *myfriends = [object objectForKey:@"MyFriends"];
        
        if (myfriends.count) {
            
            if (![myfriends containsObject:c.friendBasicInfo]) {
                
                [object addObject:c.friendBasicInfo forKey:@"MyFriends"];
                [object saveInBackground];
                
            }
            
        }else {
            
            [myselfFriends addObject:c.friendBasicInfo];
            
            [object setObject:myselfFriends forKey:@"MyFriends"];
            [object saveInBackground];
            
        }
    }];
    
    
    [myFriend fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        [queryMyself whereKey:@"Owner" equalTo:c.myInfo];
        AVPush *push = [[AVPush alloc]init];
        [push setMessage:@"You've Made a New Friend"];
        [push setQuery:queryMyself];
        [push sendPushInBackground];
        
        NSMutableArray *myfriendM = [NSMutableArray array];
        NSArray *myfriends = [object objectForKey:@"MyFriends"];
        
        if (myfriends.count) {
            
            if (![myfriends containsObject:c.myInfo]) {
                
                [object addObject:c.myInfo forKey:@"MyFriends"];
                [object saveInBackground];
                
            }
            
        }else {
            
            [myfriendM addObject:c.myInfo];
            
            [object setObject:myfriendM forKey:@"MyFriends"];
            [object saveInBackground];
            
        }
    }];


    
}
@end
