//
//  SNRegisterViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/5.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNRegisterViewController.h"

@interface SNRegisterViewController ()<UITextFieldDelegate>

@end

@implementation SNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@ %@", NSStringFromRange(range),string);
    return YES;
}

@end
