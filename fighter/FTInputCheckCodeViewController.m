//
//  FTInputCheckCodeViewController.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTInputCheckCodeViewController.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"
#import "NetWorking.h"

@interface FTInputCheckCodeViewController ()

@end

@implementation FTInputCheckCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubviews];
}

- (void) initSubviews {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.speraterView setBackgroundColor:[UIColor colorWithHex:0x505050]];
    
    self.titleLabel.text = @"输入短信验证码：";
    self.remarkLabel.text = @"下次可直接用新的手机号登录";
    [self.remarkLabel setTextColor:[UIColor colorWithHex:0x828287]];
    [self.remarkLabel setHidden:YES];
    
    self.checkCodeTextField.textColor = [UIColor whiteColor];
    self.checkCodeTextField.placeholder = @"六位验证码";
    [self.checkCodeTextField setValue:[UIColor colorWithHex:0x828287] forKeyPath:@"_placeholderLabel.textColor"];
    [self.checkCodeTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    //    self.phoneTextfield.delegate = self;
    [self.checkCodeTextField setKeyboardType:UIKeyboardTypePhonePad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction) confirmBtnAction:(id)sender {
    [self.checkCodeTextField resignFirstResponder];
    
    NSRange _range = [self.checkCodeTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不能包含空格"];
        return;
    }
    
    if (self.checkCodeTextField.text.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不能为空"];
        return ;
    }else {
        if(self.checkCodeTextField.text.length  != 6){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码长度不正确"];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //1.首先验证是否已经绑定过手机
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (localUser.tel.length > 0) {//已经绑定过手机的用户：直接修改绑定手机
        
        NetWorking *net = [NetWorking new];
        [net bindingPhoneNumber:self.phoneNum checkCode:self.checkCodeTextField.text option:^(NSDictionary *dict) {
            NSLog(@"dict:%@",dict);
            if (dict != nil) {
                
                bool status = [dict[@"status"] boolValue];
                NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"message:%@",message);
                
                if (status == true) {
                    
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    NSArray *array = [NSArray arrayWithArray:self.navigationController.viewControllers];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                }else {
                    NSLog(@"message : %@", [dict[@"message"] class]);
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                }
            }else {
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                
            }
        }];

    }else {//未绑定手机用户，绑定手机后修改密码
        
        NetWorking *net = [NetWorking new];
        [net bindingPhoneNumber:self.phoneNum checkCode:self.checkCodeTextField.text option:^(NSDictionary *dict) {
            NSLog(@"dict:%@",dict);
            if (dict != nil) {
                
                bool status = [dict[@"status"] boolValue];
                NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"message:%@",message);
                
                if (status == true) {
                    
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    
                }else {
                    NSLog(@"message : %@", [dict[@"message"] class]);
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                }
            }else {
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                
            }
        }];

        
    }
    
    
    NetWorking *net = [NetWorking new];
    [net bindingPhoneNumber:self.phoneNum checkCode:self.checkCodeTextField.text option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            bool status = [dict[@"status"] boolValue];
            NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"message:%@",message);
            
            if (status == true) {
                
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
            
        }
    }];
    
// [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) backBtnAction: (id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)showHUDWithMessage:(NSString *)message{
//    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.label.text = message;
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
//    [HUD showAnimated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [HUD removeFromSuperview];
//    });
//}
@end
