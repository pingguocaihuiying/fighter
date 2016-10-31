//
//  FTCourseViewController.m
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeViewController.h"
#import "FTTraineeCell.h"
#import "FTTraineeHeaderView.h"


@interface FTTraineeViewController ()

@end

@implementation FTTraineeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - 设置
- (void) setSubviews {
    [self setNavigationbar];
}


/**
 设置到导航栏样式
 */
- (void) setNavigationbar {
    self.title = @"我的课程";
    
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
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"个人中心"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(gotoHomePage:)];
    
    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = rightBarButton;
   
}


/**
 设置 collection View
 */
- (void) setCollectionView {

}

#pragma mark  - pull data from web 


#pragma mark  - delegate 

#pragma mark - response 

- (void) gotoHomePage:(id) sender {

}

@end
