//
//  SNMainFeatureTabController.m
//  SporNetApp
//
//  Created by Peng on 6/27/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMainFeatureTabController.h"
#import "SNSettingViewController.h"
#import "SNTagSecondViewController.h"
#import "SNTagMainViewController.h"

@interface SNMainFeatureTabController () <UITabBarControllerDelegate>

@end

@implementation SNMainFeatureTabController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupTabbarItem];
        self.delegate = self;

        }
 
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];
    
    
    [self setupChildControllers];

}

#pragma mark - Private Methods

- (void)setupTabbarItem {
    
    NSArray *titleArray = @[@"Message",@"Tag",@"Search",@"Ranking",@"Setting"];
    
    for (int i = 0; i < [self.tabBar.items count]; i++){
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        item.title = titleArray[i];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabItem%d", i]];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabItem%dSelected", i]];
    }
}

- (void)setupChildControllers {
    UIStoryboard *tag = [UIStoryboard storyboardWithName:@"TagStoryboard" bundle:nil];
    UIStoryboard *message = [UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    UIStoryboard *ranking = [UIStoryboard storyboardWithName:@"RankingStoryboard" bundle:nil];
    UIStoryboard *search = [UIStoryboard storyboardWithName:@"SearchingStoryboard" bundle:nil];
    UIStoryboard *setting = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    
    
    UIViewController *tagController = [tag instantiateInitialViewController];
    tagController.tabBarItem.tag = 1;
   
    
    UIViewController *messageController = [message instantiateInitialViewController];
    
    UIViewController *rankingController = [ranking instantiateInitialViewController];
    
    UIViewController *searchController = [search instantiateInitialViewController];
    
    
    SNSettingViewController *settingController = [setting instantiateInitialViewController];
    
    self.viewControllers = @[messageController, tagController, searchController, rankingController, settingController];
    
}

- (void)setupTabbar {
 
#warning 所有的颜色要写成宏
    UIColor * tabColor = [UIColor colorWithRed:246/255.0
                                         green:246/255.0
                                          blue:246/255.0
                                         alpha:0.5];
    [self.tabBar setTranslucent:YES];
    [self.tabBar setBarTintColor:tabColor];
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, 1);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightLight]} forState:UIControlStateNormal];
    self.tabBar.tintColor = [UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:43/255.0
                                                       green:57/255.0
                                                        blue:74/255.0
                                                       alpha:1.0]}
                                           forState: UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0]}
                                           forState: UIControlStateSelected];
}

#pragma mark - UITabBarController Delegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController.tabBarItem.tag == 1) {
        
        BOOL isFirstTagged = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTag"];
//        if (isFirstTagged) {
//            
//            UIStoryboard *tag = [UIStoryboard storyboardWithName:@"TagStoryboard" bundle:nil];
//            SNTagSecondViewController *secondVC = [tag instantiateViewControllerWithIdentifier:@"Second_Tag_Controller"];
//            
//            [tabBarController.selectedViewController presentViewController:secondVC animated:YES completion:nil];
//            return NO;
//    }
    
    }
    
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (item.tag == 1) {
        
        BOOL isFirstTagged = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTag"];
        if (isFirstTagged) {
            
            UIStoryboard *tag = [UIStoryboard storyboardWithName:@"TagStoryboard" bundle:nil];
            SNTagSecondViewController *secondVC = [tag instantiateViewControllerWithIdentifier:@"Second_Tag_Controller"];
            
            
            
        }

    }
}

@end









