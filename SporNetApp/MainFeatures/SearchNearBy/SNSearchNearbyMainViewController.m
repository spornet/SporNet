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
#import "globalMacros.h"

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication]statusBarFrame].size.height
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SNSearchNearbyMainViewController ()
//@property (weak, nonatomic ) UIButton       *filterBtn;
@property (weak, nonatomic ) UIButton       *filterBtnInBlurView;
@property (weak, nonatomic ) UIButton       *basketballBtn;
@property (weak, nonatomic ) UIButton       *footballBtn;
@property (weak, nonatomic ) UIButton       *fitnessBtn;
@property (weak, nonatomic ) UIButton       *runBtn;
@property (weak, nonatomic ) UIButton       *yogaBtn;
@property (weak, nonatomic ) UIButton       *allBtn;
@property(weak,nonatomic) UIVisualEffectView *blurView;




@property (nonatomic       ) BOOL           isFinishLoad;
@property (weak, nonatomic ) UIImageView    *galaxyImageView;
@property (weak, nonatomic ) UIView         *topBtnView;
@property (weak,nonatomic  ) UIView         *circleView;
@property (weak, nonatomic ) UIView         *user1Area;
@property (weak, nonatomic ) UIView         *user2Area;
@property (weak, nonatomic ) UIView         *user3Area;
@property (weak, nonatomic ) UIView         *user4Area;
@property (weak, nonatomic ) UIView         *user5Area;

@property (weak, nonatomic ) UIButton       *filterBtn;
@property (weak, nonatomic ) UIButton      *user1;
@property(weak, nonatomic) UIImageView *bestSportImageView1;
@property (weak, nonatomic ) UIButton       *user2;
@property (weak, nonatomic ) UIButton       *user3;
@property (weak, nonatomic ) UIButton       *user4;
@property (weak, nonatomic ) UIButton      *user5;

@property (nonatomic,assign) CGFloat        x1;
@property (nonatomic,assign) CGFloat        y1;
@property (nonatomic,assign) CGFloat        x2;
@property (nonatomic,assign) CGFloat        y2;
@property (nonatomic,assign) CGFloat        x3;
@property (nonatomic,assign) CGFloat        y3;
@property (nonatomic,assign) CGFloat        x4;
@property (nonatomic,assign) CGFloat        y4;
@property (nonatomic,assign) CGFloat        x5;
@property (nonatomic,assign) CGFloat        y5;
@property (nonatomic,assign) CGFloat        dist1;
@property (nonatomic,assign) CGFloat        dist2;
@property (nonatomic,assign) CGFloat        dist3;
@property (nonatomic,assign) CGFloat        dist4;
@property (nonatomic,assign) CGFloat        dist5;
//@property (nonatomic,assign) BOOL           isUserAppear;
//用户的半径，更确切的说是用户生成地点距离所在view的边距。用户按钮的大小主要有pop函数的toValue来控制，如果toValue是50，但是userR＝100则在view内边距为userR－toValue的范围内活动。
@property(nonatomic,assign) CGFloat userR;


@property NSMutableArray *allUsers;
@property NSMutableArray *currentUsers;
@end

@implementation SNSearchNearbyMainViewController
NSInteger indexOfCurrentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.allUsers = [[LocalDataManager defaultManager]fetchCurrentAllUserInfo];
    [self setBackgroundGalaxy];
    [self addTopView];
    [self addCircleView];
    //    1.先设置界面x6
    //    2.在NSArray中判断有没有数据
    //    if(yes){
    //    初始化按钮显示数据
    //    if (view.childView.count == 0) {
    //        [self initBtn];
    //    }
    //    }else if{
    //    后台加载数据，同时调用clickRefreshBtn
    //    }
    
    self.userR = 50;

    self.allUsers = [[LocalDataManager defaultManager]fetchCurrentAllUserInfo];
    if(_allUsers.count == 0) {
        [ProgressHUD showError:@"Bad connection. Please try later."];
        return;
    }
    
    self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0], _allUsers[1],_allUsers[2], _allUsers[3], _allUsers[4]]];
    [self createUser1Btn];
    [self createUser2Btn];
    [self createUser3Btn];
    [self createUser4Btn];
    [self createUser5Btn];
    indexOfCurrentUser = 5;
    self.tabBarController.tabBar.hidden = NO;
    //    self.isUserAppear = YES;
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [self.blurView removeFromSuperview];
}


-(void)createUser1Btn{
    [self randomUser1Coordinate];
    UIButton *user1 = [[UIButton alloc]initWithFrame:CGRectMake(self.x1, self.y1, self.userR, self.userR)];
//    UserView *user1 = [[UserView alloc]initWithFrame:CGRectMake(100, 100, 60, 60)];
    //[user1 configureUserViewWithUserInfo:_currentUsers[0]];
    if([_currentUsers[0] objectForKey:@"icon"]) [user1 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[0] objectForKey:@"icon"]getData]] forState:normal];
        else [user1 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    [[user1 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[0] objectForKey:@"sportTimeSlot"]integerValue]];
    [user1.layer setBorderColor:color.CGColor];
    user1.layer.masksToBounds = YES;
    user1.layer.cornerRadius = user1.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(0, 0, 18, 18);
    //bestsportView.center = CGPointMake(user1.center.x + 20, user1.center.y);
    bestsportView.center = CGPointMake(48, 25);
    bestsportView.image = [UIImage imageNamed:@"basketballSelected"];
    NSLog(@"current user name is %@", [self.currentUsers[0] objectForKey:@"name"]);
    [self.view addSubview:user1];
    [user1 addSubview:bestsportView];
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
    [self.user1.layer pop_addAnimation:anim forKey:@"size"];
    
//        NSLog(@"%f %f",self.x,self.y);
    
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
    [self.view addSubview:user2];
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
    [self.user2.layer pop_addAnimation:anim forKey:@"size"];
    
//        NSLog(@"%f %f",self.x,self.y);
    
}

-(void)createUser3Btn{
    [self randomUser3Coordinate];
    UIButton *user3 = [[UIButton alloc]initWithFrame:CGRectMake(self.x3, self.y3, self.userR, self.userR)];
    //[user3 configureUserViewWithUserInfo:_currentUsers[2]];
    if([_currentUsers[2] objectForKey:@"icon"]) [user3 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[2] objectForKey:@"icon"]getData]] forState:normal];
    else [user3 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    NSLog(@"current user name is %@", [self.currentUsers[2] objectForKey:@"name"]);
    [[user3 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[2] objectForKey:@"sportTimeSlot"]integerValue]];
    [user3.layer setBorderColor:color.CGColor];
    user3.layer.masksToBounds = YES;
    user3.layer.cornerRadius = user3.frame.size.width / 2.0;
    [self.view addSubview:user3];
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
    [self.user3.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    
}

-(void)createUser4Btn{
    [self randomUser4Coordinate];
    UIButton *user4 = [[UIButton alloc]initWithFrame:CGRectMake(self.x4, self.y4, self.userR, self.userR)];
    //[user4 configureUserViewWithUserInfo:_currentUsers[3]];

    if([_currentUsers[3] objectForKey:@"icon"]) [user4 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[3] objectForKey:@"icon"]getData]] forState:normal];
    else [user4 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    NSLog(@"current user name is %@", [self.currentUsers[3] objectForKey:@"name"]);
    [[user4 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[3] objectForKey:@"sportTimeSlot"]integerValue]];
    [user4.layer setBorderColor:color.CGColor];
    user4.layer.masksToBounds = YES;
    user4.layer.cornerRadius = user4.frame.size.width / 2.0;
    [self.view addSubview:user4];
    self.user4 = user4;
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
    [self.user4.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    
}

-(void)createUser5Btn{
    [self randomUser5Coordinate];
    UIButton *user5 = [[UIButton alloc]initWithFrame:CGRectMake(self.x5, self.y5, self.userR, self.userR)];
    //[user5 configureUserViewWithUserInfo:_currentUsers[4]];
    //[user5 setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    if([_currentUsers[4] objectForKey:@"icon"]) [user5 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[4] objectForKey:@"icon"]getData]] forState:normal];
    ;
    NSLog(@"current user name is %@", [self.currentUsers[4] objectForKey:@"name"]);
    [[user5 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[4] objectForKey:@"sportTimeSlot"]integerValue]];
    [user5.layer setBorderColor:color.CGColor];
    user5.layer.masksToBounds = YES;
    user5.layer.cornerRadius = user5.frame.size.width / 2.0;
    [self.view addSubview:user5];
    self.user5 = user5;
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
    [self.user5.layer pop_addAnimation:anim forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    
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


- (void) dragUser1Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist1 = [self distanceFromPointA:CGPointMake(self.x1+self.userR/2, self.y1+self.userR/2) toPointB:c.center];
    self.dist1 = dist1;
    self.bestSportImageView1.center = CGPointMake(c.center.x + 25, c.center.y);
    //    NSLog(@"%f",self.dist);
}

-(void)ifUser1Remove{
    
    if (self.dist1 < 10) {
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
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        if(indexOfCurrentUser == self.allUsers.count) return;
        self.currentUsers[0] = self.allUsers[indexOfCurrentUser];
        indexOfCurrentUser++;
        [self createUser1Btn];
        self.dist1 = 0;
    }
    
}
-(void)showUserInfo:(AVObject*)userInfo {

    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    vc.delegate = self;
    vc.currentUserProfile = (SNUser*)userInfo;
        NSLog(@"A");
    [self addChildViewController:vc];
        vc.view.frame = CGRectMake(20, 50, SCREEN_WIDTH-40, SCREEN_HEIGHT-100);
        NSLog(@"B");
    
    [self.blurView addSubview:vc.view];
        NSLog(@"C");
    
        NSLog(@"D");
    NSLog(@"user name is %@", [userInfo objectForKey:@"name"]);
}
- (void) dragUser2Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist2 = [self distanceFromPointA:CGPointMake(self.x2+self.userR/2, self.y2+self.userR/2) toPointB:c.center];
    self.dist2 = dist2;
}


- (void) dragUser3Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist3 = [self distanceFromPointA:CGPointMake(self.x3+self.userR/2, self.y3+self.userR/2) toPointB:c.center];
    self.dist3 = dist3;
    //    NSLog(@"%f",self.dist);
}


- (void) dragUser4Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist4 = [self distanceFromPointA:CGPointMake(self.x4+self.userR/2, self.y4+self.userR/2) toPointB:c.center];
    self.dist4 = dist4;
    //    NSLog(@"%f",self.dist);
}


- (void) dragUser5Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    float dist5 = [self distanceFromPointA:CGPointMake(self.x5+self.userR/2, self.y5+self.userR/2) toPointB:c.center];
    self.dist5 = dist5;
    //    NSLog(@"%f",self.dist);
}

-(void)ifUser2Remove{
    if (self.dist2 == 0) {
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
        } completion:nil];
        self.dist2 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user2.frame];
        [self.user2 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        if(indexOfCurrentUser == self.allUsers.count) return;
        self.currentUsers[1] = self.allUsers[indexOfCurrentUser];
        indexOfCurrentUser++;
        [self createUser2Btn];
        self.dist2 = 0;
    }
    
}

-(void)ifUser3Remove{
    
    if (self.dist3 == 0) {
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
        } completion:nil];
        self.dist3 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user3.frame];
        [self.user3 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        if(indexOfCurrentUser == self.allUsers.count) return;
        self.currentUsers[2] = self.allUsers[indexOfCurrentUser];
        indexOfCurrentUser++;
        [self createUser3Btn];
        self.dist3 = 0;
    }
    
}

-(void)ifUser4Remove{
    
    if (self.dist4 == 0) {
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
        } completion:nil];
        self.dist4 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user4.frame];
        [self.user4 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        if(indexOfCurrentUser == self.allUsers.count) return;
        self.currentUsers[3] = self.allUsers[indexOfCurrentUser];
        indexOfCurrentUser++;
        [self createUser4Btn];
        self.dist4 = 0;
    }
    
}

-(void)ifUser5Remove{
    
    if (self.dist5 == 0) {
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
        } completion:nil];
        
        
        self.dist5 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user5.frame];
        [self.user5 removeFromSuperview];
        [self.view addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
        
        if(indexOfCurrentUser == self.allUsers.count) return;
        self.currentUsers[4] = self.allUsers[indexOfCurrentUser];
        indexOfCurrentUser++;
        [self createUser5Btn];
        self.dist5 = 0;
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
    
    UIView *user1Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user1Area.backgroundColor = [UIColor redColor];
    [self.view addSubview:user1Area];
    self.user1Area = user1Area;
    
    UIView *user2Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user2Area.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:user2Area];
    self.user2Area = user2Area;
    
    UIView *user3Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.user1Area.frame), MAIN_SCREEN_WIDTH/2-37.5, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user3Area.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:user3Area];
    self.user3Area = user3Area;
    
    UIView *user4Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2+37.5, CGRectGetMaxY(self.user1Area.frame), MAIN_SCREEN_WIDTH/2-37.5, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user4Area.backgroundColor = [UIColor greenColor];
    [self.view addSubview:user4Area];
    self.user4Area = user4Area;
    
    UIView *user5Area = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/4, CGRectGetMaxY(self.user3Area.frame), MAIN_SCREEN_WIDTH/2, (MAIN_SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.topBtnView.bounds.size.height)/3)];
    //    user5Area.backgroundColor = [UIColor blueColor];
    [self.view addSubview:user5Area];
    self.user5Area = user5Area;
    
    UIButton *filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 37.5, self.circleView.bounds.size.height/2 - 37.5, 75, 75)];
    [filterBtn setImage:[UIImage imageNamed:@"bgn"] forState:UIControlStateNormal];
    [self.circleView addSubview:filterBtn];
    self.filterBtn = filterBtn;
    [self.filterBtn addTarget:self action:@selector(sportFilterClick) forControlEvents:UIControlEventTouchUpInside];
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
    radiusImageView.backgroundColor = [UIColor whiteColor];
    [self.topBtnView addSubview:radiusImageView];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 - 75, self.topBtnView.bounds.size.height/2 + 30, 150, 20)];
    topLabel.text = @"我是距离";
    topLabel.textColor = [UIColor blueColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor whiteColor];
    [self.topBtnView addSubview:topLabel];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.topBtnView.frame) - 10 - 35, self.topBtnView.bounds.size.height/2 - 50, 35, 35)];
    refreshBtn.backgroundColor = [UIColor whiteColor];
    _isFinishLoad = YES;
    [refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topBtnView addSubview:refreshBtn];
    
}

-(void)clickRefreshBtn{
    //    [self 加载数据];
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    
    [self refreshAnimation];
    for(int i = 0; i < 5; i++) {
        NSLog(@"hahahahah %ld", indexOfCurrentUser+i);
        if(indexOfCurrentUser == _allUsers.count) continue;
        self.currentUsers[i] = self.allUsers[indexOfCurrentUser];
        NSString *str = [NSString stringWithFormat:@"createUser%dBtn", i + 1];
        SEL s = NSSelectorFromString(str);
        [self performSelector:s];
        indexOfCurrentUser++;
    }
}

-(void)refreshAnimation{
    
    __block WaterView *waterView = [[WaterView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH / 2 - 20, MAIN_SCREEN_HEIGHT / 2 + 50, 40, 40)];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:waterView];
    
    [UIView animateWithDuration:4 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 9, 9);
        waterView.alpha = 0;
    }completion:^(BOOL finished){
        [waterView removeFromSuperview];
    }];
    
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
    
    [self configreBlurView];
    [self addSportBtn];
    
    
    UIButton *filterBtnInBlurView = [[UIButton alloc]initWithFrame:CGRectMake(self.circleView.frame.size.width/2 - 37.5, self.circleView.bounds.size.height/2 - 37.5 + self.topBtnView.frame.size.height + STATUS_BAR_HEIGHT, 75, 75)];
    [filterBtnInBlurView setImage:[UIImage imageNamed:@"bgn"] forState:UIControlStateNormal];
    [self.blurView addSubview:filterBtnInBlurView];
    self.filterBtnInBlurView = filterBtnInBlurView;
    [self.filterBtnInBlurView addTarget:self action:@selector(removeBlurView) forControlEvents:UIControlEventTouchUpInside];
    
    [self beginAnimation];
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
    self.allUsers = [[LocalDataManager defaultManager]fetchUserInfoBySportType:((UIView*)sender).tag];
    indexOfCurrentUser = 0;
    [self removeBlurView];
    [self clickRefreshBtn];
}
-(void)allSportSelected {
    [self removeBlurView];
    indexOfCurrentUser = 0;
    self.allUsers = [[LocalDataManager defaultManager]fetchCurrentAllUserInfo];
    [self clickRefreshBtn];
}
/*开始播放*/
-(void) beginAnimation{
    /*篮球动画设置*/
    CAKeyframeAnimation *basketballAnimation = [CAKeyframeAnimation animation];
    basketballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *basketballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition = self.basketballBtn.layer.position;
    CGFloat originalX = originalPosition.x;
    CGFloat originalY = originalPosition.y;
    [basketballPath moveToPoint:CGPointMake(originalX, originalY)];
    [basketballPath addQuadCurveToPoint:CGPointMake(originalX - 150, originalY) controlPoint:CGPointMake(originalX, originalY + 130)];
    basketballAnimation.path = basketballPath.CGPath;
    
    /*足球动画设置*/
    CAKeyframeAnimation *footballAnimation = [CAKeyframeAnimation animation];
    footballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *footballPath = [UIBezierPath bezierPath];
    [footballPath moveToPoint:CGPointMake(originalX, originalY)];
    [footballPath addQuadCurveToPoint:CGPointMake(originalX + 75, originalY + 140) controlPoint:CGPointMake(originalX + 120, originalY - 65)];
    footballAnimation.path = footballPath.CGPath;
    
    /*健身动画设置*/
    CAKeyframeAnimation *fitnessAnimation = [CAKeyframeAnimation animation];
    fitnessAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *fitnessPath = [UIBezierPath bezierPath];
    [fitnessPath moveToPoint:CGPointMake(originalX, originalY)];
    [fitnessPath addQuadCurveToPoint:CGPointMake(originalX - 75, originalY + 140) controlPoint:CGPointMake(originalX + 120, originalY + 65)];
    fitnessAnimation.path = fitnessPath.CGPath;
    
    /*跑步动画设置*/
    CAKeyframeAnimation *runAnimation = [CAKeyframeAnimation animation];
    runAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *runPath = [UIBezierPath bezierPath];
    [runPath moveToPoint:CGPointMake(originalX, originalY)];
    [runPath addQuadCurveToPoint:CGPointMake(originalX + 150, originalY) controlPoint:CGPointMake(originalX, originalY - 130)];
    runAnimation.path = runPath.CGPath;
    
    /*瑜伽动画设置*/
    CAKeyframeAnimation *yogaAnimation = [CAKeyframeAnimation animation];
    yogaAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *yogaPath = [UIBezierPath bezierPath];
    [yogaPath moveToPoint:CGPointMake(originalX, originalY)];
    [yogaPath addQuadCurveToPoint:CGPointMake(originalX + 75, originalY - 140) controlPoint:CGPointMake(originalX - 120, originalY - 65)];
    yogaAnimation.path = yogaPath.CGPath;
    
    /*ALL动画设置*/
    CAKeyframeAnimation *allAnimation = [CAKeyframeAnimation animation];
    allAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    [allPath moveToPoint:CGPointMake(originalX, originalY)];
    [allPath addQuadCurveToPoint:CGPointMake(originalX - 75, originalY - 140) controlPoint:CGPointMake(originalX - 120, originalY + 65)];
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
    self.basketballBtn.center = CGPointMake(originalX - 150, originalY);
    
    /*足球动画组*/
    CAAnimationGroup *footballAnimationGroup = [CAAnimationGroup animation];
    footballAnimationGroup.animations = @[footballAnimation,animation2,animation3];
    footballAnimationGroup.duration = 0.5;
    footballAnimationGroup.repeatCount = 1;
    footballAnimationGroup.removedOnCompletion = NO;
    footballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.footballBtn.layer addAnimation:footballAnimationGroup forKey:nil];
    self.footballBtn.center = CGPointMake(originalX + 75, originalY + 140);
    
    /*健身动画组*/
    CAAnimationGroup *fitnessAnimationGroup = [CAAnimationGroup animation];
    fitnessAnimationGroup.animations = @[fitnessAnimation,animation2,animation3];
    fitnessAnimationGroup.duration = 0.5;
    fitnessAnimationGroup.repeatCount = 1;
    fitnessAnimationGroup.removedOnCompletion = NO;
    fitnessAnimationGroup.fillMode = kCAFillModeForwards;
    [self.fitnessBtn.layer addAnimation:fitnessAnimationGroup forKey:nil];
    self.fitnessBtn.center = CGPointMake(originalX - 75, originalY + 140);
    
    /*跑步动画组*/
    CAAnimationGroup *runAnimationGroup = [CAAnimationGroup animation];
    runAnimationGroup.animations = @[runAnimation,animation2,animation3];
    runAnimationGroup.duration = 0.5;
    runAnimationGroup.repeatCount = 1;
    runAnimationGroup.removedOnCompletion = NO;
    runAnimationGroup.fillMode = kCAFillModeForwards;
    [self.runBtn.layer addAnimation:runAnimationGroup forKey:nil];
    self.runBtn.center = CGPointMake(originalX + 150, originalY);
    
    /*瑜伽动画组*/
    CAAnimationGroup *yogaAnimationGroup = [CAAnimationGroup animation];
    yogaAnimationGroup.animations = @[yogaAnimation,animation2,animation3];
    yogaAnimationGroup.duration = 0.5;
    yogaAnimationGroup.repeatCount = 1;
    yogaAnimationGroup.removedOnCompletion = NO;
    yogaAnimationGroup.fillMode = kCAFillModeForwards;
    [self.yogaBtn.layer addAnimation:yogaAnimationGroup forKey:nil];
    self.yogaBtn.center = CGPointMake(originalX + 75, originalY - 140);
    
    /*ALL动画组*/
    CAAnimationGroup *allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = @[allAnimation,animation2,animation3];
    allAnimationGroup.duration = 0.5;
    allAnimationGroup.repeatCount = 1;
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    [self.allBtn.layer addAnimation:allAnimationGroup forKey:nil];
    self.allBtn.center = CGPointMake(originalX - 75, originalY - 140);
    
}
-(void)didClickCrossButton {
    [self.blurView removeFromSuperview];
}
@end