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
#import "MBProgressHUD.h"
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

    //导航栏右侧按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [registBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(turnRegistVCAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registBtn];
    
    [self.seperaterView1 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];
    [self.seperaterView2 setBackgroundColor:[UIColor colorWithHex:0x505050 ]];
    
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
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginResponse:) name:WXLoginResultNoti object:nil];
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

- (void) turnRegistVCAction:(id) sender {
    
    NSLog(@"regsit btn action begin ");
    
//    @try {
//        
//        FTRegistViewController *registVC = [[FTRegistViewController alloc]init];
//        registVC.title = @"注册";
//        FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:registVC];
//        baseNav.navigationBarHidden = NO;
//        baseNav.navigationBar.barTintColor = [UIColor blackColor];
//        [self.navigationController  presentViewController:baseNav animated:YES completion:nil];
////        [self.navigationController pushViewController:registVC animated:YES];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"exception:%@",exception);
//    }
//    @finally {
//        
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  0.1* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72}
//                                                                      length:9]
//                                              encoding:NSASCIIStringEncoding];
//        id object = [UIApplication sharedApplication];
//        UIView *statusBar;
//        if ([object respondsToSelector:NSSelectorFromString(key)]) {
//            statusBar = [object valueForKey:key];
//        }
//        statusBar.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH *0.7 , 0);
//    });
//    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"regist btn action end");
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
        [self showHUDWithMessage:@"用户名 密码必须全部填写"];
        return;
    }
    
//    Regex *regex = [Regex new];
//    BOOL isPhoneNum = [regex isMobileNumber:username];
//    if(!isPhoneNum){
//        [self showHUDWithMessage:@"请输入正确的手机号"];
//        return;
//    }
    
    
    NetWorking *net = [NetWorking new];
    [net loginWithPhoneNumber:self.acountTextField.text
                     password:self.passwordTextField.text
                       option:^(NSDictionary *dict) {
                                
                                NSLog(@"dict:%@",dict);
                                if (dict != nil) {
                                    
                                    bool status = [dict[@"status"] boolValue];
                                    NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                                    
                                    if (status == true) {
                                        
                                        [self showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        NSDictionary *userDataDic = dict[@"data"];
                                        NSDictionary *userDic = userDataDic[@"userLogin"];
                                        
                                        FTUserBean *user = [FTUserBean new];
                                        [user setValuesForKeysWithDictionary:userDic];
                                        
                                        //将用户信息保存在本地
                                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                                        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72}
                                                                                                          length:9]
                                                                                  encoding:NSASCIIStringEncoding];
                                            id object = [UIApplication sharedApplication];
                                            UIView *statusBar;
                                            if ([object respondsToSelector:NSSelectorFromString(key)]) {
                                                statusBar = [object valueForKey:key];
                                            }
                                            statusBar.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH *0.7 , 0);
                                        });
                                        
                                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                            
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAction" object:self];
                                        
                                        }];
                                        
                                    }else {
                                        NSLog(@"message : %@", [dict[@"message"] class]);
                                        [self showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                    }
                                }else {
                                    [self showHUDWithMessage:@" 登录失败，请稍后再试"];
                                    
                                }
                                
                            }];

}
//微信快捷登录

- (void)wxLoginResponse:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        [self showHUDWithMessage:@"微信登录成功，可以评论或点赞了"];
        
//        //从本地读取存储的用户信息
//        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//        if (localUser) {
//            [self setLoginedViewData:localUser];
//        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if ([msg isEqualToString:@"ERROR"]){
        [self showHUDWithMessage:@"微信登录失败"];
    }
}

- (IBAction)weichatBtnAction:(id)sender {
    
    if ([WXApi isWXAppInstalled] ) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"fighter";
        [WXApi sendReq:req];
        
    }else{
        NSLog(@"目前只支持微信登录，请安装微信");
        [self showHUDWithMessage:@"未安装微信！"];
    }

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

@end
