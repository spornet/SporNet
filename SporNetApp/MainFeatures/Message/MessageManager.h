//
//  MessageManager.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVIMClient.h>
#import "Conversation.h"
//@protocol MessageManagerDelegate <NSObject>
//- (void)didClickSavePhotosButton:(NSMutableArray *)selectedPhotos;
//@end

@interface MessageManager : NSObject
@property (nonatomic, strong) AVIMClient *client;
+(instancetype)defaultManager;
-(void)startMessageService;
-(NSMutableArray*)fetchAllCurrentConversations;
@end
