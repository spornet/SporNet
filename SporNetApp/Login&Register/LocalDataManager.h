//
//  LocalDataManager.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/9/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataManager : NSObject
+(void)fetchProfileInfoFromCloud;
+(void)updateProfileInfoOnCloudInBackground;
+(instancetype)defaultManager;
-(NSMutableArray*)fetchCurrentAllUserInfo;
-(NSMutableArray*)fetchNearByUserInfo:(AVGeoPoint*)point withinDist:(CGFloat)dist;
-(NSMutableArray*)fetchUserInfoBySportType:(NSInteger)sportType;
@end
