//
//  FTRankViewController.m
//  fighter
//
//  Created by kang on 16/5/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankViewController.h"
#import "FTButton.h"

@interface FTRankViewController ()

@end

@implementation FTRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.view addSubview:headerView];
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    for (int i = 0; i < 3; i++) {
        
        FTButton *button = [FTButton buttonWithType:UIButtonTypeCustom];
        button.imageH = 10;
        button.imageW = 13;
        button.buttonModel = FTButtonModelRightImage;
        button.space = 10;
        
//        [button ]
        button.frame = CGRectMake((buttonW+12)*12, 0, buttonW, 40);
    }
    
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
