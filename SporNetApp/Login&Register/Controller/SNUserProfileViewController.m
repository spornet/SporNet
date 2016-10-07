//
//  SNUserProfileViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 6/29/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//
#import "SNUser.h"
#import "SNUserProfileViewController.h"
#import <AVObject+Subclass.h>
#import "SNMainFeatureTabController.h"
#import "TimeManager.h"
#import "ProgressHUD.h"
#import "LocalDataManager.h"
#import "UIButton+WebCache.h"


#define PROFILE_IMAGE [UIImage imageNamed:@"profile"]
#define ADD_IMAGE [UIImage imageNamed:@"add"]
#define SELECTED_MAX_PROFILE_IMAGE 6

#define UserProfileRowNameHeight      80
#define UserProfileRowPicHeight       200
#define UserProfileRowBestSportHeight 80
#define UserProfileRowAboutMeHeight   100
#define UserProfileRowDefault         55

@interface SNUserProfileViewController ()
{
    //Options of GradYears
    NSArray  *_gradYears;
    //Options for Gender
    NSArray  *_genderArray;
    //Options for Sport time
    NSArray  *_sportTime;
    //Options for Best Sports
    NSArray  *_bestSportsPicArray;
    //Options for Best Sports Selected
    NSArray  *_bestSportsPicArraySelected;
    //Selected Image Tag
    NSInteger _selectedImageTag;
    //If Image Change
    BOOL      _imageDidChange;
}

//All Cells
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

@property (weak, nonatomic)   IBOutlet UILabel            *placeHolder;

//These two textfield are used to pop picker view. No use for data.
/**
 *  User First Name
 */
@property (strong, nonatomic) IBOutlet UITextField        *firstNameTextField;
/**
 *  User Last Name
 */
@property (strong, nonatomic) IBOutlet UITextField        *lastNameTextField;
/**
 *  Autolayout Constraint
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraint;
/**
 *  User's Sex
 */
@property (strong, nonatomic) IBOutlet UILabel            *sexLabel;
/**
 *  User's Birthday
 */
@property (strong, nonatomic) IBOutlet UILabel            *birthdayLabel;
/**
 *  User's Graduation Year
 */
@property (strong, nonatomic) IBOutlet UILabel            *gradLabel;
/**
 *  User's Sport Time
 */
@property (weak, nonatomic)   IBOutlet UILabel            *sportTimeLabel;

@property (strong, nonatomic) IBOutlet UIPickerView       *sexPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *graduationYearPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *sportTimePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker       *birthdayPicker;
@property (strong, nonatomic) IBOutlet UITextField        *sexTextField;
@property (strong, nonatomic) IBOutlet UITextField        *gradTextField;
@property (weak, nonatomic)   IBOutlet UITextField        *sportTimeTextField;
@property (weak, nonatomic)   IBOutlet UITextField        *birthdayTextField;
@property (strong, nonatomic) IBOutlet UITextView         *aboutmeTextView;

//********************************************************
/**
 *  Selected Sport ImageView
 */
@property (nonatomic, weak) UIImageView    *selectedBestSportImageView;
/**
 *  User Gender Selection
 */
@property (nonatomic, assign) GenderType    selectedGender;
/**
 *  User Sport Selection
 */
@property (nonatomic, assign) BestSports    selectedBestSport;
/**
 *  User Graduation Year Selection
 */
@property (nonatomic, assign) int           selectedGradYear;
/**
 *  User Sport Time Selection
 */
@property (nonatomic, assign) SportTimeSlot selectedSpotrTime;
/**
 *  User Birthday Selection
 */
@property (nonatomic, strong) NSDate*        selectedBirthday;
/**
 *  User Profile Image Array
 */
@property (nonatomic, strong) NSMutableArray *selectedProfileImageArray;
/**
 *  User Birthday Picker
 */
@property (weak, nonatomic)  UIPickerView     *birthdayPiker;

/**
 *  ImagePicker
 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/**
 *  Alert Controller
 */
@property (nonatomic, strong) UIAlertController       *alert;
@property (nonatomic, assign) NSInteger               sportTimeColorIndex;

@end

@implementation SNUserProfileViewController

#pragma mark - Lazy Load

-(UIImagePickerController *)imagePicker {
    
    if (_imagePicker == nil) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        
    }
    
    return _imagePicker;
}

-(UIAlertController*)alert {
    if(_alert == nil) {
        _alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Change Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:_selectedImageTag];
            if(_selectedImageTag == 1) {
                [selectedButton setBackgroundImage:PROFILE_IMAGE forState:normal];
            } else {
                [selectedButton setBackgroundImage:ADD_IMAGE forState:normal];
            }
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
    }
    return _alert;
}

- (UIImageView *)selectedBestSportImageView {
    
    if (_selectedBestSportImageView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        [self.bestSportCell addSubview:imageView];
        _selectedBestSportImageView = imageView;
    }
    
    return _selectedBestSportImageView;
}

#pragma mark - View Controller Method

- (void)viewDidLoad {
    [super viewDidLoad];
    //set delegates
    
    [self setUpDelegate];

    //set constant arrays
    
    [self setUpConstants];

    //set textField
    [self setUpTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    //Add tap gestures to 5 sport images
    for(int i = 1; i <= 5; i++) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportTapped:)];
        UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:i];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    //Set Up the Max Profile Image Number
    self.selectedProfileImageArray = [[NSMutableArray alloc]initWithCapacity:SELECTED_MAX_PROFILE_IMAGE];
    //LoadUser Info From Local
    
    bool isSecond = [[NSUserDefaults standardUserDefaults]objectForKey:KUSER_FIRST_REGISTER];
    
    if (isSecond) {
        
        [self loadUserInfoFromLocal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [self setSelectedBestSport:_selectedBestSport];
}

#pragma mark - Private Methods
/**
 *  Set Up Delegate
 */
- (void)setUpDelegate {
    
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.graduationYearPicker.delegate = self;
    self.graduationYearPicker.dataSource = self;
    self.sportTimePicker.delegate = self;
    self.sportTimePicker.dataSource = self;
    self.aboutmeTextView.delegate = self;
    
    [self.birthdayPicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
}
/**
 *  Set Up All Constant Arrays
 */
- (void)setUpConstants {
    
    _gradYears = @[@"2016",@"2017",@"2018",@"2019",@"2020"];
    _genderArray = @[@"Male", @"Female"];
    _sportTime = @[@"Morning",@"Noon",@"Afternoon",@"Evening"];
    _bestSportsPicArray = @[@"jogging", @"muscle", @"soccer", @"basketball", @"yoga"];
    _bestSportsPicArraySelected = @[@"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];
    _imageDidChange = NO;

}
/**
 *  Set Up TextField
 */
- (void)setUpTextField {
    
    self.sexTextField.inputView = self.sexPicker;
    self.gradTextField.inputView = self.graduationYearPicker;
    self.sportTimeTextField.inputView = self.sportTimePicker;
    self.birthdayTextField.inputView = self.birthdayPicker;
    self.lastNameTextField.adjustsFontSizeToFitWidth = YES;
    self.lastNameTextField.minimumFontSize = 8;
}

/**
 *  Profile Picture Clicked
 */
- (IBAction)picButtonClicked:(UIButton *)sender {
    _selectedImageTag = sender.tag;
    
    if([sender.currentBackgroundImage isEqual:PROFILE_IMAGE] | [sender.currentBackgroundImage isEqual:ADD_IMAGE]) {
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        [self presentViewController:self.alert animated:YES completion:nil];
    }
}

/**
 *  User Sport Image Tapped
 */
- (void)sportTapped:(UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView*)tapGesture.view;
    self.selectedBestSport = (BestSports)image.tag;
    
}

/**
 *  Birthday Picker Clicked
 *
 *  @param sender Birthday Picker
 */
-(void)dateSelected:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:date];
    self.selectedBirthday = date;
}

/**
 *  User Finished all the basic info
 *
 *  @param UIButton
 */
- (IBAction)doneClicked:(UIButton *)sender {
    
    bool editProfile = [[NSUserDefaults standardUserDefaults]boolForKey:@"editUserProfile"];
    
    if (editProfile) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Are you sure to edit your profile?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [ProgressHUD show:@"Saving..."];
            [self setIcon];
            [self saveOnLocal];
            [LocalDataManager updateProfileInfoOnCloudInBackground];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegate respondsToSelector:@selector(EditDoneDidClicked)]) {
                
                [self.delegate EditDoneDidClicked];
                [ProgressHUD dismiss];
            }
            
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:yesAction];
        [alertVC addAction:noAction];
        [self presentViewController:alertVC animated:yesAction completion:nil];
        
    }else {
        
        if ([self checkAllUserInputs]) {
            
            [self setIcon];
            [self saveOnLocal];
            SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
            [self presentViewController:tabVC animated:YES completion:nil];
            [LocalDataManager updateProfileInfoOnCloudInBackground];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KUSER_FIRST_REGISTER];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
    
    
}

/**
 *  Check All User Input
 *
 *  @return Yes means user has fill out all basic info. Return No means at least one is not filled out
 */
- (BOOL)checkAllUserInputs {
    
    for(int i = 1; i <= 6; i++) {
        UIButton *button = (UIButton*)[self.picCell viewWithTag:i];
        if ([button.currentBackgroundImage isEqual:PROFILE_IMAGE]) {
            
            [ProgressHUD showError:@"You need at least One Profile Picture"];
            return NO;
        }
    }
    
    if ([self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""]) {
        
        [ProgressHUD showError:@"Please complete your name"];
        
        return NO;
        
    }else if (self.selectedGender == 0) {
        
        [ProgressHUD showError:@"Please select your gender"];
        
        return NO;
        
    }else if (self.selectedBirthday == nil) {
        
        [ProgressHUD showError:@"Please select your birthday"];
        
        return NO;
        
    }else if (self.selectedGradYear == 0) {
        
        [ProgressHUD showError:@"Please select your graduation year"];
        
        return NO;
    }else if (self.selectedBestSport == 0) {
        
        [ProgressHUD showError:@"Please select your sport"];
        
        return NO;

    }else if (self.selectedSpotrTime == 0) {
        
        [ProgressHUD showError:@"Please select your sport time"];
        
        return NO;
        
    }else if ([self.aboutmeTextView.text isEqualToString:@""]) {
        
        [ProgressHUD showError:@"Please write a little bit about yourself"];
        
        return NO;

    }
    
    return YES;
}

/**
 *  Resize Image
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
#warning 可以把这个方法写成工具类
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Keyboard Method
/**
 *  Keyboard Frame Change Method
 *
 *  @param notification 
 */
- (void)keyboardWillChange:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.aboutmeTextView isFirstResponder]? keyboardSize.height:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

/**
 *  KeyBoard Dismiss
 */
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}



#pragma mark - Table view delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UserProfileRowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case UserProfileRowName:
            height = UserProfileRowNameHeight;
            break;
        case UserProfileRowPic:
            height = UserProfileRowPicHeight;
            break;
        case UserProfileRowBestSport:
            height = UserProfileRowBestSportHeight;
            break;

        case UserProfileRowAboutMe:
            height = UserProfileRowAboutMeHeight;
            break;
        default:
            height = UserProfileRowDefault;
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
            [self.birthdayTextField becomeFirstResponder];
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
            [self.sportTimeTextField becomeFirstResponder];
            [self pickerViewWillShow];
            break;
            
        default:
            break;
    }
}
#pragma mark - Save and Load Data Methods

/**
 *  Save User Profile Image (First Image Icon), Upload to LeanCloud
 */
- (void)setIcon {
    //set icon image
    UIButton *button = (UIButton*)[self.picCell viewWithTag:1];
    [[[AVUser currentUser]objectForKey:@"icon"]deleteInBackground];
    [[AVUser currentUser] setObject:[AVFile fileWithData:UIImagePNGRepresentation([self imageWithImage:button.currentBackgroundImage scaledToSize:CGSizeMake(100, 100)])] forKey:@"icon"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (succeeded) {
            
            [self.user setObject:[[AVUser currentUser] objectForKey:@"icon"] forKey:@"icon"];
            [self.user save];
        }
        
    }];

}

/**
 *  Save all User Basic Info to Local SandBox
 */
-(void)saveOnLocal {
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    
    NSMutableArray *imageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1; i <= 6; i++) {
        UIButton *button = (UIButton*)[self.picCell viewWithTag:i];
        if([button.currentBackgroundImage isEqual:PROFILE_IMAGE] | [button.currentBackgroundImage isEqual:ADD_IMAGE]) continue;
        [imageDataArr addObject:UIImageJPEGRepresentation(button.currentBackgroundImage, 0.2)];
    }

    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects:
                                    self.firstNameTextField.text,
                                    self.lastNameTextField.text,
                                    [NSNumber numberWithInteger:self.selectedGender],
                                    self.selectedBirthday,
                                    [NSNumber numberWithInteger:self.selectedGradYear],
                                    [NSNumber numberWithInteger:self.selectedBestSport],
                                    [NSNumber numberWithInteger:self.selectedSpotrTime],
                                    self.aboutmeTextView.text,
                                    imageDataArr, nil]
                                    forKeys:[NSArray arrayWithObjects: @"firstName", @"lastName",@"gender", @"dateOfBirth",@"gradYear",@"bestSport",@"sportTimeSlot",@"aboutMe",@"photoes", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"plist writte successfully");
    }
}

/**
 *  Load User Basic Info from Sandbox
 */
-(void)loadUserInfoFromLocal {
#warning 可以优化代码
     NSString *plistPath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"basicInfo" ofType:@"plist"];
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.firstNameTextField.text = [dict objectForKey:@"firstName"];
    self.lastNameTextField.text = [dict objectForKey:@"lastName"];
    self.selectedGender = (BOOL)[dict objectForKey:@"gender"];
    self.sexLabel.text = (BOOL)[dict objectForKey:@"gender"]? @"Female":@"Male";
    self.selectedBirthday = [dict objectForKey:@"dateOfBirth"];
    self.birthdayLabel.text = [TimeManager getDateString:self.selectedBirthday];
    self.selectedSpotrTime = [[dict objectForKey:@"sportTimeSlot"]integerValue];
    self.sportTimeLabel.text = SPORTSLOT_ARRAY[self.selectedSpotrTime -1];
    self.sportTimeLabel.backgroundColor = SPORTSLOT_COLOR_ARRAY[self.selectedSpotrTime - 1];
    self.selectedBestSport = [[dict objectForKey:@"bestSport"]integerValue];
    self.selectedGradYear = (int)[[dict objectForKey:@"gradYear"]integerValue];
    self.gradLabel.text = [NSString stringWithFormat:@"%d", self.selectedGradYear];
    self.aboutmeTextView.text = [dict objectForKey:@"aboutMe"];
    if([[dict objectForKey:@"aboutMe"] isEqual:@""]){
        
        _placeHolder.hidden = NO;
    }
    _placeHolder.hidden = YES;
    NSArray *imageDataArr = [dict objectForKey:@"photoes"];
    int i = 1;
    for (NSData *data in imageDataArr) {
        [((UIButton*)[self.picCell viewWithTag:i]) setBackgroundImage:[UIImage imageWithData:data] forState:normal];
        i++;
    }
}

#pragma mark - Picker view delegate & datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        return 2;
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return _gradYears.count;
    } else{
        return _sportTime.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.sexPicker]) {
        return _genderArray[row];
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return _gradYears[row];
    }else{
        return _sportTime[row];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        self.sexLabel.text = _genderArray[row];
        self.selectedGender = (GenderType)row + 1;
        
    } else if([pickerView isEqual:self.graduationYearPicker]){
        self.gradLabel.text = _gradYears[row];
        self.selectedGradYear = [self.gradLabel.text intValue];
    }else{
        self.sportTimeLabel.text = _sportTime[row];
        self.sportTimeLabel.backgroundColor = SPORTSLOT_COLOR_ARRAY[row];
        self.sportTimeColorIndex = row;
        self.selectedSpotrTime = (SportTimeSlot)row + 1;
    }
}

-(void)pickerViewWillShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.sportTimeTextField isFirstResponder]? 150:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - Scroll view delegate.
//dismiss keyboard when the table view start scrolling
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self dismissKeyboard];
    }
}

//load user information if already has a user
//-(void)loadUserInfo {
//    NSLog(@"BEGIN LOADING");
//    self.firstNameTextField.text = [[[AVUser currentUser] objectForKey:@"name" ] componentsSeparatedByString:@" "][0];
//    self.lastNameTextField.text = [[[AVUser currentUser] objectForKey:@"name" ] componentsSeparatedByString:@" "][1];
//    self.sexLabel.text = (BOOL)[_user objectForKey:@"gender"]? @"Female":@"Male";
//    self.selectedGender = (BOOL)[_user objectForKey:@"gender"];
//    self.birthdayLabel.text = [TimeManager getDateString:[_user objectForKey:@"dateOfBirth"]];
//    self.selectedBirthday = [_user objectForKey:@"dateOfBirth"];
//
//    self.selectedGradYear = (int)[[_user objectForKey:@"gradYear"] integerValue];
//    self.gradLabel.text = [NSString stringWithFormat:@"%d", self.selectedGradYear];
//
//    self.selectedSpotrTime = [[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue];
//    self.sportTimeLabel.text = SPORTSLOT_ARRAY[self.selectedSpotrTime];
//    self.aboutmeTextView.text = [_user objectForKey:@"aboutMe"];
//    
//    if([[_user objectForKey:@"aboutMe"] isEqual:@""]) _placeHolder.hidden = NO;
//    else _placeHolder.hidden = YES;
//    _placeHolder.hidden = YES;
//    self.selectedBestSport = [[[AVUser currentUser]objectForKey:@"bestSport"]integerValue];
//    NSMutableArray *arr = [_user objectForKey:@"ProfilePhotoes"];
//    NSLog(@"count is %ld", arr.count);
//    int i = 1;
//    for (AVObject *obj in arr) {
//        NSLog(@"我就看看你执行不执行");
//        [AVFile getFileWithObjectId:obj.objectId withBlock:^(AVFile *file, NSError *error) {
//            [((UIButton*)[self.picCell viewWithTag:i]) setBackgroundImage:[UIImage imageWithData:[file getData]] forState:normal];
//        }];
//        i++;
//    }
//}

#pragma mark - ImagePicker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _imageDidChange = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:_selectedImageTag];
    [selectedButton setBackgroundImage:chosenImage forState:normal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Setter Method
/**
 *  Set SelectedBestSport Property
 */
-(void)setSelectedBestSport:(BestSports)selectedBestSport {

    _selectedBestSport = selectedBestSport;
    UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:selectedBestSport];
    
    self.selectedBestSportImageView.frame = CGRectMake(imageView.frame.origin.x - 5, imageView.frame.origin.y - 5, imageView.frame.size.width + 10, imageView.frame.size.height + 10);
    self.selectedBestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[selectedBestSport]];
    
}

#pragma mark - UITextField Delegate

-(void)textViewDidChange:(UITextView *)textView {
    if([textView.text isEqual:@""]) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
}

@end
