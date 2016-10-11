//
//  FTBaseViewController2.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

@interface FTBaseViewController2 ()

@end

@implementation FTBaseViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    self.navigationController.navigationBarHidden = NO;
    
    //  导航栏半透明属性设置为NO,阻止导航栏遮挡view
    self.navigationController.navigationBar.translucent = NO;
    
    // 修改edgesForExtendedLayout,阻止导航栏遮挡View
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    //设置状态栏的颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

// 跳转登录界面方法
- (BOOL) isLogined {
    
    FTUserBean *user = [FTUserBean loginUser];
    if (!user) {
        
        FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
        loginVC.title = @"登录";
        FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}


- (void) backBtnAction:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
