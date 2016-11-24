//
//  BaseTabBarViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseTabBarViewController.h"
#import "FTStoreViewController.h"
#import "FTShopViewController.h"

#import "FTRankViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "UIButton+Badge.h"
#import "FTDailyTaskViewController.h"
#import "FTFinishedTaskViewController.h"
#import "NSDate+TaskDate.h"
#import "FTPracticeViewController.h"
#import "FTCoachSelfCourseViewController.h"

@interface FTBaseTabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) UIButton *messageBtn;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIButton *taskBtn;

@property (nonatomic, strong) UIButton *shopBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FTBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNotification];
    
    [self setNavigationbar];

    self.delegate = self;
    
    
//    //  导航栏半透明属性设置为NO,阻止导航栏遮挡view
//    self.navigationController.navigationBar.translucent = NO;
//    UINavigationController *navigationVC = self.navigationController;
    
}


- (void) viewWillAppear:(BOOL)animated {

    [self.openSliderDelegate openSlider];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [self.openSliderDelegate closeSlider];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听器

- (void) setNotification {

    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAvatar:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAvatar:) name:LoginNoti object:nil];
    
    //添加监听器，东西任务
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remindDailyTask:) name:TaskNotification object:nil];
}

#pragma mark - 设置导航栏
- (void) setNavigationbar {
    

    
    //导航栏头像按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    self.avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarBtn.frame = CGRectMake(0, 0, 34, 34);
    [self.avatarBtn addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.avatarBtn.layer setMasksToBounds:YES];
    self.avatarBtn.layer.cornerRadius = 17.0;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                              forState:UIControlStateNormal
                      placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    UIBarButtonItem *avatarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.avatarBtn];
    self.navigationItem.leftBarButtonItems  = [[NSArray alloc]initWithObjects:avatarButtonItem, nil];
    
    
    // 商城按钮
    self.shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopBtn.frame = CGRectMake(0, 0, 24, 24);
    [self.shopBtn addTarget:self action:@selector(shopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shopBtn setImage:[UIImage imageNamed:@"右上角商城"] forState:UIControlStateNormal];
//    [self.shopBtn setImage:[UIImage imageNamed:@"底部导航-商城pre"] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *shopBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.shopBtn];
    self.navigationItem.rightBarButtonItems  = [[NSArray alloc]initWithObjects:shopBtnItem,nil];
    
//    // 头部消息按钮
//    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.messageBtn.frame = CGRectMake(0, 0, 24, 24);
//    [self.messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.messageBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-消息"] forState:UIControlStateNormal];
//    [self.messageBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-消息pre"] forState:UIControlStateHighlighted];
//    
//    UIBarButtonItem *messageBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.messageBtn];
//
//    // 头部搜索按钮
//    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.searchBtn.frame = CGRectMake(0, 0, 24, 24);
//    [self.searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.searchBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-搜索"] forState:UIControlStateNormal];
//    [self.searchBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-搜索pre"] forState:UIControlStateHighlighted];
//    
//    
//    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    
//    self.navigationItem.rightBarButtonItems  = [[NSArray alloc]initWithObjects:messageBtnItem, searchBtnItem,nil];
   
//    // 头部任务按钮
//    self.taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.taskBtn.frame = CGRectMake(0, 0, 24, 24);
//    [self.taskBtn addTarget:self action:@selector(taskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    // 获取上次做任务的时间记录
//    NSDate * recordDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"FinishDate"];
//    
//    NSDate *taskDate = [NSDate taskDate];
//    
//    if ([recordDate timeIntervalSince1970] < [taskDate timeIntervalSince1970]) {
//        
//        [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务-新任务"] forState:UIControlStateNormal];
//    }else {
//        [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务"] forState:UIControlStateNormal];
//    }
//    
//
//    
//    
//    UIBarButtonItem *taskBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.taskBtn];
//    self.navigationItem.rightBarButtonItems  = [[NSArray alloc]initWithObjects:taskBtnItem,nil];
    
    
    // title View
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 22)];
    
    
    // title image
    UIImageView *titleImageView = [[UIImageView alloc]init];
    titleImageView.frame = CGRectMake(0, 0, 72, 22);
    titleImageView.image = [UIImage imageNamed:@"头部logo格斗东西"];
    
    [self.navigationItem.titleView addSubview:titleImageView];

    // title white dot
    UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(80, 8.5, 5, 5)];
    dotView.layer.cornerRadius = 2.5;
    dotView.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.titleView addSubview:dotView];
    
    
    // title label
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(93, 0, 72, 22);
    self.titleLabel.text = @"拳讯";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationItem.titleView addSubview:self.titleLabel];
    
}



#pragma mark - 监听器响应

- (void) updateAvatar:(NSNotification *) noti {

    //导航栏头像按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"LOGOUT"] || [msg isEqualToString:@"ERROR"]) {
        
        [self.avatarBtn setImage:[UIImage imageNamed:@"头像-空"] forState:UIControlStateNormal];
        
    }else {
        
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }
    
}


- (void) remindDailyTask:(NSNotification *) noti {
    
    // 日常任务按钮，暂时隐藏
//    NSLog(@"remindDailyTask");
//    
//    [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务-新任务"] forState:UIControlStateNormal];
//    
//    [self.taskBtn showMiniBadge];
//    
//    
//    [self shakingAnimation:self.taskBtn];
}

#pragma mark - button response

// 头像点击事件
- (void)avatarBtnAction:(id)sender {
    
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {

        [self.drawerDelegate leftButtonClicked:sender];
    }
}



// 搜索按钮点击事件
- (void)searchBtnAction:(id)sender {
    
    NSLog(@"serach button clicked");
    
}

// 消息按钮点击事件
- (void)messageBtnAction:(id)sender {
    
    NSLog(@"message button clicked");

}

// 任务按钮点击事件
- (void)taskBtnAction:(id)sender {
    
    NSLog(@"task button clicked");
    
    //获取登录信息，如果没有登录不能做任务，直接跳转登录页面
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
        
        return;
    }
    
    [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务"] forState:UIControlStateNormal];
    
    [self.taskBtn hideMiniBadge];

    // 获取上次做任务的时间记录
    NSDate * recordDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"FinishDate"];
    
    if (!recordDate ) {
        
        FTDailyTaskViewController * taskVC = [FTDailyTaskViewController new];
        [self.navigationController  pushViewController:taskVC animated:YES];
        
        return;
    }
    
    NSDate *taskDate = [NSDate taskDate];
    
    if ([recordDate timeIntervalSince1970] < [taskDate timeIntervalSince1970]) {
        
        FTDailyTaskViewController * taskVC = [FTDailyTaskViewController new];
        [self.navigationController  pushViewController:taskVC animated:YES];
        
    }else {
    
        FTFinishedTaskViewController *finishTaskVC = [FTFinishedTaskViewController new];
        [self.navigationController  pushViewController:finishTaskVC animated:YES];
    }
    
}


/**
 商城按钮点击事件

 @param sender 商城按钮
 */
- (void) shopBtnAction:(id) sender {

    FTShopViewController *shopVC = [FTShopViewController new];
    shopVC.title = @"格斗商城";
    [self.navigationController  pushViewController:shopVC animated:YES];
}

#pragma mark  - login

- (void)login{
    
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
        
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    self.titleLabel.text = viewController.title;
}



#pragma mark - 抖动动画
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
- (void)shakingAnimation:(UIButton *)button {
    
    // 放大动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = 0.1;
    scaleAnimation.beginTime = 0.0;
    
    // 晃动动画
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animation];
    rotationAnimation.keyPath = @"transform.rotation";
    rotationAnimation.values = @[@(Angle2Radian(-15)),  @(Angle2Radian(15)), @(Angle2Radian(0))];
    rotationAnimation.duration = 0.20;
    
    // 动画次数设置为最大
    rotationAnimation.repeatCount = 3;
    
    // 保持动画执行完毕后的状态
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.beginTime = 0.1;
    
    // 缩小动画
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
    shrinkAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    shrinkAnimation.removedOnCompletion = NO;
    shrinkAnimation.duration = 0.1;
    shrinkAnimation.beginTime = 0.7;

    
    // 动画组
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 1.0;
    groupAnnimation.removedOnCompletion = NO;
    groupAnnimation.animations = @[rotationAnimation, scaleAnimation, shrinkAnimation];
    groupAnnimation.repeatCount = 3;
    //开演
    [button.layer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
    
}

@end
