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
// 账户相关Row
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

@end

@implementation SNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sportColorView.clipsToBounds = YES;
    [self.sportColorView.layer setCornerRadius:55];
    self.userImageView.clipsToBounds = YES;
    [self.userImageView.layer setCornerRadius:50];
    [self setBlurTopImage:self.userImageView.image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                   action:@selector(userImageTapped)];
    
    [self.userImageView addGestureRecognizer:tap];
}
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
    switch (indexPath.row) {
        case SettingRowSearchPreference:
            cell.textLabel.text = @"Search Preference";
            break;
        case SettingRowChangePassword:
            cell.textLabel.text = @"Change Password";
            break;
        case SettingRowContactUs:
            cell.textLabel.text = @"Contact Us";
            break;
        case SettingRowRateUs:
            cell.textLabel.text = @"Rate Us";
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
-(void)setBlurTopImage:(UIImage*)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(0, 130, 375, 200)];
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    self.userBlurImageView.image = blurImage;
    self.userBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SettingRowSearchPreference:{
            SNPreferenceViewController *preferenceVC = [[SNPreferenceViewController alloc] init];
            [self.navigationController pushViewController:preferenceVC animated:YES];
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
-(void)userImageTapped {
    SNUserProfileViewController *profileVC = [[SNUserProfileViewController alloc] init];
    [self.navigationController pushViewController:profileVC animated:YES];
}
- (IBAction)logOutAction:(id)sender {
    NSLog(@"%@", @"Log Out");
}
@end
