//
//  SNFpDreViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/12.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNFpDreViewController.h"

@interface SNFpDreViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@end

@implementation SNFpDreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resend:(id)sender {
    if (_isFp) {
        NSLog(@"Send a link for forget password");
    } else {
        NSLog(@"Send another confirm email");
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

@end
