//
//  SNRegisterViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/5.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNRegisterViewController.h"
#import "ProgressHUD.h"
#import "AVUser.h"
@interface SNRegisterViewController ()<UITextFieldDelegate>
/**
 *  New User Email Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
/**
 *  New User Password Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/**
 *  New User Password Confirm Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmPwTextfield;
/**
 *  Autolayout Constraint
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

@end

@implementation SNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Up Navigation
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //Set Up UIAlert
    [self sendAlert:@"Only emails from XXX is valid."];
    
    //Set Up UI
    [self setupUI];
    
    //Set Up Keyboard
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

#pragma marks - Private Methods

- (void)setupUI {
    
    _emailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your school email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _confirmPwTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"confirm your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//method for tip button
- (IBAction)tipClick {
#warning UIAlertView 过期
    
    UIAlertView *tip = [[UIAlertView alloc]initWithTitle:@"Tip !" message:@"Please use your school email !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [tip show];

}

//method for submit
- (IBAction)submitClick {

    if([_emailTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please enter your email address!"];
        return;
    }
    if(![self validSchoolEmail:_emailTextfield.text]) {
        [ProgressHUD showError:@"Invalid email address!"];
        return;
    }
    if(![self validSchoolEmail:_emailTextfield.text]) {
        [ProgressHUD showError:@"Your School is not on our list, coming soon!"];
        return;
    }
    if([_passwordTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"You must input a password!"];
        return;
    }
    if(![_confirmPwTextfield.text isEqual:_passwordTextfield.text]) {
        [ProgressHUD showError:@"Two passwords mismatch."];
        return;
    }
    
    AVUser *user = [AVUser user];
    user.username = _emailTextfield.text;
    user.email = _emailTextfield.text;
    user.password = _passwordTextfield.text;
    [ProgressHUD show:@"Signing up now..."];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", error);
        if(error.code == 202) {
            [ProgressHUD showError:@"Username has already been taken!"];
            return;
        }
        if(error.code == 203) {
            [ProgressHUD showError:@"Email address has already been taken!"];
            return;
        }
        [ProgressHUD showSuccess:[NSString stringWithFormat:@"Signed up successfully!"]];
    }];
    

}

-(BOOL)validSchoolEmail:(NSString*)email {
#warning 这里要加入对学校email的判断
    return YES;
}
-(void)sendAlert:(NSString*)message {
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma marks - Keyboard Show & Hide

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.viewBottom.constant = 200;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.viewBottom.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
