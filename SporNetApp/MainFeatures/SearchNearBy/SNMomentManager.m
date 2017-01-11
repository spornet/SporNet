//
//  SNMomentManager.m
//  SporNetApp
//
//  Created by ZhengYang on 17/1/5.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import "SNMomentManager.h"

static SNMomentManager *manger = nil;

@implementation SNMomentManager

+(instancetype)defaultManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[self alloc]init];
    });
    return manger;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [super allocWithZone:zone];
    });
    return manger;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

//-(NSMutableArray*)fetchAllUserMoments{
//
//
//
//}

@end
