//
//  BaseTabBarViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseTabBarViewController.h"
#import "FTStoreViewController.h"
#import "FTRankViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "UIButton+Badge.h"

@interface FTBaseTabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) UIButton *messageBtn;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIButton *taskBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FTBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNotification];
    
    [self setNavigationbar];
    
//    [self loadAvatar];
    
    
    self.delegate = self;
    
    
    //  导航栏半透明属性设置为NO,阻止导航栏遮挡view
    self.navigationController.navigationBar.translucent = NO;
    
    // 修改edgesForExtendedLayout,阻止导航栏遮挡View
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
   
    // 头部任务按钮
    self.taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.taskBtn.frame = CGRectMake(0, 0, 24, 24);
    [self.taskBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务"] forState:UIControlStateNormal];
    [self.taskBtn setImage:[UIImage imageNamed:@"头部48按钮一堆-日常任务pre"] forState:UIControlStateHighlighted];
    
    
    UIBarButtonItem *taskBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.taskBtn];
    self.navigationItem.rightBarButtonItems  = [[NSArray alloc]initWithObjects:taskBtnItem,nil];
    
    
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
    self.titleLabel.text = @"排行榜";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationItem.titleView addSubview:self.titleLabel];
    
//    self.navigationItem.rightBarButtonItem = messageBtnItem;
    
}


//- (void) loadAvatar {
//
//    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
//        
//        [self.drawerDelegate addButtonToArray:self.avatarBtn];
//    }
//
//}

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
    
//    static NSInteger count = 0;
//    count ++;
//    self.messageBtn.badgeValue = [NSString stringWithFormat:@"%ld",count];
//    [self shakingAnimation];
    
    [self.messageBtn showMiniBadge];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.messageBtn hideMiniBadge];
    });
}

// 任务按钮点击事件
- (void)taskBtnAction:(id)sender {
    
    NSLog(@"task button clicked");
    
    [self.taskBtn showMiniBadge];
    
    [self shakingAnimation:self.taskBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageBtn hideMiniBadge];
    });
}


#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if (tabBarController.selectedIndex != 3 && [viewController isKindOfClass:[FTStoreViewController class]]) {
        
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        
        if ( !localUser) {
            
            FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
            loginVC.title = @"登录";
            FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            [[UIApplication sharedApplication].keyWindow addLabelWithMessage:@"兄弟，格斗商城只有在登录之后才能进入~" second:3];
            
            return NO;
        }
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    self.titleLabel.text = viewController.title;
    
    
//    if (tabBarController.selectedIndex != 3) {
//        return;
//    }
//    //从本地读取存储的用户信息
//    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//    
//    if (localUser) {
//        return;
//    }
//    
//    if ( [viewController isKindOfClass:[FTStoreViewController class]]) {
//        
//        FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
//        loginVC.title = @"登录";
//        FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
//        
//        [[UIApplication sharedApplication].keyWindow addLabelWithMessage:@"兄弟，格斗商城只有在登录之后才能进入~" second:3];
//    }
}


#pragma mark - 抖动动画
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
- (void)shakingAnimation:(UIButton *)button {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-15)),  @(Angle2Radian(15)), @(Angle2Radian(0))];
    anim.duration = 0.20;
    
    // 动画次数设置为最大
    anim.repeatCount = 3;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [button.layer addAnimation:anim forKey:@"shake"];
}

@end
