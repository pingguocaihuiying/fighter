//
//  BaseNavigationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseNavigationViewController.h"

@interface FTBaseNavigationViewController ()

@end

@implementation FTBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarHidden = YES;
    self.navigationBar.barTintColor = [UIColor blackColor];
    
    //  导航栏半透明属性设置为NO,阻止导航栏遮挡view
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
