//
//  FTWeixinInfoVC.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTWeixinInfoVC.h"

@interface FTWeixinInfoVC ()

@end

@implementation FTWeixinInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void) viewWillAppear:(BOOL)animated {

 [self initSubviews];
    
}

- (void) initSubviews {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//    self.headerUrl = localUser.wxHeaderPic;
//    self.username = localUser.wxName;
    if (localUser.wxHeaderPic.length > 0) {
        self.headerUrl = localUser.wxHeaderPic;
    }else {
    
        self.headerUrl = localUser.headpic;
    }
    
    if (localUser.wxName.length > 0) {
        self.username = localUser.wxName;
    }else {
        self.username = localUser.username;
    }
    
    [self.wXHeaderImageView.layer setMasksToBounds:YES];
    self.wXHeaderImageView.layer.cornerRadius = 40;
    [self.wXHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.headerUrl]];
    self.wXNameLabel.text = self.username;
    
}



- (void) backBtnAction :(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
