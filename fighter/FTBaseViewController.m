//
//  BaseViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTBaseViewController ()

@end

@implementation FTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修正selv
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置渐变
//        NSLog(@"base view的宽度：%f,高度：%f",self.view.frame.size.width, self.view.frame.size.height);
//    NSLog(@"self view frame height : %f", self.view.frame.size.height);
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 52, SCREEN_WIDTH, 52)];
    _bottomGradualChangeView = [[UIImageView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 52 - 49, SCREEN_WIDTH, 52)];
    _bottomGradualChangeView.bounds = CGRectMake(0,SCREEN_HEIGHT - 52, SCREEN_WIDTH, 52);
    _bottomGradualChangeView.image = [UIImage imageNamed:@"评赞底部按钮-渐变遮罩"];
    [self.view addSubview:_bottomGradualChangeView];
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
