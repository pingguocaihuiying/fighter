//
//  FTRankBaseViewController.m
//  fighter
//
//  Created by kang on 16/5/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankBaseViewController.h"


@interface FTRankBaseViewController ()

@end

@implementation FTRankBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置状态栏的颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setRankBaseViewControllerStyle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    self.netStatus = [GLobalRealReachability currentReachabilityStatus];
//    NSLog(@"currentStatus:%@,", @(_netStatus));
    
    
    self.navigationController.navigationBarHidden = NO;
    
    //  导航栏半透明属性设置为NO,阻止导航栏遮挡view
    self.navigationController.navigationBar.translucent = NO;
    
    // 修改edgesForExtendedLayout,阻止导航栏遮挡View
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

// 设置跟视图控制器样式
- (void) setRankBaseViewControllerStyle {
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
//    
    
    self.navigationController.navigationBarHidden = NO;
}


- (void) backBtnAction:(id) ender {

    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Reachability Methods


/*!
 * Called by Reachability whenever status changes.
 */
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    self.netStatus = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(_netStatus), @(previousStatus));
    
    if (self.netStatus == RealStatusNotReachable)
    {
        
        NSLog(@"Network unreachable!");
    }
    
    if (self.netStatus == RealStatusViaWiFi)
    {
       NSLog(@"Network wifi! Free!");
    }
    
    if (self.netStatus == RealStatusViaWWAN)
    {
        NSLog(@"Network WWAN! In charge!");
        WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
        if (accessType == WWANType2G)
        {
            NSLog(@"RealReachabilityStatus2G");
        }
        else if (accessType == WWANType3G)
        {
            NSLog(@"RealReachabilityStatus3G");
        }
        else if (accessType == WWANType4G)
        {
            NSLog(@"RealReachabilityStatus4G");
        }
        else
        {
            NSLog(@"Unknown RealReachability WWAN Status, might be iOS6");
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
