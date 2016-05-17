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
    
    [self setRankBaseViewControllerStyle];
}

// 设置跟视图控制器样式
- (void) setRankBaseViewControllerStyle {
    
    
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置左侧按钮,在根上设置，以后继承（第一次尝试这么做）
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
//    
    
    self.navigationController.navigationBarHidden = NO;
}


- (void) backBtnAction:(id) ender {

    [self.navigationController popViewControllerAnimated:YES];

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
