//
//  FTSetPassWordViewController.m
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSetPassWordViewController.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "Regex.h"

@interface UIWindow (MBProgressHUD)
- (void)showHUDWithMessage:(NSString *)message;
@end
@implementation UIWindow (MBProgressHUD)
- (void)showHUDWithMessage:(NSString *)message{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    HUD.label.text = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [HUD removeFromSuperview];
    });
}
@end

@interface FTSetPassWordViewController ()

@end

@implementation FTSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self setSubViews];
}

- (void) setSubViews {
    
    //导航栏右侧按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [backBtn setBounds:CGRectMake(0, 0, 70, 14)];
    [backBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.seperaterView1 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];
    [self.seperaterView2 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];
    
    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField2 setBackgroundColor:[UIColor clearColor]];
    
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attr];
    [self.passwordTextField setAttributedPlaceholder:acountPlaceholder];
    [self.passwordTextField setTextColor:[UIColor whiteColor]];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField setSecureTextEntry:YES];
    
    
    NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
    attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请重新输入密码" attributes:attr2];
    [self.passwordTextField2 setAttributedPlaceholder:passwordPlaceholder];
    [self.passwordTextField2 setTextColor:[UIColor whiteColor]];
    [self.passwordTextField2 setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField2 setSecureTextEntry:YES];
}


- (IBAction)submitNewPasswordAction:(id)sender {
    
    [self.passwordTextField resignFirstResponder];
    [self.passwordTextField2 resignFirstResponder];
    

    NSRange _range = [self.passwordTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [self showHUDWithMessage:@"密码不能包含空格"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString: self.passwordTextField2.text]) {
        [self showHUDWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    if (self.passwordTextField.text.length <6 || self.passwordTextField.text.length >18) {
        [self showHUDWithMessage:@"密码必须为6-18位"];
        return;
    }
    
    if (![Regex checkPasswordForm:self.passwordTextField.text]) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"密码必须为数字字母下划线"];
        return;
    }

    if (self.userId == nil) {
        NSLog(@"userid 为 nill,将return");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorking *net = [NetWorking new];
    [net registUserWithPhoneNumber:self.userId
                          password:self.passwordTextField.text
                         checkCode:self.checkCode
                            option:^(NSDictionary *dict) {
                                
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                NSLog(@"dict:%@",dict);
                                if (dict != nil) {
                                    
                                    bool status = [dict[@"status"] boolValue];
                                    NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                    NSLog(@"message:%@",message);
                                    
                                    if (status == true) {
                                        
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message];
                                        
                                        NSDictionary *userDataDic = dict[@"data"];
                                        NSDictionary *userDic = userDataDic[@"userLogin"];

                                        FTUserBean *user = [FTUserBean new];
                                        [user setValuesForKeysWithDictionary:userDic];
                                        
                                        //将用户信息保存在本地
                                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                                        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userLogin"];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
//                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }else {
                                        
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                    }
                                }else {
                                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"修改失败，稍后再试"];
                                    
                                }

                            }];
}

- (void) backAction:(id) sender {
    
    NSLog(@"back action did");
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
