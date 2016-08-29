//
//  Conversation.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNUser.h"
@interface Conversation : NSObject
@property AVIMConversation *conversation;
@property AVObject *basicInfo;
@property NSInteger unreadMessageNumber;
@end
