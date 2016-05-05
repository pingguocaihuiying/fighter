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

@end

FTDrawerViewController *drawerVC;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStylersFromArray:@[@[[DrawerScaleStyler styler], [DrawerFadeStyler styler],[DrawerParallaxStyler styler]]] forDirection:FTDynamicsDrawerDirectionLeft];
    
    drawerVC = [[FTDrawerViewController alloc]init];
    drawerVC.dynamicsDrawerViewController = self;
    [self setDrawerViewController:drawerVC forDirection:FTDynamicsDrawerDirectionLeft];
    [drawerVC setHomeViewController];
    
//    [self.view setBackgroundColor:[UIColor whiteColor]];
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
