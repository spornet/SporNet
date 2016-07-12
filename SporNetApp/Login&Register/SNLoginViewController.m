//
//  SNLoginViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/11.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNLoginViewController.h"
#import "SNRegisterViewController.h"
#import "SNFpDreViewController.h"

@interface SNLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation SNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _userEmailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your school email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    //判断是否同时输入了邮箱和密码
    if (_userEmailTextfield.text.length != 0 && _passwordTextfield.text.length !=0) {
        //判断后台是否有用户数据
        if (NO) {
            //上面的if里如果有用户信息则值为YES，然后初始化search near by VC，改为NO是因为测试第一次登录时userProfile
        }else
        {
        //第一次输入信息
            [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Please fill all infomation" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (IBAction)forgetPassword {
    [self performSegueWithIdentifier:@"fpSegue" sender:nil];
}


- (IBAction)dontRE {
    [self performSegueWithIdentifier:@"dreSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SNFpDreViewController *destination = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fpSegue"]) {
        destination.isFp = YES;
    } else {
        destination.isFp = NO;
    }
    
}

- (IBAction)signup:(id)sender {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    SNRegisterViewController *regVc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterPage"];
    
    [self.navigationController pushViewController:regVc animated:YES];

    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@,%@",NSStringFromRange(range),string);
    return YES;
    
}
@end
