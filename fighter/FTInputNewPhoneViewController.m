//
//  FTInputNewPhoneViewController.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTInputNewPhoneViewController.h"
#import "MBProgressHUD.h"
#import "NetWorking.h"
#import "FTInputCheckCodeViewController.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTInputNewPhoneViewController ()

@end

@implementation FTInputNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    self.titleLabel.text = @"输入新的手机号：";
    self.remarkLabel.text = @"下次可直接用新的手机号登录";
    [self.remarkLabel setTextColor:[UIColor colorWithHex:0x828287]];
     
    self.phoneTextfield.textColor = [UIColor whiteColor];
    self.phoneTextfield.placeholder = @"11位手机号码";
    [self.phoneTextfield setValue:[UIColor colorWithHex:0x828287] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTextfield setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

    [self.phoneTextfield setKeyboardType:UIKeyboardTypePhonePad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)nextBtnAction:(id)sender {
    [self.phoneTextfield resignFirstResponder];
    
    NSRange _range = [self.phoneTextfield.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [self showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (self.phoneTextfield.text.length == 0 ) {
        [self showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(self.phoneTextfield.text.length  != 11){
            [self showHUDWithMessage:@"手机号长度不正确"];
            return;
        }
    }
    
    if ([self.type isEqualToString:@"3"]) {//更改手机
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NetWorking *net = [NetWorking new];
        [net getCheckCodeForNewPhone:self.phoneTextfield.text
                                option:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"dict:%@",dict);
            if (dict != nil) {
                
                bool status = [dict[@"status"] boolValue];
                NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"message:%@",message);
                
                if (status == true) {
                    
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    FTInputCheckCodeViewController *checkCodeVC = [[FTInputCheckCodeViewController alloc]init];
                    checkCodeVC.title = @"验证码";
                    checkCodeVC.type = self.type;
                    checkCodeVC.phoneNum = self.phoneTextfield.text;
                    [self.navigationController pushViewController:checkCodeVC animated:YES];
                    
                }else {
                    NSLog(@"message : %@", [dict[@"message"] class]);
                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    //                [self showHUDWithMessage:@"验证码发送失败，稍后再试"];
                }
            }else {
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码发送失败，稍后再试"];
                
            }
            
        }];

        
    }else if ([self.type isEqualToString:@"bindphone"]){//绑定手机
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NetWorking *net = [NetWorking new];
        [net getCheckCodeForNewBindingPhone:self.phoneTextfield.text
                                     option:^(NSDictionary *dict) {
                                         
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"dict:%@",dict);
                    if (dict != nil) {
                        
                        bool status = [dict[@"status"] boolValue];
                        NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSLog(@"message:%@",message);
                        
                       
                        if (status == true) {
                            
                            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            
                            FTInputCheckCodeViewController *checkCodeVC = [[FTInputCheckCodeViewController alloc]init];
                            checkCodeVC.title = @"验证码";
                            checkCodeVC.type = self.type;
                            checkCodeVC.phoneNum = self.phoneTextfield.text;
                            [self.navigationController pushViewController:checkCodeVC animated:YES];
                            
                        }else {
                            NSLog(@"message : %@", [dict[@"message"] class]);
                            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            //                [self showHUDWithMessage:@"验证码发送失败，稍后再试"];
                        }
                    }else {
                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码发送失败，稍后再试"];
                        
                    }
            
        }];
    }
    
    
//    FTInputCheckCodeViewController *checkCodeVC = [[FTInputCheckCodeViewController alloc]init];
//    checkCodeVC.title = @"验证码";
//    checkCodeVC.phoneNum = self.phoneTextfield.text;
//    [self.navigationController pushViewController:checkCodeVC animated:YES];

}

- (void) backBtnAction: (id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
