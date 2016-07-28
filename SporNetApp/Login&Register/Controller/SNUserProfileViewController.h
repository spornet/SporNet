//
//  SNUserProfileViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 6/29/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UserProfileRow) {
    UserProfileRowPic = 0,
    UserProfileRowName,
    UserProfileRowGender,
    UserProfileRowBirthday,
    UserProfileRowGraduation,
    UserProfileRowBestSport,
    UserProfileRowSportTime,
    UserProfileRowAboutMe,
    UserProfileRowDone,
    UserProfileRowNumber
};
@interface SNUserProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
