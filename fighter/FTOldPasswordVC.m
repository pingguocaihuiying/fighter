//
//  FTOldPasswordVC.m
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTOldPasswordVC.h"
#import "FTNewPasswordVC.h"
#import "NetWorking.h"
#import "MBProgressHUD.h"
#import "Regex.h"
#import "UIWindow+MBProgressHUD.h"


@interface FTOldPasswordVC ()

@end

@implementation FTOldPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubviews ];
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
    
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"输入旧密码" attributes:attr];
    [self.passwordTextField setAttributedPlaceholder:acountPlaceholder];
    [self.passwordTextField setTextColor:[UIColor whiteColor]];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField setSecureTextEntry:YES];
    
    [self.passwordTextField setValue:[UIColor colorWithHex:0x828287] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

    
    [self.seperaterView2 setHidden:YES];
    [self.passwordTextField2 setHidden:YES];
    [self.titleLabel2 setHidden:YES];
}



#pragma mark - response
- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sumitBtnAction:(id)sender {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    [self.passwordTextField resignFirstResponder];
    
    NSString *tel = localUser.tel;
    NSString *password = self.passwordTextField.text;
    
    if (password.length < 6 || password.length > 18) {
        NSLog(@"密码必须填写");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"密码必须为6-18位"];
        return;
    }
    
    if ([tel isEqualToString:@""]) {
        NSLog(@"密码必须填写");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"未绑定手机"];
        return;
    }
    
    
    
    NetWorking *net = [NetWorking new];
    [net loginWithPhoneNumber:tel
                     password:self.passwordTextField.text
                       option:^(NSDictionary *dict) {
                           
                           NSLog(@"dict:%@",dict);
                           if (dict != nil) {
                               
                               bool status = [dict[@"status"] boolValue];
                               NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                               
                               if (status == true) {
                                   
//                                   [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   
                                   NSDictionary *userDataDic = dict[@"data"];
                                   NSDictionary *userDic = userDataDic[@"user"];
                                   
                                   FTUserBean *user = [FTUserBean new];
                                   [user setValuesForKeysWithDictionary:userDic];
                                   
//                                   //将用户信息保存在本地
//                                   NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
//                                   [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
//                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   
                                   [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"旧密码验证成功"];
                                   
                                   FTNewPasswordVC *newPasswordVC = [[FTNewPasswordVC alloc]init];
                                   newPasswordVC.title = @"新密码";
                                   newPasswordVC.oldPassword = self.passwordTextField.text;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
