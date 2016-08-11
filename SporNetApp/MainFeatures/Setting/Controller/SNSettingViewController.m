//
//  SNSettingViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNSettingViewController.h"
#import "SNPreferenceViewController.h"
#import "SNUserProfileViewController.h"
#import "globalMacros.h"
#import "AVUser.h"
#import "AVFile.h"
#import "ProgressHUD.h"
typedef NS_ENUM(NSInteger, SettingRow) {
    SettingRowSearchPreference= 0,
    SettingRowChangePassword,
    SettingRowContactUs,
    SettingRowRateUs,
    SettingRowNumber
};

@interface SNSettingViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sportColorView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userBlurImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bestSportImageView;
//Text array for setting view.
@property(nonatomic) NSArray *settingTextArray;
@end

@implementation SNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set user photo to round shape
    self.sportColorView.clipsToBounds = YES;
    [self.sportColorView.layer setCornerRadius:55];
    self.userImageView.clipsToBounds = YES;
    [self.userImageView.layer setCornerRadius:50];
    //load profile image
    [self loadProfileView];
    //add tap gesture to user photo. When tapped, go to user profile page.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                   action:@selector(userImageTapped)];
    [self.userImageView addGestureRecognizer:tap];
}
#pragma mark- table view delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SettingRowNumber;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleTableIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.settingTextArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SettingRowSearchPreference:{
//            SNPreferenceViewController *preferenceVC = [[SNPreferenceViewController alloc] init];
//            [self.navigationController pushViewController:preferenceVC animated:YES];
                [self performSegueWithIdentifier:@"toPreferenceSegue" sender:nil];
            
        }
            break;
        case SettingRowChangePassword:
            NSLog(@"%@", @"Go to change password!");
            break;
        case SettingRowContactUs:
            NSLog(@"%@", @"Contact us");
            break;
        case SettingRowRateUs:
            NSLog(@"%@", @"Rate us");
            break;
        default:
            break;
    }
}

// blur the top background image
-(void)setBlurTopImage:(UIImage*)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    self.userBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
//    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(0, 100, 50, 100)];
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(75, 375, SCREEN_WIDTH+150, self.userBlurImageView.frame.size.height + 150)];
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    self.userBlurImageView.image = blurImage;
    self.userBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
}

//load setting profile
-(void)loadProfileView {
    if([[AVUser currentUser]objectForKey:@"icon"]) self.userImageView.image = [UIImage imageWithData:[[[AVUser currentUser]objectForKey:@"icon"]getData]];
    [self setBlurTopImage:self.userImageView.image];
    self.sportColorView.backgroundColor = SPORTSLOT_COLOR_ARRAY[[[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue]];
}
//setter for text array
-(NSArray*)settingTextArray {
    if(_settingTextArray == nil) {
        _settingTextArray = @[@"Search Preference",@"Change Password", @"Contact Us", @"Rate Us"];
    }
    return _settingTextArray;
}
//go to user profile page when image tapped
-(void)userImageTapped {
    SNUserProfileViewController *profileVC = [[SNUserProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)logOutAction:(id)sender {
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    UIViewController *loginVC = [login instantiateInitialViewController];
    [self presentViewController:loginVC animated:YES completion:nil];
}
@end
