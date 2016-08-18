//
//  SNMainFeatureTabController.m
//  SporNetApp
//
//  Created by Peng on 6/27/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMainFeatureTabController.h"
#import "SNSettingViewController.h"

@interface SNMainFeatureTabController ()

@end

@implementation SNMainFeatureTabController

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *tag = [UIStoryboard storyboardWithName:@"TagStoryboard" bundle:nil];
    UIStoryboard *message = [UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    UIStoryboard *ranking = [UIStoryboard storyboardWithName:@"RankingStoryboard" bundle:nil];
    UIStoryboard *search = [UIStoryboard storyboardWithName:@"SearchingStoryboard" bundle:nil];
    UIStoryboard *setting = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    
    UIViewController *tagController = [tag instantiateInitialViewController];
    tagController.tabBarItem.title = @"Tag";
    UIViewController *messageController = [message instantiateInitialViewController];
    messageController.tabBarItem.title = @"Message";
    UIViewController *rankingController = [ranking instantiateInitialViewController];
    rankingController.tabBarItem.title = @"Rank";
    UIViewController *searchController = [search instantiateInitialViewController];
    searchController.tabBarItem.title = @"Search";
    
    SNSettingViewController *settingController = [setting instantiateInitialViewController];
    settingController.tabBarItem.title = @"Setting";
    self.viewControllers = @[messageController, tagController, searchController, rankingController, settingController];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
