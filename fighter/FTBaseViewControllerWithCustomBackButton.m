//
//  FTBaseViewControllerWithCustomBackButton.m
//  fighter
//
//  Created by 李懿哲 on 20/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewControllerWithCustomBackButton.h"

@interface FTBaseViewControllerWithCustomBackButton ()

@end

@implementation FTBaseViewControllerWithCustomBackButton

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackButton];//（默认的）自定义返回按钮
}

- (void)customBackButton{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];//把左边的返回按钮左移
    self.navigationItem.leftBarButtonItem = leftButton;
}


/**
 左上角的返回按钮被点击
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];// navi 返回上一级
}

@end
