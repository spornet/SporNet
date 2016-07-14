//
//  SNUserProfileViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 6/29/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//
#import "SNUser.h"
#import "SNUserProfileViewController.h"
#import <AVObject+Subclass.h>
@interface SNUserProfileViewController ()



@property (strong, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell    *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *graduationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *bestSportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *sportTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *aboutMeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *picCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *doneCell;
//These two textfield are used to pop picker view. No use for data.
@property (strong, nonatomic) IBOutlet UITextField        *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField        *lastNameTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraint;
@property (strong, nonatomic) IBOutlet UILabel            *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel            *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel            *gradLabel;
@property (strong, nonatomic) IBOutlet UIPickerView       *sexPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *graduationYearPicker;
@property (strong, nonatomic) IBOutlet UITextField        *sexTextField;
@property (strong, nonatomic) IBOutlet UITextField        *gradTextField;
@property (strong, nonatomic) IBOutlet UITextView         *aboutmeTextView;

//gender selected by user
@property GenderType selectedGender;
//best sport selected by user
@property BestSports selectedBestSport;
//graduation year selected by user
@property int selectedGradYear;

@property (weak, nonatomic  ) UIPickerView                *birthdayPiker;
@end

@implementation SNUserProfileViewController
//select options of gradYears
NSArray *gradYears;
//select options for gender
NSArray *genderArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    //set delegates
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.graduationYearPicker.delegate = self;
    self.graduationYearPicker.dataSource = self;
    self.aboutmeTextView.delegate = self;
    //set constant arrays
    gradYears = @[@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021"];
    genderArray = @[@"Male", @"Female"];
    //set pickers as input views of textfields.
    self.sexTextField.inputView = self.sexPicker;
    self.gradTextField.inputView = self.graduationYearPicker;
    //add tap gestures to 5 sport images.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportTapped:)];
    UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:2];
    [imageView addGestureRecognizer:tapRecognizer];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    for(int i = 1; i <= 5; i++) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportTapped:)];
 
        UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:i];
        [imageView addGestureRecognizer:tapRecognizer];
    }
}
#pragma mark - Table view delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UserProfileRowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case UserProfileRowPic:
            height = 200;
            break;
        case UserProfileRowBestSport:
            height = 80;
            break;

        case UserProfileRowAboutMe:
            height = 100;
            break;
        default:
            height = 55;
            break;
    }
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case UserProfileRowPic:
            cell = self.picCell;
            break;
        case UserProfileRowName:
            cell = self.nameCell;
            break;
        case UserProfileRowGender:
            cell = self.genderCell;
            break;
        case UserProfileRowBirthday:
            cell = self.birthdayCell;
            break;
        case  UserProfileRowGraduation:
            cell = self.graduationCell;
            break;
        case UserProfileRowBestSport:
            cell = self.bestSportCell;
            break;
        case  UserProfileRowSportTime:
            cell = self.sportTimeCell;
            break;
        case UserProfileRowAboutMe:
            cell = self.aboutMeCell;
            break;
        case UserProfileRowDone:
            cell = self.doneCell;
            break;
        default:
            cell = nil;
            break;
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    switch (indexPath.row) {
        case UserProfileRowGender:
            NSLog(@"select gender");
            [self.sexTextField becomeFirstResponder];
            break;
        case UserProfileRowBirthday:
            NSLog(@"select birthday");
            break;
        case UserProfileRowGraduation:
            NSLog(@"Select graduation");
            [self.gradTextField becomeFirstResponder];
            break;
        case UserProfileRowBestSport:
            NSLog(@"Select best sport");
            break;
        case UserProfileRowSportTime:
            NSLog(@"select sport time");
            break;
        case  UserProfileRowDone:
            NSLog(@"save action");
            [self demoCreateObject];
            break;
            //[self saveData];
        default:
            break;
    }
}
//dismiss keyboard with animation
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
#pragma mark - Picker view delegate & datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        return 2;
    } else {
        return gradYears.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.sexPicker]) {
        return genderArray[row];
    } else {
        return gradYears[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        self.sexLabel.text = genderArray[row];
        self.selectedGender = (GenderType)row;
    } else {
        self.gradLabel.text = gradYears[row];
        self.selectedGradYear = [self.gradLabel.text intValue];
    }
}


#pragma mark - Scroll view delegate.
//dismiss keyboard when the table view start scrolling
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}


//When the best sport image is tapped, reset that image.
- (void)sportTapped:(UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView*)tapGesture.view;
    image.image = [UIImage imageNamed:@"yoga"];
    self.selectedBestSport = (BestSports)image.tag;
}
#pragma mark - move about me textview with animation when keyboard popping up.
- (void)keyboardWillChange:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.aboutmeTextView isFirstResponder]? keyboardSize.height:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
//save user information
- (void)demoCreateObject {
    //更新的时候，得把NSInteger值转为NSNumber
    //AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:@"5776986f5e10720046e19002"];
    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [user setObject:[NSString stringWithFormat:@"%@ %@", self.firstNameTextField.text, self.lastNameTextField.text] forKey:@"name"];
    [user setObject:[NSNumber numberWithInteger:self.selectedGradYear] forKey:@"gradYear"];
    [user setObject:[NSNumber numberWithInt:self.selectedGender] forKey:@"gender"];
    [user setObject:[NSNumber numberWithInteger:self.selectedBestSport] forKey:@"bestSport"];
    [user setObject:[NSNumber numberWithInteger:SportTimeSlotNight] forKey:@"sportTimeSlot"];
    [user setObject:self.aboutmeTextView.text forKey:@"aboutMe"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"存储成功哈哈哈");
        } else {
            NSLog(@"存储失败");
        }
    }];
}
@end
