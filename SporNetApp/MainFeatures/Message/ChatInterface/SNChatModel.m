//
//  SNChatModel.m
//  Messaging
//
//  Created by Peng on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNChatModel.h"

//#import "NSString+YFTimestamp.h"

@interface SNChatModel ()
/**
 *  Content Text
 */
@property (nonatomic, copy) NSString *contentText;
/**
 *  Content Text Background Image
 */
@property (nonatomic, strong) UIImage *contectTextBackgroundIma;
/**
 *  Context Text Background Highlight Image
 */
@property (nonatomic, strong) UIImage *contectTextBackgroundHLIma;

/**
 *  User Profile Icon URL
 */
@property (nonatomic, copy) NSString *userIcon;
/**
 *  Time
 */
@property (nonatomic, copy) NSString *timeStr;

/**
 *  Should Show Time
 */
@property (nonatomic, assign, getter = isShowTime) BOOL showTime;

/**
 *  Shoud Show ME
 */
@property (nonatomic, assign, getter = isMe) BOOL me;

@end

@implementation SNChatModel

+ (instancetype)chatWith:(AVIMMessage *)emsg
{
    SNChatModel *chat = [[self alloc] init];
    //chat.preTimestamp = lastMessageDate;
    chat.emsg = emsg;
    
    return chat;
}

- (void)setEmsg:(AVIMMessage *)emsg
{
    _emsg = emsg;
    if (emsg.ioType) {
        self.me = YES;
        self.userIcon = nil;
        self.contectTextBackgroundIma = nil;
        self.contectTextBackgroundHLIma = nil;
    }else {
        self.me = NO;
        self.userIcon = nil;
        self.contectTextBackgroundIma = [UIImage imageNamed: nil];
        self.contectTextBackgroundHLIma = [UIImage imageNamed: nil];
    }
}
@end
