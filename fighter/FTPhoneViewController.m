//
//  FTPhoneViewController.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPhoneViewController.h"
#import "FTInputNewPhoneViewController.h"
#import "FTInputCheckCodeViewController.h"
#import "NetWorking.h"
#import "MBProgressHUD.h"
#import "Regex.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTPhoneViewController ()

@end

@implementation FTPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}


- (void) viewWillAppear:(BOOL)animated {

    [self initSubviews];
}

- (void) initSubviews {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.speraterView setBackgroundColor:[UIColor colorWithHex:0x505050]];
    
    self.titleLabel.text = @"当前绑定手机：";
    [self.phoneLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (localUser.tel.length > 0) {
        [self.phoneLabel setText:localUser.tel];
    }else {
        [self.phoneLabel setText:@"未绑定"];
    }
}




- (IBAction)changePhoneNUmAction:(id)sender {
    
//    FTInputNewPhoneViewController *newPhoneVC = [[FTInputNewPhoneViewController alloc]init];
//    newPhoneVC.title = @"更改绑定手机";
//    [self.navigationController pushViewController:newPhoneVC animated:YES];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //1.首先验证是否已经绑定过手机
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (localUser.tel.length > 0) {//2.1 已经绑定过手机的用户：直接修改绑定手机
        
        NetWorking *net = [NetWorking new];
        [net getCheckCodeForExistPhone:localUser.tel
                                    type:@"2"
                                  option:^(NSDictionary *dict) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      NSLog(@"dict:%@",dict);
                                      if (dict != nil) {
                                          
                                          bool status = [dict[@"status"] boolValue];
                                          NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                          NSLog(@"message:%@",message);
                                          
                                          if (status == true) {
                                              
                                              [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                              
                                              FTInputCheckCodeViewController *oldCheckCodeVC = [[FTInputCheckCodeViewController alloc]init];
                                              oldCheckCodeVC.title = @"验证码";
                                              oldCheckCodeVC.type = @"2";
                                              oldCheckCodeVC.phoneNum = localUser.tel;
                                              [self.navigationController pushViewController:oldCheckCodeVC animated:YES];
                                              
                                          }else {
                                              NSLog(@"message : %@", [dict[@"message"] class]);
                                             
                                              [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                              
                                          }
                                      }else {
                                         
                                          [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                                          
                                      }
            
                                  }];
    }
    
        
    
    
    
}

- (void) backBtnAction:(id)sender {

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
