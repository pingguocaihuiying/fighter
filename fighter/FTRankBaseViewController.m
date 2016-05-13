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
    //删除继承自FTBaseViewcontroller中添加的这招图片（危险方法，不建议使用）
    [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
    
    
    //设置左侧按钮,在根上设置，以后继承（第一次尝试这么做）
    
    
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
