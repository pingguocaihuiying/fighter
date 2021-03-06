//
//  MainViewController.m
//  fighter
//
//  Created by kang on 16/5/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "MainViewController.h"
#import "FTDrawerViewController.h"
#import "FTDrawerStyler.h"

@interface MainViewController ()

@property (nonatomic, copy) RankButtonBlock ranckButtonBlock;

@end

FTDrawerViewController *drawerVC;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addStylersFromArray:@[[DrawerScaleStyler styler], [DrawerFadeStyler styler],[DrawerParallaxStyler styler]] forDirection:FTDynamicsDrawerDirectionLeft];
    
    drawerVC = [[FTDrawerViewController alloc]init];
    drawerVC.dynamicsDrawerViewController = self;
    [self setDrawerViewController:drawerVC forDirection:FTDynamicsDrawerDirectionLeft];
    
    [drawerVC setHomeViewController];
    
    [drawerVC setNoti];

    __weak typeof(self) weakself = self;
    drawerVC.ranckButtonBlock = ^(UIButton *rankButton){
    
        [weakself updateRankButtonFrame:rankButton];
        
    };
    
}


- (void) pushMessage:(NSDictionary *)dic{

    [drawerVC push:dic[@"click_param"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
