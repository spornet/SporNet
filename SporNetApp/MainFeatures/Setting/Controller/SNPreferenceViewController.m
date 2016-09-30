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
//IBOutlets of all cells
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *radiusCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *schoolCell;

@property (weak, nonatomic) IBOutlet UILabel *mileLabel;
@property (weak, nonatomic) IBOutlet UISlider *mileSlider;

//array of cells for preference table.
@property (nonatomic) NSArray *cellArray;
@end

@implementation SNPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set cell array
    self.cellArray = @[self.genderCell, self.radiusCell, self.schoolCell];
}
#pragma mark - table view delegate & datasource

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
//IBOutlet for three switches.
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

- (IBAction)mileSliderValueDidChange:(UISlider *)sender {
    _mileLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_MILE_CHANGED" object:self.mileLabel.text];
    
}


@end
