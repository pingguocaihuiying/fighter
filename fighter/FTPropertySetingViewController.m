//
//  FTPropertySetingViewController.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPropertySetingViewController.h"
#import "NetWorking.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTPropertySetingViewController () <UITextFieldDelegate>

@end

@implementation FTPropertySetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self initSubviews];
}

- (void) initSubviews {
    
    [self.navigationItem setHidesBackButton:YES];
    //左上角按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.bounds = CGRectMake(0, 0, 22, 22);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //右上角按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.bounds = CGRectMake(0, 0, 40, 35);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self.propertyTextField setTextColor:[UIColor colorWithHex:0xb4b4b4]];
    [self.propertyTextField setBackgroundColor:[UIColor clearColor]];
    [self.propertyTextField setDelegate:self];
}


- (void) leftBtnAction:(id) sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUser" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBtnAction:(id) sender {
    [self.propertyTextField resignFirstResponder];
    
    NSRange _range = [self.propertyTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [self showHUDWithMessage:@"昵称不能包含空格"];
        return;
    }

    if (self.propertyTextField.text.length == 0) {
        [self showHUDWithMessage:@"用户名不能为空"];
        return;
    }
    
    NSString *propertValue = [self.propertyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSStringEncoding enc =     CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    [propertValue stringByAddingPercentEscapesUsingEncoding:enc];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorking *net = [NetWorking new];
    [net updateUserByGet:propertValue Key:@"username" option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            bool status = [dict[@"status"] boolValue];
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            if (status == true) {
                
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                //从本地读取存储的用户信息
                NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                localUser.username = self.propertyTextField.text;
                
                //将用户信息保存在本地
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //返回操作
                [self leftBtnAction:nil];
                
                
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow  showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {
            [[UIApplication sharedApplication].keyWindow  showHUDWithMessage:@" 用户名修改成功，请稍后再试"];
            
        }
    }];

    

}

#pragma mark - private methods
- (void)showHUDWithMessage:(NSString *)message{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.label.text = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [HUD removeFromSuperview];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
