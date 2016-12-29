//
//  ViewController.m
//  SearchNearBy_Demo
//
//  Created by ZhengYang on 16/7/28.
//  Copyright © 2016年 ZhengYang. All rights reserved.
//

#import "SNSearchNearbyMainViewController.h"
#import "WaterView.h"
#import <pop/POP.h>
#import "LocalDataManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <AVFile.h>
#import <AVObject.h>
#import "UserView.h"
#import "ProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "AVUser.h"

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication]statusBarFrame].size.height
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define R ([UIScreen mainScreen].bounds.size.width/2-50)

@interface SNSearchNearbyMainViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic ) UIButton                         *filterBtnInBlurView;
@property (weak, nonatomic ) UIButton                         *basketballBtn;
@property (weak, nonatomic ) UIButton                         *footballBtn;
@property (weak, nonatomic ) UIButton                         *fitnessBtn;
@property (weak, nonatomic ) UIButton                         *runBtn;
@property (weak, nonatomic ) UIButton                         *yogaBtn;
@property (weak, nonatomic ) UIButton                         *allBtn;
@property (weak,nonatomic  ) UIVisualEffectView               *blurView;

@property (nonatomic       ) BOOL                             isFinishLoad;
@property (weak, nonatomic ) UIImageView                      *galaxyImageView;
@property (weak, nonatomic ) UIView                           *topBtnView;
@property (weak, nonatomic ) UILabel                          *radiusLabel;
@property (weak, nonatomic ) UIButton                         *refreshBtn;
@property (weak,nonatomic  ) UIView                           *circleView;
@property (weak, nonatomic ) UIView                           *user1Area;
@property (weak, nonatomic ) UIView                           *user2Area;
@property (weak, nonatomic ) UIView                           *user3Area;
@property (weak, nonatomic ) UIView                           *user4Area;
@property (weak, nonatomic ) UIView                           *user5Area;

@property (weak, nonatomic ) UIButton                         *filterBtn;
@property (weak, nonatomic ) UIButton                         *user1;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView1;
@property (weak, nonatomic ) UIButton                         *user2;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView2;
@property (weak, nonatomic ) UIButton                         *user3;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView3;
@property (weak, nonatomic ) UIButton                         *user4;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView4;
@property (weak, nonatomic ) UIButton                         *user5;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView5;

@property (nonatomic,assign) CGFloat                          x0;
@property (nonatomic,assign) CGFloat                          y0;
@property (nonatomic,assign) CGFloat                          x1;
@property (nonatomic,assign) CGFloat                          y1;
@property (nonatomic,assign) CGFloat                          x2;
@property (nonatomic,assign) CGFloat                          y2;
@property (nonatomic,assign) CGFloat                          x3;
@property (nonatomic,assign) CGFloat                          y3;
@property (nonatomic,assign) CGFloat                          x4;
@property (nonatomic,assign) CGFloat                          y4;
@property (nonatomic,assign) CGFloat                          x5;
@property (nonatomic,assign) CGFloat                          y5;
@property (nonatomic,assign) CGFloat                          dist1;
@property (nonatomic,assign) CGFloat                          dist2;
@property (nonatomic,assign) CGFloat                          dist3;
@property (nonatomic,assign) CGFloat                          dist4;
@property (nonatomic,assign) CGFloat                          dist5;
@property (nonatomic,assign) BOOL                             isTabBarHide;
@property (nonatomic,assign) BOOL                             isUser1Null;
@property (nonatomic,assign) BOOL                             isUser2Null;
@property (nonatomic,assign) BOOL                             isUser3Null;
@property (nonatomic,assign) BOOL                             isUser4Null;
@property (nonatomic,assign) BOOL                             isUser5Null;
@property (nonatomic,assign) BOOL                             photoShowedOnFilterBtn;
@property (nonatomic,weak  ) NSTimer                          *loadingTimer;

//用户的半径，更确切的说是用户生成地点距离所在view的边距。用户按钮的大小主要有pop函数的toValue来控制，如果toValue是50，但是userR＝100则在view内边距为userR－toValue的范围内活动。
@property (nonatomic,assign) CGFloat                          userR;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currlocation;
//经度
@property (nonatomic,assign) CGFloat                          longitude;
//纬度
@property (nonatomic,assign) CGFloat                          latitude;
//本机用户地点
@property AVGeoPoint *currentUserLocation;
//其他用户到本用户的距离
@property (nonatomic,assign) CGFloat                          dist;

@property NSMutableArray *allUsers;
//最终符合所选搜索条件的Array，直接作用于CreatUser方法
@property NSMutableArray *currentUsers;
//永不相见用户列表
@property (nonatomic) NSMutableArray *neverSeeAgain;
@end

@implementation SNSearchNearbyMainViewController
NSInteger indexOfCurrentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationManager];
    self.dist = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    [self setBackgroundGalaxy];
    [self addTopView];
    [self addCircleView];
    
    self.userR = 50;
    [self fetchUserByLocation];
    [self fetchCurrentUsersFromAllUsers];
    [self creatUserFromCurrentUsers];
    
    
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        [self locationManager];
    //        self.dist = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    //        [self setBackgroundGalaxy];
    //        [self addTopView];
    //
    //        self.userR = 50;
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            [self addCircleView];
    //            [self fetchUserByLocation];
    //    [self fetchCurrentUsersFromAllUsers];
    //            [self creatUserFromCurrentUsers];
    //            [self refreshAnimation];
    //
    //        });
    //    });
    
}

-(void)fetchUserByLocation{
    //初始化在appDelegate里面的首次定位位置
    NSString *lo = [[NSUserDefaults standardUserDefaults]valueForKey:@"Lo"];
    NSString *la = [[NSUserDefaults standardUserDefaults]valueForKey:@"La"];
    AVGeoPoint *p =[AVGeoPoint geoPointWithLatitude:([la doubleValue]) longitude:[lo doubleValue]];
    
    
    
    
    
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        [self refreshAnimation];
    //        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
    //
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            [self fetchUserByLocation];
    //            [self fetchCurrentUsersFromAllUsers];
    //            [self creatUserFromCurrentUsers];
    //
    //        });
    //    });
    //
    //
    
    
    
    
    //    self.neverSeeAgain = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"blackList"]];
    
    if (p) {
        self.allUsers = [[LocalDataManager defaultManager]fetchNearByUserInfo:p withinDist:self.dist];
        self.allUsers = [[LocalDataManager defaultManager]filterUserByGenderFromList:self.allUsers];
        self.allUsers = [[LocalDataManager defaultManager]fetchUserFromBlackList:self.allUsers withBlackList:self.neverSeeAgain];
        
        
        if(_allUsers.count == 0) {
            [ProgressHUD showError:@"Bad connection. Please try later."];
            return;
        }
        
        //        [self fetchCurrentUsersFromAllUsers];
        
    }else{
        [ProgressHUD showError:@"No location."];
    }
    
}
-(void)fetchCurrentUsersFromAllUsers{
    switch (self.allUsers.count) {
        case 0:
            //网络出错&筛选体育运动的时候没有选择自己的运动
            [self showLoadView];
            self.currentUsers = nil;
            break;
            
        case 1:
            //只有自己，原因：搜索条件内只有自己或者用户不够多
            [self showLoadView];
            self.currentUsers = nil;
            break;
            
        case 2:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[1]]];
            indexOfCurrentUser = 2;
            break;
            
        case 3:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[1],_allUsers[2]]];
            indexOfCurrentUser = 3;
            break;
            
        case 4:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[1],_allUsers[2], _allUsers[3]]];
            indexOfCurrentUser = 4;
            break;
            
        case 5:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[1],_allUsers[2], _allUsers[3], _allUsers[4]]];
            indexOfCurrentUser = 5;
            break;
            
        default:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[1],_allUsers[2], _allUsers[3], _allUsers[4],_allUsers[5]]];
            indexOfCurrentUser = 6;
            break;
            
            
    }
    
}
-(void)creatUserFromCurrentUsers{
    switch (self.currentUsers.count) {
        case 0:
            
            break;
            
        case 1:
        {
            [self createUser1Btn];
            self.isUser2Null = YES;
            self.isUser3Null = YES;
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
        }
            break;
            
        case 2:
            [self createUser1Btn];
            [self createUser2Btn];
            self.isUser3Null = YES;
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 3:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 4:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            self.isUser5Null = YES;
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 5:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            [self createUser5Btn];
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        default:
            
            break;
            
            
    }
}

-(void)firstTimeAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"If you remove user from the screen, you'll never see this use again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.locationManager startUpdatingLocation];
    
    self.dist = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    self.radiusLabel.text = [NSString stringWithFormat:@"%.0f Miles", self.dist];
    
    [self tapCircleView];
    NSLog(@"%@",self.neverSeeAgain);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.blurView removeFromSuperview];
    [self.loadingTimer setFireDate:[NSDate distantPast]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.loadingTimer setFireDate:[NSDate distantFuture]];
}

-(void)createUser1Btn{
    [self randomUser1Coordinate];
    UIButton *user1 = [[UIButton alloc]initWithFrame:CGRectMake(self.x1, self.y1, self.userR, self.userR)];
    if([_currentUsers[0] objectForKey:@"icon"]) [user1 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[0] objectForKey:@"icon"]getData]] forState:normal];
    else [user1 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    [[user1 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[0] objectForKey:@"sportTimeSlot"]integerValue]];
    [user1.layer setBorderColor:color.CGColor];
    user1.layer.masksToBounds = YES;
    user1.layer.cornerRadius = user1.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x1 + 41, self.y1 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[0] objectForKey:@"bestSport"]integerValue]]];
    NSLog(@"current user name is %@", [self.currentUsers[0] objectForKey:@"name"]);
    [self.view addSubview:user1];
    [self.view addSubview:bestsportView];
    self.bestSportImageView1 = bestsportView;
    self.user1 = user1;
    [self.user1 addTarget:self action:@selector(dragUser1Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user1 addTarget:self action:@selector(ifUser1Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user1 addTarget:self action:@selector(rememberUser1OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.bestSportImageView1.layer pop_addAnimation:animSport forKey:@"size"];
    [self.user1.layer pop_addAnimation:anim forKey:@"size"];
    
    //        NSLog(@"%f %f",self.x,self.y);
    self.isUser1Null = NO;
    self.dist1 = 0;
    
}

-(void)createUser2Btn{
    [self randomUser2Coordinate];
    UIButton *user2 = [[UIButton alloc]initWithFrame:CGRectMake(self.x2, self.y2, self.userR, self.userR)];
    if([_currentUsers[1] objectForKey:@"icon"]) [user2 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[1] objectForKey:@"icon"]getData]] forState:normal];
    else [user2 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    NSLog(@"current user name is %@", [self.currentUsers[1] objectForKey:@"name"]);
    
    [[user2 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[1] objectForKey:@"sportTimeSlot"]integerValue]];
    [user2.layer setBorderColor:color.CGColor];
    user2.layer.masksToBounds = YES;
    user2.layer.cornerRadius = user2.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x2 + 41, self.y2 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[1] objectForKey:@"bestSport"]integerValue]]];
    [self.view addSubview:user2];
    [self.view addSubview:bestsportView];
    self.bestSportImageView2 = bestsportView;
    self.user2 = user2;
    [self.user2 addTarget:self action:@selector(dragUser2Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user2 addTarget:self action:@selector(ifUser2Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user2 addTarget:self action:@selector(rememberUser2OrignXY:) forControlEvents:UIControlEventTouchDown];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.bestSportImageView2.layer pop_addAnimation:animSport forKey:@"size"];
    [self.user2.layer pop_addAnimation:anim forKey:@"size"];
    
    //        NSLog(@"%f %f",self.x,self.y);
    self.isUser2Null = NO;
    self.dist2 = 0;
    
}

-(void)createUser3Btn{
    [self randomUser3Coordinate];
    UIButton *user3 = [[UIButton alloc]initWithFrame:CGRectMake(self.x3, self.y3, self.userR, self.userR)];
    if([_currentUsers[2] objectForKey:@"icon"]) [user3 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[2] objectForKey:@"icon"]getData]] forState:normal];
    else [user3 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    NSLog(@"current user name is %@", [self.currentUsers[2] objectForKey:@"name"]);
    [[user3 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[2] objectForKey:@"sportTimeSlot"]integerValue]];
    [user3.layer setBorderColor:color.CGColor];
    user3.layer.masksToBounds = YES;
    user3.layer.cornerRadius = user3.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x3 + 41, self.y3 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[2] objectForKey:@"bestSport"]integerValue]]];
    [self.view addSubview:user3];
    [self.view addSubview:bestsportView];
    self.bestSportImageView3 = bestsportView;
    self.user3 = user3;
    [self.user3 addTarget:self action:@selector(dragUser3Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user3 addTarget:self action:@selector(ifUser3Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user3 addTarget:self action:@selector(rememberUser3OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.bestSportImageView3.layer pop_addAnimation:animSport forKey:@"size"];
    [self.user3.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser3Null = NO;
    self.dist3 = 0;
    
}

-(void)createUser4Btn{
    [self randomUser4Coordinate];
    UIButton *user4 = [[UIButton alloc]initWithFrame:CGRectMake(self.x4, self.y4, self.userR, self.userR)];
    if([_currentUsers[3] objectForKey:@"icon"]) [user4 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[3] objectForKey:@"icon"]getData]] forState:normal];
    else [user4 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    NSLog(@"current user name is %@", [self.currentUsers[3] objectForKey:@"name"]);
    [[user4 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[3] objectForKey:@"sportTimeSlot"]integerValue]];
    [user4.layer setBorderColor:color.CGColor];
    user4.layer.masksToBounds = YES;
    user4.layer.cornerRadius = user4.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x4 + 41, self.y4 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[3] objectForKey:@"bestSport"]integerValue]]];
    [self.view addSubview:user4];
    self.user4 = user4;
    [self.view addSubview:bestsportView];
    self.bestSportImageView4 = bestsportView;
    [self.user4 addTarget:self action:@selector(dragUser4Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user4 addTarget:self action:@selector(ifUser4Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user4 addTarget:self action:@selector(rememberUser4OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.bestSportImageView4.layer pop_addAnimation:animSport forKey:@"size"];
    [self.user4.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser4Null = NO;
    self.dist4 = 0;
    
}

-(void)createUser5Btn{
    [self randomUser5Coordinate];
    UIButton *user5 = [[UIButton alloc]initWithFrame:CGRectMake(self.x5, self.y5, self.userR, self.userR)];
    if([_currentUsers[4] objectForKey:@"icon"]) [user5 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[4] objectForKey:@"icon"]getData]] forState:normal];
    ;
    NSLog(@"current user name is %@", [self.currentUsers[4] objectForKey:@"name"]);
    [[user5 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[4] objectForKey:@"sportTimeSlot"]integerValue]];
    [user5.layer setBorderColor:color.CGColor];
    user5.layer.masksToBounds = YES;
    user5.layer.cornerRadius = user5.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x5 + 41, self.y5 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[4] objectForKey:@"bestSport"]integerValue]]];
    [self.view addSubview:user5];
    [self.view addSubview:bestsportView];
    self.user5 = user5;
    self.bestSportImageView5 = bestsportView;
    [self.user5 addTarget:self action:@selector(dragUser5Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user5 addTarget:self action:@selector(ifUser5Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user5 addTarget:self action:@selector(rememberUser5OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.bestSportImageView5.layer pop_addAnimation:animSport forKey:@"size"];
    [self.user5.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser5Null = NO;
    self.dist5 = 0;
    
}

-(void)rememberUser1OrignXY:(UIButton *)btn{
    self.x1 = btn.frame.origin.x;
    self.y1 = btn.frame.origin.y;
}

-(void)rememberUser2OrignXY:(UIButton *)btn{
    self.x2 = btn.frame.origin.x;
    self.y2 = btn.frame.origin.y;
}

-(void)rememberUser3OrignXY:(UIButton *)btn{
    self.x3 = btn.frame.origin.x;
    self.y3 = btn.frame.origin.y;
}

-(void)rememberUser4OrignXY:(UIButton *)btn{
    self.x4 = btn.frame.origin.x;
    self.y4 = btn.frame.origin.y;
}

-(void)rememberUser5OrignXY:(UIButton *)btn{
    self.x5 = btn.frame.origin.x;
    self.y5 = btn.frame.origin.y;
}

-(void)showUserInfo:(AVObject*)userInfo {
    
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    vc.delegate = self;
    vc.currentUserProfile = (SNUser*)userInfo;
    vc.isSearchNearBy = YES;
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(20, 50, SCREEN_WIDTH-40, SCREEN_HEIGHT-100);
    
    [self.blurView addSubview:vc.view];
    
    NSLog(@"user name is %@", [userInfo objectForKey:@"name"]);
}

- (void) dragUser1Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist1 = [self distanceFromPointA:CGPointMake(self.x1+self.userR/2, self.y1+self.userR/2) toPointB:c.center];
    self.dist1 = dist1;
    self.bestSportImageView1.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser2Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist2 = [self distanceFromPointA:CGPointMake(self.x2+self.userR/2, self.y2+self.userR/2) toPointB:c.center];
    self.dist2 = dist2;
    self.bestSportImageView2.center = CGPointMake(c.center.x + 25, c.center.y);
}


- (void) dragUser3Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist3 = [self distanceFromPointA:CGPointMake(self.x3+self.userR/2, self.y3+self.userR/2) toPointB:c.center];
    self.dist3 = dist3;
    self.bestSportImageView3.center = CGPointMake(c.center.x + 25, c.center.y);
}


- (void) dragUser4Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist4 = [self distanceFromPointA:CGPointMake(self.x4+self.userR/2, self.y4+self.userR/2) toPointB:c.center];
    self.dist4 = dist4;
    self.bestSportImageView4.center = CGPointMake(c.center.x + 25, c.center.y);
}


- (void) dragUser5Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist5 = [self distanceFromPointA:CGPointMake(self.x5+self.userR/2, self.y5+self.userR/2) toPointB:c.center];
    self.dist5 = dist5;
    self.bestSportImageView5.center = CGPointMake(c.center.x + 25, c.center.y);
}

-(void)ifUser1Remove{
    
    if (self.dist1 < 15) {
        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[0]];
    }else if(self.dist1 < 100){
        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x1+self.userR/2, self.y1+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user1.center=location;
            self.bestSportImageView1.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        self.dist1 = 0;
    }else{
        //移除的动画效果
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user1.frame];
        [self.user1 removeFromSuperview];
        [self.bestSportImageView1 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[0]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser1Null = YES;
        if(indexOfCurrentUser == self.allUsers.count) {
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null) {
                [self showLoadView];
            } else {
                return;
            }
        }else{
            self.currentUsers[0] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser1Btn];
            //放在creatBtn中
            //self.dist1 = 0;
        }
    }
    
}

-(void)ifUser2Remove{
    if (self.dist2 < 15) {
        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[1]];
    }else if(self.dist2 < 100){
        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x2+self.userR/2, self.y2+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user2.center=location;
            self.bestSportImageView2.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist2 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user2.frame];
        [self.user2 removeFromSuperview];
        [self.bestSportImageView2 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[1]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser2Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null) {
                [self showLoadView];
            } else {
                return;
            }
        }else{
            self.currentUsers[1] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser2Btn];
            //            self.dist2 = 0;
        }
    }
    
}

-(void)ifUser3Remove{
    
    if (self.dist3 < 15) {
        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[2]];
    } else if(self.dist3 < 100){
        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x3+self.userR/2, self.y3+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user3.center=location;
            self.bestSportImageView3.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist3 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user3.frame];
        [self.user3 removeFromSuperview];
        [self.bestSportImageView3 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[2]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser3Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null) {
                [self showLoadView];
            } else {
                return;
            }
        }else{
            self.currentUsers[2] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser3Btn];
            //            self.dist3 = 0;
        }
    }
    
}

-(void)ifUser4Remove{
    
    if (self.dist4 < 15) {
        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[3]];
    }else if(self.dist4 < 100){
        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x4+self.userR/2, self.y4+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user4.center=location;
            self.bestSportImageView4.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist4 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user4.frame];
        [self.user4 removeFromSuperview];
        [self.bestSportImageView4 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[3]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser4Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null) {
                [self showLoadView];
            } else {
                return;
            }
        }else{
            self.currentUsers[3] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser4Btn];
            //            self.dist4 = 0;
        }
    }
    
}

-(void)ifUser5Remove{
    
    if (self.dist5 < 15) {
        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[4]];
    }else if(self.dist5 < 100){
        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x5+self.userR/2, self.y5+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user5.center=location;
            self.bestSportImageView5.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        
        self.dist5 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user5.frame];
        [self.user5 removeFromSuperview];
        [self.bestSportImageView5 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[4]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser5Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null) {
                [self showLoadView];
            } else {
                return;
            }
        }else{
            self.currentUsers[4] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser5Btn];
            //            self.dist5 = 0;
        }
    }
    
}

-(float)distanceFromPointA:(CGPoint)start toPointB:(CGPoint)end{
    float distance;
    CGFloat xDist = end.x - start.x;
    CGFloat yDist = end.y - start.y;
    distance = sqrtf((xDist * xDist) + (yDist * yDist));
    return distance;
}


-(void)randomUser1Coordinate{
    
    CGFloat xRange = self.user1Area.frame.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user1Area.frame.origin.x;
    self.x1 = xValue;
    
    CGFloat yRange = self.user1Area.frame.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user1Area.frame.origin.y;
    self.y1 = yValue;
    
}

-(void)randomUser2Coordinate{
    
    CGFloat xRange = self.user2Area.frame.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user2Area.frame.origin.x;
    self.x2 = xValue;
    
    CGFloat yRange = self.user2Area.frame.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user2Area.frame.origin.y;
    self.y2 = yValue;
    
}

-(void)randomUser3Coordinate{
    
    CGFloat xRange = self.user3Area.frame.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user3Area.frame.origin.x;
    self.x3 = xValue;
    
    CGFloat yRange = self.user3Area.frame.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user3Area.frame.origin.y;
    self.y3 = yValue;
    
}

-(void)randomUser4Coordinate{
    
    CGFloat xRange = self.user4Area.frame.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user4Area.frame.origin.x;
    self.x4 = xValue;
    
    CGFloat yRange = self.user4Area.frame.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user4Area.frame.origin.y;
    self.y4 = yValue;
    
}

-(void)randomUser5Coordinate{
    
    CGFloat xRange = self.user5Area.frame.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user5Area.frame.origin.x;
    self.x5 = xValue;
    
    CGFloat yRange = self.user5Area.frame.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user5Area.frame.origin.y;
    self.y5 = yValue;
    
}

/**
 *  add circle view and filter btn
 */
-(void)addCircleView{
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-self.topBtnView.frame.size.height - 60)];
    //    circleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:circleView];
    self.circleView = circleView;
    self.circleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    [self.circleView addGestureRecognizer:tapGesturRecognizer];
    
    UIView *user1Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user1Area.backgroundColor = [UIColor redColor];
    [self.view addSubview:user1Area];
    self.user1Area = user1Area;
    UITapGestureRecognizer *tapGesturRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user1Area.userInteractionEnabled = YES;
    [self.user1Area addGestureRecognizer:tapGesturRecognizer1];
    
    UIView *user2Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user2Area.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:user2Area];
    self.user2Area = user2Area;
    UITapGestureRecognizer *tapGesturRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user2Area.userInteractionEnabled = YES;
    [self.user2Area addGestureRecognizer:tapGesturRecognizer2];
    
    UIView *user3Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.user1Area.frame), MAIN_SCREEN_WIDTH/2-37.5, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user3Area.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:user3Area];
    self.user3Area = user3Area;
    UITapGestureRecognizer *tapGesturRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user3Area.userInteractionEnabled = YES;
    [self.user3Area addGestureRecognizer:tapGesturRecognizer3];
    
    UIView *user4Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2+37.5, CGRectGetMaxY(self.user1Area.frame), MAIN_SCREEN_WIDTH/2-37.5, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user4Area.backgroundColor = [UIColor greenColor];
    [self.view addSubview:user4Area];
    self.user4Area = user4Area;
    UITapGestureRecognizer *tapGesturRecognizer4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user4Area.userInteractionEnabled = YES;
    [self.user4Area addGestureRecognizer:tapGesturRecognizer4];
    
    UIView *user5Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/4, CGRectGetMaxY(self.user3Area.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3-44)];
    //    user5Area.backgroundColor = [UIColor blueColor];
    [self.view addSubview:user5Area];
    self.user5Area = user5Area;
    UITapGestureRecognizer *tapGesturRecognizer5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user5Area.userInteractionEnabled = YES;
    [self.user5Area addGestureRecognizer:tapGesturRecognizer5];
    
    
    UIButton *filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 37.5, self.circleView.bounds.size.height/2 - 37.5 + CGRectGetMaxY(self.topBtnView.frame), 75, 75)];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
    [self.view addSubview:filterBtn];
    self.filterBtn = filterBtn;
    [self.filterBtn addTarget:self action:@selector(sportFilterClick) forControlEvents:UIControlEventTouchUpInside];
}


//hide or show TabBar
-(void)tapCircleView{
    CGFloat offset = self.isTabBarHide ? -self.tabBarController.tabBar.bounds.size.height : self.tabBarController.tabBar.bounds.size.height;
    CGFloat y = self.tabBarController.tabBar.center.y + offset;
    
    
    if (self.isTabBarHide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, y);
            self.isTabBarHide = NO;
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, y);
            self.isTabBarHide = YES;
        }];
        
    }
    
}


/**
 *  add top button view
 */
-(void)addTopView{
    
    UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MAIN_SCREEN_WIDTH, 140)];
    //    topBtnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topBtnView];
    self.topBtnView = topBtnView;
    
    UIImageView *radiusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 -25, self.topBtnView.bounds.size.height/2 -30, 50, 50)];
    radiusImageView.backgroundColor = [UIColor clearColor];
    radiusImageView.image = [UIImage imageNamed:@"radius"];
    [self.topBtnView addSubview:radiusImageView];
    
    
    
    /**
     *  黑洞效果
     */
    //
    //    UIImageView *radiusBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 -40, self.topBtnView.bounds.size.height/2 -40, 80, 80)];
    //    radiusBGImageView.image = [UIImage imageNamed:@"blackhole"];
    //    radiusBGImageView.layer.masksToBounds = YES;
    //    radiusBGImageView.layer.cornerRadius = radiusBGImageView.frame.size.width / 2.0;
    //    UIImageView *radiusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 -30, self.topBtnView.bounds.size.height/2 -30, 60, 60)];
    //    radiusImageView.image = [UIImage imageNamed:@"blackhole2"];
    //    radiusImageView.layer.masksToBounds = YES;
    //    radiusImageView.layer.cornerRadius = radiusImageView.frame.size.width / 2.0;
    //
    //    CGFloat angleBG = -M_1_PI;
    //    CGFloat angle = M_PI;
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:50];
    //    for (int i = 1; i<50; i++) {
    //        radiusImageView.transform = CGAffineTransformRotate(radiusImageView.transform, angle);
    //        radiusBGImageView.transform = CGAffineTransformRotate(radiusBGImageView.transform, angleBG);
    //    }
    //    [UIView commitAnimations];
    //
    //    [self.topBtnView addSubview:radiusBGImageView];
    //    [self.topBtnView addSubview:radiusImageView];
    
    
    
    
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 - 75, self.topBtnView.bounds.size.height/2 + 30, 150, 20)];
    topLabel.text = @"我是距离";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    self.radiusLabel = topLabel;
    self.radiusLabel.text = [NSString stringWithFormat:@"%.0f Miles", self.dist];
    [self.topBtnView addSubview:self.radiusLabel];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.topBtnView.frame) - 10 - 35, self.topBtnView.bounds.size.height/2 - 50, 35, 35)];
    refreshBtn.backgroundColor = [UIColor clearColor];
    [refreshBtn setImage:[UIImage imageNamed:@"nearbyRefresh"] forState:UIControlStateNormal];
    _isFinishLoad = YES;
    self.refreshBtn = refreshBtn;
    [self.refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topBtnView addSubview:self.refreshBtn];
    
}

-(void)clickRefreshBtn{
    //    [self 加载数据];
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    [self.bestSportImageView1 removeFromSuperview];
    [self.bestSportImageView2 removeFromSuperview];
    [self.bestSportImageView3 removeFromSuperview];
    [self.bestSportImageView4 removeFromSuperview];
    [self.bestSportImageView5 removeFromSuperview];
    
    
    if (indexOfCurrentUser == _allUsers.count) {
        [self showLoadView];
    } else {
        for(int i = 0; i < 5; i++) {
            if(indexOfCurrentUser == _allUsers.count) continue;
            self.currentUsers[i] = self.allUsers[indexOfCurrentUser];
            NSString *str = [NSString stringWithFormat:@"createUser%dBtn", i + 1];
            SEL s = NSSelectorFromString(str);
            [self performSelector:s];
            indexOfCurrentUser++;
            [self refreshAnimation];
        }
    }
}

-(void)refreshAnimation{
    
    __block WaterView *waterView = [[WaterView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH / 2 - 20, MAIN_SCREEN_HEIGHT / 2 + 40 - CGRectGetMaxY(self.topBtnView.frame), 40, 40)];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.circleView addSubview:waterView];
    
    [UIView animateWithDuration:4 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 9, 9);
        waterView.alpha = 0;
    }completion:^(BOOL finished){
        [waterView removeFromSuperview];
    }];
    
    
    
    POPSpringAnimation *anim4FilterBtn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim4FilterBtn.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim4FilterBtn.springSpeed = 50.0;
    anim4FilterBtn.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim4FilterBtn.springBounciness = 6;
    //震动的明显程度
    anim4FilterBtn.dynamicsMass = 10;
    
    [self.filterBtn.layer pop_addAnimation:anim4FilterBtn forKey:@"size"];
    
    
    //    POPSpringAnimation *anim4PhotoView = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    //    anim4PhotoView.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    //    anim4PhotoView.springSpeed = 50.0;
    //    anim4PhotoView.dynamicsFriction = 20.0;
    //    //震动的次数～约等于springBounciness－10
    //    anim4PhotoView.springBounciness = 6;
    //    //震动的明显程度
    //    anim4PhotoView.dynamicsMass = 10;
    //    [self.photoView.layer pop_addAnimation:anim4PhotoView forKey:@"size"];
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Add galaxy background image with animation
 */
-(void)setBackgroundGalaxy{
    UIImageView *galaxyImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgn"]];
    galaxyImageView.frame = CGRectMake(-50, -50, MAIN_SCREEN_WIDTH +100, MAIN_SCREEN_HEIGHT +100);
    //    galaxyImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIInterpolatingMotionEffect *xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue = [NSNumber numberWithFloat:50.0];
    xEffect.maximumRelativeValue = [NSNumber numberWithFloat:-50.0];
    
    UIInterpolatingMotionEffect *yEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yEffect.minimumRelativeValue = [NSNumber numberWithFloat:50.0];
    yEffect.maximumRelativeValue = [NSNumber numberWithFloat:-50.0];
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[xEffect,yEffect];
    [galaxyImageView addMotionEffect:group];
    [self.view addSubview:galaxyImageView];
    self.galaxyImageView = galaxyImageView;
}

-(void)sportFilterClick{
    
    if (self.photoShowedOnFilterBtn) {
        //调用load画面
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self refreshAnimation];
            self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self fetchUserByLocation];
                [self fetchCurrentUsersFromAllUsers];
                [self creatUserFromCurrentUsers];
                
            });
        });
        
        
        
        
        
        
    } else {
        
        [self configreBlurView];
        [self addSportBtn];
        
        
        UIButton *filterBtnInBlurView = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 37.5, self.circleView.bounds.size.height/2 - 37.5 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 75, 75)];
        [filterBtnInBlurView setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self.blurView addSubview:filterBtnInBlurView];
        self.filterBtnInBlurView = filterBtnInBlurView;
        [self.filterBtnInBlurView addTarget:self action:@selector(removeBlurView) forControlEvents:UIControlEventTouchUpInside];
        
        [self beginAnimation];
        
    }
}

-(void)configreBlurView {
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    //设置模糊透明度
    effectView.alpha = 0.9f;
    [self.view addSubview:effectView];
    self.blurView = effectView;
    
}

-(void)removeBlurView{
    
    [self endAnimation];
    [self performSelector:@selector(removeBlurViewSelector) withObject:nil afterDelay:0.5f];
    
}

-(void)removeBlurViewSelector{
    [self.blurView removeFromSuperview];
}

-(void)addSportBtn{
    UIButton *basketballBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [basketballBtn setImage:[UIImage imageNamed:@"basketballSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:basketballBtn];
    self.basketballBtn = basketballBtn;
    self.basketballBtn.tag = BestSportsBasketball;
    [self.basketballBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *footballBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [footballBtn setImage:[UIImage imageNamed:@"soccerSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:footballBtn];
    self.footballBtn = footballBtn;
    self.footballBtn.tag = BestSportsSoccer;
    [self.footballBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fitnessBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [fitnessBtn setImage:[UIImage imageNamed:@"muscleSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:fitnessBtn];
    self.fitnessBtn = fitnessBtn;
    self.fitnessBtn.tag = BestSportsMuscle;
    [self.fitnessBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *runBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [runBtn setImage:[UIImage imageNamed:@"joggingSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:runBtn];
    self.runBtn = runBtn;
    self.runBtn.tag = BestSportsJogging;
    [self.runBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yogaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [yogaBtn setImage:[UIImage imageNamed:@"yogaSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:yogaBtn];
    self.yogaBtn = yogaBtn;
    self.yogaBtn.tag = BestSportsYoga;
    [self.yogaBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *allBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 25, self.circleView.bounds.size.height/2 - 25 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 50, 50)];
    [allBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
    [self.blurView addSubview:allBtn];
    self.allBtn = allBtn;
    [self.allBtn addTarget:self action:@selector(allSportSelected) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)bestSportSelected:(id)sender{
    
    NSString *imageName = [[NSString alloc]init];
    
    switch (((UIButton*)sender).tag) {
        case BestSportsBasketball:
            imageName = @"basketballSelected";
            break;
        case BestSportsSoccer:
            imageName = @"soccerSelected";
            break;
        case BestSportsMuscle:
            imageName = @"muscleSelected";
            break;
        case BestSportsJogging:
            imageName = @"joggingSelected";
            break;
        case BestSportsYoga:
            imageName = @"yogaSelected";
            break;
        default:
            break;
    }
    
    [self.filterBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self removeBlurView];
    
    
    //为了重置一下currentUsers，因为上面已经用相应的体育运动筛选了一遍，如果不重置，换其他运动的时候currentUsers就为空了。
    [self fetchUserByLocation];
    self.allUsers = [[LocalDataManager defaultManager]fetchUserFromList:self.allUsers withSportType:((UIView*)sender).tag];
    [self fetchCurrentUsersFromAllUsers];
    
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    [self.bestSportImageView1 removeFromSuperview];
    [self.bestSportImageView2 removeFromSuperview];
    [self.bestSportImageView3 removeFromSuperview];
    [self.bestSportImageView4 removeFromSuperview];
    [self.bestSportImageView5 removeFromSuperview];
    
    if (self.allUsers.count==1||self.allUsers.count==0) {
        return;
    }
    [self creatUserFromCurrentUsers];
    
    
}
-(void)allSportSelected {
    [self removeBlurView];
    [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
    
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    [self.bestSportImageView1 removeFromSuperview];
    [self.bestSportImageView2 removeFromSuperview];
    [self.bestSportImageView3 removeFromSuperview];
    [self.bestSportImageView4 removeFromSuperview];
    [self.bestSportImageView5 removeFromSuperview];
    [self fetchUserByLocation];
    [self fetchCurrentUsersFromAllUsers];
    [self creatUserFromCurrentUsers];
    
    
}

-(void) beginAnimation{
    /*篮球动画设置*/
    CAKeyframeAnimation *basketballAnimation = [CAKeyframeAnimation animation];
    basketballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *basketballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition = self.basketballBtn.layer.position;
    CGFloat originalX = originalPosition.x;
    self.x0 = originalX;
    CGFloat originalY = originalPosition.y;
    self.y0 = originalY;
    [basketballPath moveToPoint:CGPointMake(originalX, originalY)];
    [basketballPath addQuadCurveToPoint:CGPointMake(originalX - R, originalY) controlPoint:CGPointMake(originalX-R/2, originalY + R)];
    basketballAnimation.path = basketballPath.CGPath;
    
    /*足球动画设置*/
    CAKeyframeAnimation *footballAnimation = [CAKeyframeAnimation animation];
    footballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *footballPath = [UIBezierPath bezierPath];
    [footballPath moveToPoint:CGPointMake(originalX, originalY)];
    [footballPath addQuadCurveToPoint:CGPointMake(originalX + R/2, originalY + R) controlPoint:CGPointMake(originalX + R, originalY)];
    footballAnimation.path = footballPath.CGPath;
    
    /*健身动画设置*/
    CAKeyframeAnimation *fitnessAnimation = [CAKeyframeAnimation animation];
    fitnessAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *fitnessPath = [UIBezierPath bezierPath];
    [fitnessPath moveToPoint:CGPointMake(originalX, originalY)];
    [fitnessPath addQuadCurveToPoint:CGPointMake(originalX - R/2, originalY + R) controlPoint:CGPointMake(originalX + R/2, originalY + R)];
    fitnessAnimation.path = fitnessPath.CGPath;
    
    /*跑步动画设置*/
    CAKeyframeAnimation *runAnimation = [CAKeyframeAnimation animation];
    runAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *runPath = [UIBezierPath bezierPath];
    [runPath moveToPoint:CGPointMake(originalX, originalY)];
    [runPath addQuadCurveToPoint:CGPointMake(originalX + R, originalY) controlPoint:CGPointMake(originalX + R/2, originalY - R)];
    runAnimation.path = runPath.CGPath;
    
    /*瑜伽动画设置*/
    CAKeyframeAnimation *yogaAnimation = [CAKeyframeAnimation animation];
    yogaAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *yogaPath = [UIBezierPath bezierPath];
    [yogaPath moveToPoint:CGPointMake(originalX, originalY)];
    [yogaPath addQuadCurveToPoint:CGPointMake(originalX + R/2, originalY - R) controlPoint:CGPointMake(originalX - R/2, originalY - R)];
    yogaAnimation.path = yogaPath.CGPath;
    
    /*ALL动画设置*/
    CAKeyframeAnimation *allAnimation = [CAKeyframeAnimation animation];
    allAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    [allPath moveToPoint:CGPointMake(originalX, originalY)];
    [allPath addQuadCurveToPoint:CGPointMake(originalX - R/2, originalY - R) controlPoint:CGPointMake(originalX - R, originalY)];
    allAnimation.path = allPath.CGPath;
    
    
    /*放大效果设置*/
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.values = @[@(0.2),@(1.0)];
    /*透明度设置*/
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
    animation3.keyPath = @"opacity";
    animation3.values = @[@(0.2),@(1.0)];
    
    /*篮球动画组*/
    CAAnimationGroup *basketballAnimationGroup = [CAAnimationGroup animation];
    basketballAnimationGroup.animations = @[basketballAnimation,animation2,animation3];
    basketballAnimationGroup.duration = 0.5;
    basketballAnimationGroup.repeatCount = 1;
    basketballAnimationGroup.removedOnCompletion = NO;
    basketballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.basketballBtn.layer addAnimation:basketballAnimationGroup forKey:nil];
    self.basketballBtn.center = CGPointMake(originalX - R, originalY);
    
    /*足球动画组*/
    CAAnimationGroup *footballAnimationGroup = [CAAnimationGroup animation];
    footballAnimationGroup.animations = @[footballAnimation,animation2,animation3];
    footballAnimationGroup.duration = 0.5;
    footballAnimationGroup.repeatCount = 1;
    footballAnimationGroup.removedOnCompletion = NO;
    footballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.footballBtn.layer addAnimation:footballAnimationGroup forKey:nil];
    self.footballBtn.center = CGPointMake(originalX + R/2, originalY + R);
    
    /*健身动画组*/
    CAAnimationGroup *fitnessAnimationGroup = [CAAnimationGroup animation];
    fitnessAnimationGroup.animations = @[fitnessAnimation,animation2,animation3];
    fitnessAnimationGroup.duration = 0.5;
    fitnessAnimationGroup.repeatCount = 1;
    fitnessAnimationGroup.removedOnCompletion = NO;
    fitnessAnimationGroup.fillMode = kCAFillModeForwards;
    [self.fitnessBtn.layer addAnimation:fitnessAnimationGroup forKey:nil];
    self.fitnessBtn.center = CGPointMake(originalX - R/2, originalY + R);
    
    /*跑步动画组*/
    CAAnimationGroup *runAnimationGroup = [CAAnimationGroup animation];
    runAnimationGroup.animations = @[runAnimation,animation2,animation3];
    runAnimationGroup.duration = 0.5;
    runAnimationGroup.repeatCount = 1;
    runAnimationGroup.removedOnCompletion = NO;
    runAnimationGroup.fillMode = kCAFillModeForwards;
    [self.runBtn.layer addAnimation:runAnimationGroup forKey:nil];
    self.runBtn.center = CGPointMake(originalX + R, originalY);
    
    /*瑜伽动画组*/
    CAAnimationGroup *yogaAnimationGroup = [CAAnimationGroup animation];
    yogaAnimationGroup.animations = @[yogaAnimation,animation2,animation3];
    yogaAnimationGroup.duration = 0.5;
    yogaAnimationGroup.repeatCount = 1;
    yogaAnimationGroup.removedOnCompletion = NO;
    yogaAnimationGroup.fillMode = kCAFillModeForwards;
    [self.yogaBtn.layer addAnimation:yogaAnimationGroup forKey:nil];
    self.yogaBtn.center = CGPointMake(originalX + R/2, originalY - R);
    
    /*ALL动画组*/
    CAAnimationGroup *allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = @[allAnimation,animation2,animation3];
    allAnimationGroup.duration = 0.5;
    allAnimationGroup.repeatCount = 1;
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    [self.allBtn.layer addAnimation:allAnimationGroup forKey:nil];
    self.allBtn.center = CGPointMake(originalX - R/2, originalY - R);
    
}

-(void) endAnimation{
    /*篮球动画设置*/
    CAKeyframeAnimation *basketballAnimation = [CAKeyframeAnimation animation];
    basketballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *basketballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition1 = self.basketballBtn.layer.position;
    CGFloat originalX1 = originalPosition1.x;
    CGFloat originalY1 = originalPosition1.y;
    [basketballPath moveToPoint:CGPointMake(originalX1, originalY1)];
    [basketballPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0-R/2, self.y0 + R)];
    basketballAnimation.path = basketballPath.CGPath;
    
    /*足球动画设置*/
    CAKeyframeAnimation *footballAnimation = [CAKeyframeAnimation animation];
    footballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *footballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition2 = self.footballBtn.layer.position;
    CGFloat originalX2 = originalPosition2.x;
    CGFloat originalY2 = originalPosition2.y;
    [footballPath moveToPoint:CGPointMake(originalX2, originalY2)];
    [footballPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R, self.y0)];
    footballAnimation.path = footballPath.CGPath;
    
    /*健身动画设置*/
    CAKeyframeAnimation *fitnessAnimation = [CAKeyframeAnimation animation];
    fitnessAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *fitnessPath = [UIBezierPath bezierPath];
    CGPoint originalPosition3 = self.fitnessBtn.layer.position;
    CGFloat originalX3 = originalPosition3.x;
    CGFloat originalY3 = originalPosition3.y;
    [fitnessPath moveToPoint:CGPointMake(originalX3, originalY3)];
    [fitnessPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R/2, self.y0 + R)];
    fitnessAnimation.path = fitnessPath.CGPath;
    
    /*跑步动画设置*/
    CAKeyframeAnimation *runAnimation = [CAKeyframeAnimation animation];
    runAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *runPath = [UIBezierPath bezierPath];
    CGPoint originalPosition4 = self.runBtn.layer.position;
    CGFloat originalX4 = originalPosition4.x;
    CGFloat originalY4 = originalPosition4.y;
    [runPath moveToPoint:CGPointMake(originalX4, originalY4)];
    [runPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R/2, self.y0 - R)];
    runAnimation.path = runPath.CGPath;
    
    /*瑜伽动画设置*/
    CAKeyframeAnimation *yogaAnimation = [CAKeyframeAnimation animation];
    yogaAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *yogaPath = [UIBezierPath bezierPath];
    CGPoint originalPosition5 = self.yogaBtn.layer.position;
    CGFloat originalX5 = originalPosition5.x;
    CGFloat originalY5 = originalPosition5.y;
    [yogaPath moveToPoint:CGPointMake(originalX5, originalY5)];
    [yogaPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 - R/2, self.y0 - R)];
    yogaAnimation.path = yogaPath.CGPath;
    
    /*ALL动画设置*/
    CAKeyframeAnimation *allAnimation = [CAKeyframeAnimation animation];
    allAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    CGPoint originalPosition6 = self.allBtn.layer.position;
    CGFloat originalX6 = originalPosition6.x;
    CGFloat originalY6 = originalPosition6.y;
    [allPath moveToPoint:CGPointMake(originalX6, originalY6)];
    [allPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 - R, self.y0)];
    allAnimation.path = allPath.CGPath;
    
    
    /*放大效果设置*/
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.values = @[@(1.0),@(0.2)];
    
    /*透明度设置*/
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
    animation3.keyPath = @"opacity";
    animation3.values = @[@(1.0),@(0.2)];
    
    /*篮球动画组*/
    CAAnimationGroup *basketballAnimationGroup = [CAAnimationGroup animation];
    basketballAnimationGroup.animations = @[basketballAnimation,animation2,animation3];
    basketballAnimationGroup.duration = 0.5;
    basketballAnimationGroup.repeatCount = 1;
    basketballAnimationGroup.removedOnCompletion = NO;
    basketballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.basketballBtn.layer addAnimation:basketballAnimationGroup forKey:nil];
    
    /*足球动画组*/
    CAAnimationGroup *footballAnimationGroup = [CAAnimationGroup animation];
    footballAnimationGroup.animations = @[footballAnimation,animation2,animation3];
    footballAnimationGroup.duration = 0.5;
    footballAnimationGroup.repeatCount = 1;
    footballAnimationGroup.removedOnCompletion = NO;
    footballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.footballBtn.layer addAnimation:footballAnimationGroup forKey:nil];
    
    /*健身动画组*/
    CAAnimationGroup *fitnessAnimationGroup = [CAAnimationGroup animation];
    fitnessAnimationGroup.animations = @[fitnessAnimation,animation2,animation3];
    fitnessAnimationGroup.duration = 0.5;
    fitnessAnimationGroup.repeatCount = 1;
    fitnessAnimationGroup.removedOnCompletion = NO;
    fitnessAnimationGroup.fillMode = kCAFillModeForwards;
    [self.fitnessBtn.layer addAnimation:fitnessAnimationGroup forKey:nil];
    
    /*跑步动画组*/
    CAAnimationGroup *runAnimationGroup = [CAAnimationGroup animation];
    runAnimationGroup.animations = @[runAnimation,animation2,animation3];
    runAnimationGroup.duration = 0.5;
    runAnimationGroup.repeatCount = 1;
    runAnimationGroup.removedOnCompletion = NO;
    runAnimationGroup.fillMode = kCAFillModeForwards;
    [self.runBtn.layer addAnimation:runAnimationGroup forKey:nil];
    
    /*瑜伽动画组*/
    CAAnimationGroup *yogaAnimationGroup = [CAAnimationGroup animation];
    yogaAnimationGroup.animations = @[yogaAnimation,animation2,animation3];
    yogaAnimationGroup.duration = 0.5;
    yogaAnimationGroup.repeatCount = 1;
    yogaAnimationGroup.removedOnCompletion = NO;
    yogaAnimationGroup.fillMode = kCAFillModeForwards;
    [self.yogaBtn.layer addAnimation:yogaAnimationGroup forKey:nil];
    
    /*ALL动画组*/
    CAAnimationGroup *allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = @[allAnimation,animation2,animation3];
    allAnimationGroup.duration = 0.5;
    allAnimationGroup.repeatCount = 1;
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    [self.allBtn.layer addAnimation:allAnimationGroup forKey:nil];
    
}

-(void)showLoadView{
    //
    //    [self.filterBtn removeFromSuperview];
    //    UIImageView *photoView = [[UIImageView alloc]init];
    //    photoView.image = [UIImage imageWithData:[[[AVUser currentUser]objectForKey:@"icon"]getData]];
    //    photoView.frame = CGRectMake(self.circleView.frame.size.width/2 - 50, self.circleView.bounds.size.height/2 - 50 + CGRectGetMaxY(self.topBtnView.frame), 100, 100);
    //    photoView.layer.masksToBounds = YES;
    //    photoView.layer.cornerRadius = photoView.frame.size.width / 2.0;
    //    self.photoView = photoView;
    //    [self.view addSubview:self.photoView];
    //    self.refreshBtn.enabled = NO;
    //
    //    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
    //    [self refreshAnimation];
    
    
    
    self.refreshBtn.enabled = NO;
    [self.filterBtn setImage:[UIImage imageWithData:[[[AVUser currentUser]objectForKey:@"icon"]getData]] forState:UIControlStateNormal];
    self.filterBtn.imageView.layer.masksToBounds = YES;
    self.filterBtn.imageView.layer.cornerRadius = self.filterBtn.imageView.frame.size.width / 2.0;
    self.photoShowedOnFilterBtn = YES;
    
}

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
    self.longitude = self.currlocation.coordinate.longitude;//获取经度
    self.latitude = self.currlocation.coordinate.latitude;//获取纬度
    NSLog(@"%f %f",self.longitude, self.latitude);
    AVGeoPoint *currentUserLocation = [AVGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    self.currentUserLocation = currentUserLocation;
    
    AVQuery *query = [SNUser query];
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchObjects = [query findObjects];
    if(fetchObjects.count == 0) return;
    SNUser *basicInfo = fetchObjects[0];
    [basicInfo setObject:self.currentUserLocation forKey:@"GeoLocation"];
    [basicInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"error %@", error.description);
    }];
    [self.locationManager stopUpdatingLocation];
    
    
    
    
}


//定位失败调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //    NSLog(@"%ld 调用失败",(long)error.code);
    
    [manager stopUpdatingLocation];
    switch((long)error.code) {
        case 1:{
            //定位没打开
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Access to Location Services denied by user" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        case kCLErrorLocationUnknown:
            //@"Location data unavailable";
            break;
        default:
            //@"An unknown error has occurred";
            break;
    }
    
    
}



//授权状态发生变化调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (!status) {
        //        NSLog(@"请打开定位");
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

-(NSMutableArray *)neverSeeAgain{
    if (_neverSeeAgain==nil) {
        _neverSeeAgain=[[NSMutableArray alloc]init];
    }
    return _neverSeeAgain;
}

-(void)didClickCrossButton {
    [self.blurView removeFromSuperview];
}
@end
