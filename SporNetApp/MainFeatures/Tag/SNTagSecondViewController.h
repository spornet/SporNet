//
//  TagSecondViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TodaySport) {
    TodaySportJogging = 1,
    TodaySportMuscle,
    TodaySportSoccer,
    TodaySportBasketball,
    TodaySportYoga
};
@interface SNTagSecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property NSString *gymName;
@property TodaySport todaySport;
@end
