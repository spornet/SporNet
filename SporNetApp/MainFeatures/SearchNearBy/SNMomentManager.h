//
//  SNMomentManager.h
//  SporNetApp
//
//  Created by ZhengYang on 17/1/5.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNMomentManager : NSObject
+(instancetype)allocWithZone:(struct _NSZone *)zone;
+(instancetype)defaultManager;
-(NSMutableArray*)fetchAllUserMoments;

@end
