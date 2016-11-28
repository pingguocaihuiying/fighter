//
//  FTLoginViewController.m
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLoginViewController.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FTRegistViewController.h"
#import "FTBaseNavigationViewController.h"
#import "NetWorking.h"
#import "UIWindow+MBProgressHUD.h"
#import "Regex.h"


@interface FTLoginViewController ()

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self setSubViews];
}

- (void) setSubViews {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //导航栏右侧按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [registBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(turnRegistVCAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registBtn];
    
    [self.seperaterView1 setBackgroundColor:Cell_Space_Color];
    [self.seperaterView2 setBackgroundColor:Cell_Space_Color];
    
    [self.acountTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    
    
    // 描述占位文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    //富文本属性
    NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:attr];
    [self.acountTextField setAttributedPlaceholder:acountPlaceholder];
    [self.acountTextField setTextColor:[UIColor whiteColor]];
    [self.acountTextField setKeyboardType:UIKeyboardTypePhonePad];
    
    NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
    attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attr2];
    [self.passwordTextField setAttributedPlaceholder:passwordPlaceholder];
    [self.passwordTextField setTextColor:[UIColor whiteColor]];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
    [self.passwordTextField setSecureTextEntry:YES];
    
    
    if (![WXApi isWXAppInstalled] ) {
        [self.weichatLoginBtn setHidden:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
//    {
//        [self prefersStatusBarHidden];
//        [self setNeedsStatusBarAppearanceUpdate];
//    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - response
- (void) backBtnAction:(id) sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) turnRegistVCAction:(id) sender {
    
   
    FTRegistViewController *registVC = [[FTRegistViewController alloc]init];
    registVC.title = @"注册";
//    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:registVC];
//    baseNav.navigationBarHidden = NO;
//    baseNav.navigationBar.barTintColor = [UIColor blackColor];
//    [self  presentViewController:baseNav animated:YES completion:nil];
    
    [self.navigationController pushViewController:registVC animated:YES];

}


//登录
- (IBAction)loginBtnAction:(id)sender {
    
    [self.passwordTextField resignFirstResponder];
    [self.acountTextField resignFirstResponder];

    NSString *username = self.acountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([password isEqualToString:@""] || [username isEqualToString:@""]) {
        NSLog(@"用户名 密码必须全部填写");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"用户名 密码必须全部填写"];
        return;
    }
    
//    Regex *regex = [Regex new];
//    BOOL isPhoneNum = [regex isMobileNumber:username];
//    if(!isPhoneNum){
//        [self showHUDWithMessage:@"请输入正确的手机号"];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [NetWorking loginWithPhoneNumber:self.acountTextField.text
                     password:self.passwordTextField.text
                       option:^(NSDictionary *dict) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                SLog(@"dict:%@",dict);
                                if (dict != nil) {
                                    
                                    bool status = [dict[@"status"] boolValue];
                                    NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                                    
                                    if (status == true) {
                                        
                                        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        NSDictionary *userDataDic = dict[@"data"];
                                        NSDictionary *userDic = userDataDic[@"user"];
                                        
                                        FTUserBean *user = [FTUserBean new];
                                        [user setValuesForKeysWithDictionary:userDic];
                                        
                                        if ([dict[@"data"][@"corporationid"] integerValue] > 0) {
                                            user.corporationid = [NSString stringWithFormat:@"%ld",[dict[@"data"][@"corporationid"] integerValue]];
                                        }
                                        
                                        user.identity = dict[@"data"][@"identity"];
                                        user.interestList = dict[@"data"][@"interestList"];
                                        user.isGymUser = dict[@"data"][@"isGymUser"];
                                        
                                        NSString *corporationid = dict[@"data"][@"corporationid"];
                                        NSLog(@"corporationid:%@",corporationid);
                                        
                                        //将用户信息保存在本地
                                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                                        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        
                                        
                                        
                                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                            
                                            [FTNotificationTools postLoginNoti:FTLoginTypePhone];
                                            
                                        
                                        }];
                                        
                                    }else {
                                        NSLog(@"message : %@", [dict[@"message"] class]);
                                        [[UIApplication sharedApplication].keyWindow showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                    }
                                }else {
                                    [[UIApplication sharedApplication].keyWindow showMessage:@"网络错误"];
                                    
                                }
                                
                            }];

}

- (IBAction)weichatBtnAction:(id)sender {
    
    //请求微信登录
    [NetWorking weixinRequest];

}

// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        
        [[UIApplication sharedApplication].keyWindow showMessage:@"登录成功"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [[UIApplication sharedApplication].keyWindow showMessage:@"登录失败"];
    }
}


#pragma mark - private methods

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

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.acountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
