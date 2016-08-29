//
//  SNSearchNearbyProfileViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/3/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNUser.h"
@protocol SNSearchNearbyProfileVCDelegate <NSObject>
- (void)didClickCrossButton;
@end
@interface SNSearchNearbyProfileViewController : UIViewController<UIScrollViewAccessibilityDelegate>
@property(nonatomic, strong) SNUser *currentUserProfile;
@property (nonatomic,assign) BOOL isSearchNearBy;
@property id<SNSearchNearbyProfileVCDelegate> delegate;
@end
