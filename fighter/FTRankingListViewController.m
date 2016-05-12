//
//  FTRankingListViewController.m
//  fighter
//
//  Created by Liyz on 5/11/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTRankingListViewController.h"

@interface FTRankingListViewController ()

@end

@implementation FTRankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)setSubViews{
    [self setNaviItems];
}

- (void)setNaviItems{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
//    把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    //修改title的字体
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
//    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIFont boldSystemFontOfSize:16],UITextAttributeFont,
//                                    nil];
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma -mark -返回上navi界面
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
