//
//  SNPageContentViewController.h
//  SporNetApp
//
//  Created by ZhengYang on 16/7/1.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton    *startBtn;
//index for page
@property NSInteger pageIndex;
//title for page
@property NSString *titleText;
//image for page
@property NSString *imageFile;

@end
