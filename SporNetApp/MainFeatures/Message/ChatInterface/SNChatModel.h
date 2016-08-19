//
//  SNChatModel.h
//  Messaging
//
//  Created by Peng on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Conversation.h"
@interface SNChatModel : NSObject

+ (instancetype)chatWith:(AVIMMessage*)emsg preTimestamp:(NSDate *)lastMessageDate;
/**
 *  Conversation Model
 */
@property (nonatomic, strong) AVIMMessage *emsg;
/**
 *  Last Message time
 */
@property (nonatomic, assign) NSDate *preTimestamp;
/**
 *  Text Message Content
 */
@property (nonatomic, copy, readonly) NSString *contentText;
/**
 *  Text Message Background Image
 */
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundIma;
/**
 *  Text Message Background Hightlight Image
 */
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundHLIma;

/**
 *  User Icon URL
 */
@property (nonatomic, copy, readonly) NSString *userIcon;

/**
 *  Time
 */
@property (nonatomic, copy, readonly) NSString *timeStr;
/**
 *  Should Show Time
 */
@property (nonatomic, assign, getter=isShowTime, readonly) BOOL showTime;
/**
 *  Should Show ME 
 */
@property (nonatomic, assign, getter=isMe, readonly) BOOL me;

@end
