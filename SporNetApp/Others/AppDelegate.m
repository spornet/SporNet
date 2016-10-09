//
//  AppDelegate.m
//  SporNetApp
//
//  Created by Peng on 6/27/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SNUser.h"
#import <AVIMUserOptions.h>
#import "SNLoginViewController.h"
#import "SNLaunchPageViewController.h"
#import <CoreLocation/CoreLocation.h>

#define AVOSCloudAppID  @"qLvqUSrb3dziuUehRKvpr6Kc-gzGzoHsz"
#define AVOSCloudAppKey @"aYaqxmFig7hp77IYIl1wJ6RU"

@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currlocation;
//经度
@property (nonatomic,assign) NSString                          *longitude;
//纬度
@property (nonatomic,assign) NSString                          *latitude;


@end

@implementation AppDelegate

- (CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter = 1.0f;//设备移动后获得位置信息的最小距离
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
        //        [_locationManager requestAlwaysAuthorization];//始终授权
    }
    return _locationManager;
}

//定位成功时调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currlocation = [locations lastObject];//获取当前位置
    self.longitude = [NSString stringWithFormat:@"%f", self.currlocation.coordinate.longitude];//获取经度
    self.latitude = [NSString stringWithFormat:@"%f",self.currlocation.coordinate.latitude];//获取纬度
    
    [[NSUserDefaults standardUserDefaults]setValue:self.longitude forKey:@"Lo"];
    [[NSUserDefaults standardUserDefaults]setValue:self.latitude forKey:@"La"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.locationManager stopUpdatingLocation];
    
    
    
    
}

//定位失败调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@ 调用失败",error);
}

//授权状态发生变化调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (!status) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    NSLog(@"change");
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //change the style for page indicator
    
    [self locationManager];
    [self.locationManager startUpdatingLocation];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
    
    [SNUser registerSubclass];
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    
    //获取当前版本号
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    //获取之前的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]valueForKey:@"LastVersion"];
    if (![lastVersion isEqualToString:version]) {
        
        SNLaunchPageViewController *launchController = [[SNLaunchPageViewController alloc]init];
        self.window.backgroundColor = [UIColor colorWithRed:11/255.0 green:28/255.0 blue:53/255.0 alpha:1.0];
        self.window.rootViewController = launchController;
        
        [[NSUserDefaults standardUserDefaults]setValue:version forKey:@"LastVersion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
