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
#import "ProgressHUD.h"
#import "AVUser.h"
@interface SNLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstrainatBottom;



@end

@implementation SNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _userEmailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your school email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//method for login button
- (IBAction)login:(id)sender {
    if([_userEmailTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input username!"];
    } else if([_passwordTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input password!"];
    } else {
        [ProgressHUD show:@"Logging now..."];
        [AVUser logInWithUsernameInBackground:_userEmailTextfield.text password:_passwordTextfield.text block:^(AVUser *user, NSError *error) {
            if(error.code == 211)  {
                [ProgressHUD showError:@"Email doesn't exist!"];
            } else if (error.code == 210) {
                [ProgressHUD showError:@"Wrong password!"];
            } else{
                [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back, %@!", user.username]];
                [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
            }
        }];
    }
//    
//    //判断是否同时输入了邮箱和密码
//    if (_userEmailTextfield.text.length != 0 && _passwordTextfield.text.length !=0) {
//        //判断后台是否有用户数据
//        if (NO) {
//            //上面的if里如果有用户信息则值为YES，然后初始化search near by VC，改为NO是因为测试第一次登录时userProfile
//        }else
//        {
//        //第一次输入信息
//            [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
//        }
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Please fill all infomation" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
}

//method for forget password button
- (IBAction)forgetPassword {
    [self performSegueWithIdentifier:@"fpSegue" sender:nil];
}

//method for dont receive email
- (IBAction)dontRE {
    [self performSegueWithIdentifier:@"dreSegue" sender:nil];
}

//pass the segue condition in next view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SNFpDreViewController *destination = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fpSegue"]) {
        destination.isFp = YES;
    } else if([segue.identifier isEqualToString:@"dreSegue"]){
        destination.isFp = NO;
    }
    
}

//method for signup button
- (IBAction)signup:(id)sender {
    NSLog(@"did sign up");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    SNRegisterViewController *regVc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterPage"];
    
    [self.navigationController pushViewController:regVc animated:YES];

    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@,%@",NSStringFromRange(range),string);
    return YES;
    
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 280;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 200;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
