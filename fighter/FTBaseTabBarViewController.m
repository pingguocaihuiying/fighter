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
#import "FTFightingViewController.h"


@interface FTBaseTabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *avatarButton;

@property (nonatomic, strong) UIButton *taskButton;

@property (nonatomic, strong) UIBarButtonItem *avatarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *messageButtonItem;

@property (nonatomic, strong) UIBarButtonItem *searchButtonItem;

@property (nonatomic, strong) UIBarButtonItem *taskButtonItem;

@property (nonatomic, strong) UIBarButtonItem *shopButtonItem;

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation FTBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNotification];
    
    [self setNavigationbar];

    self.delegate = self;
}


- (void) viewWillAppear:(BOOL)animated {

    [self.openSliderDelegate openSlider];
    
    if (self.selectedIndex == 1) {
        
         [self showRankButton];
    }
    
    // 个人主页隐藏导航栏
    if (self.selectedIndex == 4) {
        [self.navigationController setNavigationBarHidden:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    // 显示会员拳馆
    if (self.selectedIndex == 2) {
        [FTNotificationTools postShowMembershipGymsNoti];
    }
    
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [self.openSliderDelegate closeSlider];
    
    if (self.selectedIndex == 1) {
        
        [self hideRankButton];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - 监听器

- (void) setNotification {

    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
    
    //添加监听器，东西任务
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remindDailyTask:) name:TaskNotification object:nil];
    
    //添加监听器，东西任务
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchControllerAction:) name:InAPPSwitchControllerNoti object:nil];
}

#pragma mark - 设置导航栏
- (void) setNavigationbar {
    
//    self.navigationController.navigationBar.delegate = self;
    
//    self.transitioningDelegate = self;
    
    self.navigationItem.leftBarButtonItems  = [[NSArray alloc]initWithObjects:self.avatarButtonItem, nil];
    
    self.navigationItem.rightBarButtonItem = self.shopButtonItem;
    
    
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

#pragma mark - 导航栏按钮


/**
 avatar button item

 @return
 */
- (UIBarButtonItem *) avatarButtonItem {
    
    if (!_avatarButtonItem) {
        _avatarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.avatarButton];
    }
   
    return _avatarButtonItem;
}

- (UIButton *) avatarButton {
    
    if (!_avatarButton) {
        //导航栏头像按钮
        FTUserBean *localUser = [FTUserBean loginUser];
        
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.frame = CGRectMake(0, 0, 34, 34);
        [_avatarButton addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_avatarButton.layer setMasksToBounds:YES];
        _avatarButton.layer.cornerRadius = 17.0;
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }
    
    return _avatarButton;
}

/**
 shop button item
 */
- (UIBarButtonItem *) shopButtonItem {

    if (!_shopButtonItem) {
        // 商城按钮
        //    UIBarButtonItem *
        UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shopButton.frame = CGRectMake(0, 0, 34, 34);
        [shopButton addTarget:self action:@selector(shopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [shopButton setTitle:@"商城" forState:UIControlStateNormal];
        [shopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shopButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _shopButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
//        _shopButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"商城" style:UIBarButtonItemStyleDone target:self action:@selector(shopBtnAction:)];
//        [_shopButtonItem setTintColor:[UIColor whiteColor]];
        
        //   _shopButtonItem = [[UIBarButtonItem alloc]
        //                                   initWithImage:[[UIImage imageNamed:@"右上角商城"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
        //                                   style:UIBarButtonItemStyleDone
        //                                   target:self
        //                                   action:@selector(shopBtnAction:)];
    }
    
    return _shopButtonItem;
}



/**
 message button item
 */
- (UIBarButtonItem *) messageButtonItem {
    
    if (!_messageButtonItem) {
        
        _messageButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                              style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(messageBtnAction:)];
    }
    
    return _messageButtonItem;
    
}


/**
 search button item
 */
- (UIBarButtonItem *) searchButtonItem {
    
    if (!_searchButtonItem) {
        _searchButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(searchBtnAction:)];
    }
    
    return _searchButtonItem;
}


/**
 task button item
 */
- (UIBarButtonItem *) taskButtonItem {

    if (!_taskButtonItem) {
        
        _searchButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.taskButton];
    }
    return _taskButtonItem;
}

/**
 daily task button
 */
- (UIButton *) taskButton {

    if (!_taskButton) {
        
        // 头部任务按钮
        _taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _taskButton.frame = CGRectMake(0, 0, 24, 24);
        [_taskButton addTarget:self action:@selector(taskBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 获取上次做任务的时间记录
        NSDate * recordDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"FinishDate"];
        
        NSDate *taskDate = [NSDate taskDate];
        
        if ([recordDate timeIntervalSince1970] < [taskDate timeIntervalSince1970]) {
            
            [_taskButton setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务-新任务"] forState:UIControlStateNormal];
        }else {
            [_taskButton setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务"] forState:UIControlStateNormal];
        }
    }
    return _taskButton;
}



#pragma mark - show and hide rank Button
/**
 show fighting view controller rank button
 */
- (void) showRankButton {
    
    FTFightingViewController *fightingVC = [self.viewControllers objectAtIndex:1];
    [fightingVC showRankButton];
}

/**
 hide fighting view controller rank button
 */
- (void) hideRankButton {
    
    FTFightingViewController *fightingVC = [self.viewControllers objectAtIndex:1];
    [fightingVC hideRankButton];
    
}


#pragma mark - 监听器响应

// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    FTUserBean *localUser = [FTUserBean loginUser];
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }else {
    
        [self.avatarButton setImage:[UIImage imageNamed:@"头像-空"] forState:UIControlStateNormal];
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

- (void) switchControllerAction:(NSNotification *) noti {

    NSNumber *obj = noti.object;
    NSInteger index = obj.integerValue;
    
    if (index < self.viewControllers.count) {
        self.selectedIndex = index;
        [FTNotificationTools postSwitchNewsDetailControllerWithDic:nil];
    }
    
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

// 任务按钮点击事件, 暂时注销
- (void)taskBtnAction:(id)sender {

    NSLog(@"task button clicked");
    
    //获取登录信息，如果没有登录不能做任务，直接跳转登录页面
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
        
        return;
    }
    
    [self.taskButton setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务"] forState:UIControlStateNormal];
    
    [self.taskButton hideMiniBadge];

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


/**
 排行榜按钮点击事件,跳转排行榜页面
 
 @param sender 排行榜按钮
 */

- (void)rankListBtnAction:(id)sender {
    
    FTRankViewController *rankHomeVC = [FTRankViewController new];
    rankHomeVC.title = @"排行榜";
    [self.navigationController pushViewController:rankHomeVC animated:YES];
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

    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 4) {
        FTUserBean *loginuser = [FTUserBean loginUser];
        if (!loginuser) {
            [self login];
            return NO;
        }
    }
    
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
//    NSLog(@"select index:%ld",tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == 1) {
        [self showRankButton];
    }else {
        [self hideRankButton];
    }
    self.titleLabel.text = viewController.title;
    
    
    // 个人主页隐藏导航栏
    if (tabBarController.selectedIndex == 4) {
        [self.navigationController setNavigationBarHidden:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    // 显示会员拳馆
    if (tabBarController.selectedIndex == 2) {
        [FTNotificationTools postShowMembershipGymsNoti];
    }
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
