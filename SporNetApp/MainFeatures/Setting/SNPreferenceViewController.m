//
//  SNPreferenceViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNPreferenceViewController.h"
typedef NS_ENUM(NSInteger, PreferenceRow) {
    PreferenceRowGender= 0,
    PreferenceRowRadius,
    PreferenceRowSchool,
    PreferenceRowGraduationYear,
    PreferenceRowNumber
};
typedef NS_ENUM(NSInteger, PreferenceSwitch) {
    PreferenceSwitchMale= 1,
    PreferenceSwitchFemale,
    PreferenceSwitchSchool
};
@interface SNPreferenceViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *radiusCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *schoolCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *graduationCell;
@property NSArray *cellArray;
@end

@implementation SNPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellArray = @[self.genderCell, self.radiusCell, self.schoolCell, self.graduationCell];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellArray[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cellArray[indexPath.row];
    return cell.frame.size.height;
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    switch (sender.tag) {
        case PreferenceSwitchMale:
            [[NSUserDefaults standardUserDefaults]setObject:sender.isOn?[NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO] forKey:@"searchPreferenceMale"];
            break;
        case PreferenceSwitchFemale:
            [[NSUserDefaults standardUserDefaults]setObject:sender.isOn?[NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO] forKey:@"searchPreferenceFemale"];
            break;
        case PreferenceSwitchSchool:
            [[NSUserDefaults standardUserDefaults]setObject:sender.isOn?[NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO] forKey:@"searchPreferenceOnlyMySchool"];
            break;
        default:
            break;
    }
}

@end
