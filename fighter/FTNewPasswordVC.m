//
//  FTNewPasswordVC.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTNewPasswordVC.h"
#import "NetWorking.h"
#import "MBProgressHUD.h"
#import "Regex.h"
#import "UIWindow+MBProgressHUD.h"
#import "FTLoginViewController.h"

@interface FTNewPasswordVC ()

@end

@implementation FTNewPasswordVC

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
    
    [self.seperaterView1 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];
    [self.seperaterView2 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];

    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField2 setBackgroundColor:[UIColor clearColor]];

    
    [self.passwordTextField setAttributedPlaceholder:[self placeholderAttribute:@"请输入密码"]];
    [self.passwordTextField setTextColor:[UIColor whiteColor]];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField setSecureTextEntry:YES];


    
    [self.passwordTextField2 setAttributedPlaceholder:[self placeholderAttribute:@"请重新输入密码"]];
    [self.passwordTextField2 setTextColor:[UIColor whiteColor]];
    [self.passwordTextField2 setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField2 setSecureTextEntry:YES];

}


- (NSAttributedString *) placeholderAttribute:(NSString *) placeholderString {

    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:placeholderString attributes:attr];
    
    return placeholder;
}

#pragma mark - response
- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sumitBtnAction:(id)sender {
    
    [self.passwordTextField resignFirstResponder];
    [self.passwordTextField2 resignFirstResponder];
    
    NSRange _range = [self.passwordTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"密码不能包含空格"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString: self.passwordTextField2.text]) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    if (self.passwordTextField.text.length <6 || self.passwordTextField.text.length >18) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"密码必须为6-18位"];
        return;
    }
    
    if (![Regex checkPasswordForm:self.passwordTextField.text]) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"密码必须为数字字母下划线"];
        return;
    }
    
    NetWorking *net = [NetWorking new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [net updatePassword:self.oldPassword
            newPassword:self.passwordTextField.text
                 option:^(NSDictionary *dict) {
    
                     
                     
                           NSLog(@"dict:%@",dict);
                           if (dict != nil) {
                               
                               bool status = [dict[@"status"] boolValue];
                               NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                               
                               if (status == true) {
                                   
                                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                                   FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                                
                                   [net loginWithPhoneNumber:localUser.tel
                                                    password:self.passwordTextField.text
                                                      option:^(NSDictionary *loginDict) {
                                                          
                                                          NSDictionary *lginDataDic = loginDict[@"data"];
                                                          NSDictionary *userDic = lginDataDic[@"user"];
                                                          
                                                          FTUserBean *user = [FTUserBean new];
                                                          [user setValuesForKeysWithDictionary:userDic];
                                                          
                                                          //将用户信息保存在本地
                                                          NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                                                          [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                                      }];
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                               }else {
                                   NSLog(@"message : %@", [dict[@"message"] class]);
                                   [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }
                           }else {
                               [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                           
                       }];
    
    
}


@end