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
#import "SNMainFeatureTabController.h"
#import "TimeManager.h"
#import "ProgressHUD.h"
#import "LocalDataManager.h"
#import "UIButton+WebCache.h"
#define PROFILE_IMAGE [UIImage imageNamed:@"profile"]
#define ADD_IMAGE [UIImage imageNamed:@"add"]
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

@property (weak, nonatomic) IBOutlet UILabel *placeHolder;

//These two textfield are used to pop picker view. No use for data.
@property (strong, nonatomic) IBOutlet UITextField        *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField        *lastNameTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraint;
@property (strong, nonatomic) IBOutlet UILabel            *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel            *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel            *gradLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView       *sexPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *graduationYearPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *sportTimePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (strong, nonatomic) IBOutlet UITextField        *sexTextField;
@property (strong, nonatomic) IBOutlet UITextField        *gradTextField;
@property (weak, nonatomic) IBOutlet UITextField *sportTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (strong, nonatomic) IBOutlet UITextView         *aboutmeTextView;
@property UIImageView *selectedBestSportImageView;
//gender selected by user
@property GenderType selectedGender;
//best sport selected by user
@property(nonatomic) BestSports selectedBestSport;
//graduation year selected by user
@property int selectedGradYear;
//sport time selected by user
@property SportTimeSlot selectedSpotrTime;
//birthday of user selected
@property NSDate* selectedBirthday;
//profile images selected by user
@property NSMutableArray *selectedProfileImageArray;

@property (weak, nonatomic  ) UIPickerView                *birthdayPiker;

//image picker controller
@property(nonatomic) UIImagePickerController *imagePicker;
//alert controller
@property(nonatomic) UIAlertController *alert;

@end

@implementation SNUserProfileViewController
//select options of gradYears
NSArray *gradYears;
//select options for gender
NSArray *genderArray;
//select options for sport time
NSArray *sportTime;

NSArray *bestSportsPicArray;
NSArray *bestSportsPicArraySelected;
NSInteger selectedImageTag;

BOOL imageDidChange;
- (void)viewDidLoad {
    [super viewDidLoad];
    //set delegates
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.graduationYearPicker.delegate = self;
    self.graduationYearPicker.dataSource = self;
    self.sportTimePicker.delegate = self;
    self.sportTimePicker.dataSource = self;
    self.aboutmeTextView.delegate = self;
    [self.birthdayPicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    //set constant arrays
    gradYears = @[@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021"];
    genderArray = @[@"Male", @"Female"];
    sportTime = @[@"Morning",@"Noon",@"Afternoon",@"Evening"];
    bestSportsPicArray = @[@"jogging", @"muscle", @"soccer", @"basketball", @"yoga"];
    bestSportsPicArraySelected = @[@"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];

    //set pickers as input views of textfields.
    self.sexTextField.inputView = self.sexPicker;
    self.gradTextField.inputView = self.graduationYearPicker;
    self.sportTimeTextField.inputView = self.sportTimePicker;
    self.birthdayTextField.inputView = self.birthdayPicker;
    self.lastNameTextField.adjustsFontSizeToFitWidth = YES;
    self.lastNameTextField.minimumFontSize = 8;
    //add tap gestures to 5 sport images.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    for(int i = 1; i <= 5; i++) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportTapped:)];
        UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:i];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    self.selectedProfileImageArray = [[NSMutableArray alloc]initWithCapacity:6];
    //[self loadUserInfo];
    [self loadUserInfoFromLocal];
    imageDidChange = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [self setSelectedBestSport:_selectedBestSport];
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
        case UserProfileRowName:
            height = 80;
            break;
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
        case  UserProfileRowDone:{
            NSLog(@"save action");
            [self setIcon];
            [self saveOnLocal];
            SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
            [self presentViewController:tabVC animated:YES completion:nil];
            [LocalDataManager updateProfileInfoOnCloudInBackground];
            break;
        }
        default:
            break;
    }
}
-(void)saveOnLocal {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"basicInfo.plist"];
    
    NSMutableArray *imageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1; i <= 6; i++) {
        UIButton *button = (UIButton*)[self.picCell viewWithTag:i];
        if([button.currentBackgroundImage isEqual:PROFILE_IMAGE] | [button.currentBackgroundImage isEqual:ADD_IMAGE]) continue;
        [imageDataArr addObject:UIImageJPEGRepresentation(button.currentBackgroundImage, 0.2)];
    }

    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: self.firstNameTextField.text, self.lastNameTextField.text, [NSNumber numberWithInteger:self.selectedGender], self.selectedBirthday, [NSNumber numberWithInteger:self.selectedGradYear], [NSNumber numberWithInteger:self.selectedBestSport], [NSNumber numberWithInteger:self.selectedSpotrTime],self.aboutmeTextView.text, imageDataArr, nil] forKeys:[NSArray arrayWithObjects: @"firstName", @"lastName",@"gender", @"dateOfBirth",@"gradYear",@"bestSport",@"sportTimeSlot",@"aboutMe",@"photoes", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"plist writte successfully");
    } else {
        NSLog(@"plist failed");
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
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return gradYears.count;
    } else{
        return sportTime.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.sexPicker]) {
        return genderArray[row];
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return gradYears[row];
    }else{
        return sportTime[row];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        self.sexLabel.text = genderArray[row];
        self.selectedGender = (GenderType)row;
    } else if([pickerView isEqual:self.graduationYearPicker]){
        self.gradLabel.text = gradYears[row];
        self.selectedGradYear = [self.gradLabel.text intValue];
    }else{
        self.sportTimeLabel.text = sportTime[row];
        self.selectedSpotrTime = (SportTimeSlot)row;
    }
}


#pragma mark - Scroll view delegate.
//dismiss keyboard when the table view start scrolling
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self dismissKeyboard];
    }
}


//When the best sport image is tapped, reset that image.
- (void)sportTapped:(UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView*)tapGesture.view;
    self.selectedBestSport = (BestSports)image.tag;
}

-(void)pickerViewWillShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.sportTimeTextField isFirstResponder]? 150:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
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


//load user information if already has a user
-(void)loadUserInfo {
    NSLog(@"BEGIN LOADING");
    self.firstNameTextField.text = [[[AVUser currentUser] objectForKey:@"name" ] componentsSeparatedByString:@" "][0];
    self.lastNameTextField.text = [[[AVUser currentUser] objectForKey:@"name" ] componentsSeparatedByString:@" "][1];
    self.sexLabel.text = (BOOL)[_user objectForKey:@"gender"]? @"Female":@"Male";
    self.selectedGender = (BOOL)[_user objectForKey:@"gender"];
    self.birthdayLabel.text = [TimeManager getDateString:[_user objectForKey:@"dateOfBirth"]];
    self.selectedBirthday = [_user objectForKey:@"dateOfBirth"];

    self.selectedGradYear = (int)[[_user objectForKey:@"gradYear"] integerValue];
    self.gradLabel.text = [NSString stringWithFormat:@"%d", self.selectedGradYear];

    self.selectedSpotrTime = [[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue];
    self.sportTimeLabel.text = SPORTSLOT_ARRAY[self.selectedSpotrTime];
    self.aboutmeTextView.text = [_user objectForKey:@"aboutMe"];
    
    if([[_user objectForKey:@"aboutMe"] isEqual:@""]) _placeHolder.hidden = NO;
    else _placeHolder.hidden = YES;
    _placeHolder.hidden = YES;
    self.selectedBestSport = [[[AVUser currentUser]objectForKey:@"bestSport"]integerValue];
    NSMutableArray *arr = [_user objectForKey:@"ProfilePhotoes"];
    NSLog(@"count is %ld", arr.count);
    int i = 1;
    for (AVObject *obj in arr) {
        NSLog(@"我就看看你执行不执行");
        [AVFile getFileWithObjectId:obj.objectId withBlock:^(AVFile *file, NSError *error) {
            [((UIButton*)[self.picCell viewWithTag:i]) setBackgroundImage:[UIImage imageWithData:[file getData]] forState:normal];
        }];
        i++;
    }
}
-(void)loadUserInfoFromLocal {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"basicInfo.plist"];
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
    self.sportTimeLabel.text = SPORTSLOT_ARRAY[self.selectedSpotrTime];
    self.selectedBestSport = [[dict objectForKey:@"bestSport"]integerValue];
    self.selectedGradYear = (int)[[dict objectForKey:@"gradYear"]integerValue];
    self.gradLabel.text = [NSString stringWithFormat:@"%d", self.selectedGradYear];
    self.aboutmeTextView.text = [dict objectForKey:@"aboutMe"];
    if([[dict objectForKey:@"aboutMe"] isEqual:@""]) _placeHolder.hidden = NO;
    else _placeHolder.hidden = YES;
    _placeHolder.hidden = YES;
    NSMutableArray *imageDataArr = [dict objectForKey:@"photoes"];
    int i = 1;
    for (NSData *data in imageDataArr) {
        [((UIButton*)[self.picCell viewWithTag:i]) setBackgroundImage:[UIImage imageWithData:data] forState:normal];
        i++;
    }
}
//save user icon
- (void)setIcon {
    //set icon image
    UIButton *button = (UIButton*)[self.picCell viewWithTag:1];
    [[[AVUser currentUser]objectForKey:@"icon"]deleteInBackground];
    [[AVUser currentUser] setObject:[AVFile fileWithData:UIImagePNGRepresentation([self imageWithImage:button.currentBackgroundImage scaledToSize:CGSizeMake(100, 100)])] forKey:@"icon"];
    [[AVUser currentUser]saveInBackground];
    [_user setObject:[[AVUser currentUser] objectForKey:@"icon"] forKey:@"icon"];
    [_user saveInBackground];
}

-(void)dateSelected:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:date];
    self.selectedBirthday = date;
}
- (IBAction)picButtonClicked:(UIButton *)sender {
    selectedImageTag = sender.tag;
    if(!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
    }
    if([sender.currentBackgroundImage isEqual:PROFILE_IMAGE] | [sender.currentBackgroundImage isEqual:ADD_IMAGE]) {
        [self presentViewController:_imagePicker animated:true completion:nil];
    } else {
        [self presentViewController:self.alert animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    imageDidChange = YES;
    NSLog(@"哈哈哈哈啊哈");
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:selectedImageTag];
    [selectedButton setBackgroundImage:chosenImage forState:normal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
/**
 *  initiate action sheet for when there are photos in picCell.
 *
 *  @return alert
 */
-(UIAlertController*)alert {
    if(_alert == nil) {
        _alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Change Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:selectedImageTag];
            if(selectedImageTag == 1) {
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
-(void)setSelectedBestSport:(BestSports)selectedBestSport {
    if(!_selectedBestSportImageView){
        _selectedBestSportImageView = [[UIImageView alloc]init];
        [self.bestSportCell addSubview:_selectedBestSportImageView];
    }
    _selectedBestSport = selectedBestSport;
    UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:selectedBestSport];
    _selectedBestSportImageView.frame = CGRectMake(imageView.frame.origin.x - 5, imageView.frame.origin.y - 5, imageView.frame.size.width + 10, imageView.frame.size.height + 10);
//    _selectedBestSportImageView.image = [UIImage imageNamed: bestSportsPicArraySelected[selectedBestSport-1]];
}
-(void)textViewDidChange:(UITextView *)textView {
    if([textView.text isEqual:@""]) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
