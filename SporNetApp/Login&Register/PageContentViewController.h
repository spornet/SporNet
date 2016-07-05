//
//  PageContentViewController.h
//  SporNetApp
//
//  Created by ZhengYang on 16/7/1.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property NSInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
