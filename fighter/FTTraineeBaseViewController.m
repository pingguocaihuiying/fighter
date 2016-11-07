//
//  FTTraineeBaseViewController.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeBaseViewController.h"

@interface FTTraineeBaseViewController ()

@end

@implementation FTTraineeBaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setNavigationbarStyle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - 设置


/**
 设置到导航栏样式
 */
- (void) setNavigationbarStyle {
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //导航栏右侧按钮
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"个人主页"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(gotoHomePage:)];
    
    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}


#pragma mark  - delegate

#pragma mark - response
- (void) backBtnAction:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) gotoHomePage:(id) sender {
    
}

@end
