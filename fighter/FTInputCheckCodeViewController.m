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
#import "FTNewPasswordVC.h"
#import "FTInputNewPhoneViewController.h"

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
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self.speraterView setBackgroundColor:Cell_Space_Color];
    
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
//    //从本地读取存储的用户信息
//    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if ([self.type isEqualToString:@"2"]) {//2.1 已经绑定过手机的用户,先验证旧手机
        
        [NetWorking checkCodeForExistPhone:self.phoneNum
                          checkCode:self.checkCodeTextField.text
                                  option:^(NSDictionary *dict) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                NSLog(@"dict:%@",dict);
                                if (dict != nil) {
                                    
                                    bool status = [dict[@"status"] boolValue];
                                    NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                    NSLog(@"message:%@",message);
                                    
                                    if (status == true) {
                                        
                                        
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        //跳转到输入新手机界面
                                        FTInputNewPhoneViewController *newPhoneVC = [[FTInputNewPhoneViewController alloc]init];
                                        newPhoneVC.title = @"新手机";
                                        newPhoneVC.type = @"changephone";
                                        [self.navigationController pushViewController:newPhoneVC animated:YES];
                                        
                                    }else {
                                        NSLog(@"message : %@", [dict[@"message"] class]);
                                        
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                    }
                                }else {
                                    
                                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                                    
                                }
        }];

    }if ([self.type isEqualToString:@"changephone"]) {//2.2 已经绑定过手机的用户：验证完旧手机，直接修改绑定手机
        
        [NetWorking changgeBindingPhone:self.phoneNum
                       checkCode:self.checkCodeTextField.text
                          option:^(NSDictionary *dict) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                NSLog(@"dict:%@",dict);
                                if (dict != nil) {
                                    
                                    bool status = [dict[@"status"] boolValue];
                                    NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                    NSLog(@"message:%@",message);
                                    
                                    if (status == true) {
                                        
                                      
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        
                                        //更新本地数据
                                        FTUserBean *user = [FTUserBean new];
                                        [user setValuesForKeysWithDictionary:dict[@"user"]];
                                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                                        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        
                                        //跳转回账户管理界面
                                        NSArray *array = [NSArray arrayWithArray:self.navigationController.viewControllers];
                                        
                                        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                                    }else {
                                        NSLog(@"message : %@", [dict[@"message"] class]);
                                       
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                    }
                                }else {
                                   
                                    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                                    
                                }
        }];
        
    }else if ([self.type isEqualToString:@"bindphone"]){//2.3 未绑定手机用户，绑定手机后修改密码
        
        [NetWorking bindingPhoneNumber:self.phoneNum
                      checkCode:self.checkCodeTextField.text
                         option:^(NSDictionary *dict) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"dict:%@",dict);
                    if (dict != nil) {
                        
                        bool status = [dict[@"status"] boolValue];
                        NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSLog(@"message:%@",message);
                        
                        if (status == true) {
                            
                            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"绑定手机成功"];
                            
                            //从本地读取存储的用户信息
                            FTUserBean *localUser = [FTUserBean loginUser];
                            localUser.tel = self.phoneNum;
                            
//                            //解析返回json
//                            NSDictionary *userDataDic = dict[@"data"];
//                            NSDictionary *userDic = userDataDic[@"user"];
//                            FTUserBean *user = [FTUserBean new];
//                            [user setValuesForKeysWithDictionary:userDic];
                            
                            //更新本地数据
                            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            
                            // 3. 绑定手机后跳转到设置密码接口
                            FTNewPasswordVC *newPasswordVC = [[FTNewPasswordVC alloc]init];
                            newPasswordVC.title = @"设置密码";
                            newPasswordVC.oldPassword = @"-1";
                            [self.navigationController pushViewController:newPasswordVC animated:YES];
                            
                        }else {
                            NSLog(@"message : %@", [dict[@"message"] class]);
                            
                            
                            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            
                        }
                    }else {
                       
                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                        
                    }
        }];

        
    }
    
    

//    [NetWorking bindingPhoneNumber:self.phoneNum checkCode:self.checkCodeTextField.text option:^(NSDictionary *dict) {
//        NSLog(@"dict:%@",dict);
//        if (dict != nil) {
//            
//            bool status = [dict[@"status"] boolValue];
//            NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"message:%@",message);
//            
//            if (status == true) {
//                
//                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                
////                [self.navigationController popToRootViewControllerAnimated:YES];
//            }else {
//                NSLog(@"message : %@", [dict[@"message"] class]);
//                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                
//            }
//        }else {
//            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
//            
//        }
//    }];
    
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
