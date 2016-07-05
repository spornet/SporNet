//
//  SNLaunchPageViewController.h
//  SporNetApp
//
//  Created by ZhengYang on 16/7/1.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNLaunchPageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) NSArray              *pageTitles;
@property (strong,nonatomic) NSArray              *pageImages;

@end
