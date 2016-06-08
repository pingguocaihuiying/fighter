//
//  FTRegistViewController.m
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRegistViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTSetPassWordViewController.h"
#import "NetWorking.h"
#import "MBProgressHUD.h"
#import "Regex.h"
#import "MD5.h"
#import "MainViewController.h"
#import "UIWindow+MBProgressHUD.h"


@interface FTRegistViewController () <UITextFieldDelegate>
{
    NSTimer *_timer;
    NSInteger _t;
}

@property (nonatomic, copy)NSString *userId;
@end

@implementation FTRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self setSubViews];
}

- (void) viewWillAppear:(BOOL)animated {

    [self.navigationItem setHidesBackButton:YES];
}

- (void) setSubViews {
    
    @try {
        //导航栏右侧按钮
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"已有账号" forState:UIControlStateNormal];
        [loginBtn setBounds:CGRectMake(0, 0, 80, 14)];
        [loginBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(turnLoginVCAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:loginBtn];
        
        [self.seperaterView1 setBackgroundColor:Cell_Space_Color];
        [self.seperaterView2 setBackgroundColor:Cell_Space_Color];
        
        [self.acountTextField setBackgroundColor:[UIColor clearColor]];
        [self.checkCodeTextField setBackgroundColor:[UIColor clearColor]];
        // 描述占位文字属性
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
        //富文本属性
        NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:attr];
        [self.acountTextField setAttributedPlaceholder:acountPlaceholder];
        [self.acountTextField setTextColor:[UIColor whiteColor]];
        [self.acountTextField setKeyboardType:UIKeyboardTypePhonePad];
        self.acountTextField.delegate = self;
        
        
        NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
        attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
        NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attr2];
        [self.checkCodeTextField setAttributedPlaceholder:passwordPlaceholder];
        [self.checkCodeTextField setTextColor:[UIColor whiteColor]];
        [self.checkCodeTextField setKeyboardType:UIKeyboardTypePhonePad];
        [self.checkCodeTextField setSecureTextEntry:NO];
        self.checkCodeTextField.delegate = self;
        
        [self.sendCheckCodeBtn setTitleColor:Main_Text_Color forState:UIControlStateDisabled];
        [self.confirmBtn setTitleColor:Main_Text_Color forState:UIControlStateDisabled];
        [self.confirmBtn setEnabled:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
}

- (IBAction)sentCheckCodeAction:(id)sender {
    
    [self.acountTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    
    NSRange _range = [self.acountTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (self.acountTextField.text.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(self.acountTextField.text.length  != 11){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号长度不正确"];
            return;
        }
    }
    
    
//    if ( ![[Regex new] isMobileNumber:self.acountTextField.text]) {
//        [self showHUDWithMessage:@"手机号不正确"];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorking *net = [NetWorking new];
    [net getCheckCodeWithPhoneNumber:self.acountTextField.text
                              option:^(NSDictionary *dict) {
                                  
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            bool status = [dict[@"status"] boolValue];
            NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"message:%@",message);
            
            if (status == true) {
                
                [self.sendCheckCodeBtn setEnabled:NO];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSendCheckCodeButton:) userInfo:nil repeats:YES];
                _t = 60;
                [self setSendCheckCodeBtnText:_t];
                
                
                self.userId = dict[@"data"];
                NSLog(@"self.userId :%@",self.userId );
                
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                [self showHUDWithMessage:@"验证码发送失败，稍后再试"];
            }
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
            
        }

    }];
    
}

- (IBAction)submitCheckCodeAction:(id)sender {
    
    [self.acountTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
    
    NSRange _range = [self.acountTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (self.acountTextField.text.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(self.acountTextField.text.length  != 11){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号长度不正确"];
            return;
        }
    }

    
    if ([self.checkCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不能为空"];
        return ;
    }else {
        if(self.checkCodeTextField.text.length  != 6){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不正确"];
            return;
        }
    }
    
    FTSetPassWordViewController *setPasswordVC = [[FTSetPassWordViewController alloc]init];
    setPasswordVC.userId = self.userId;
    setPasswordVC.checkCode = self.checkCodeTextField.text;
    setPasswordVC.title = @"设置密码";
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}

- (void) turnLoginVCAction:(id) sender {
    
//    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
//    loginVC.title = @"登录";
//    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
//    baseNav.navigationBarHidden = NO;
//    baseNav.navigationBar.barTintColor = [UIColor blackColor];
//    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
//    [self.navigationController pushViewController:loginVC animated:YES];
//    [self.navigationController presentViewController:[[UIApplication sharedApplication].keyWindow rootViewController] animated:YES completion:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
//    [[UIApplication sharedApplication].keyWindow setRootViewController:[MainViewController new]];
    
}


- (void) updateSendCheckCodeButton:(id) time {
    _t--;
    if (_t > 0) {
        [self setSendCheckCodeBtnText:_t];
    }else {
    
        [self.sendCheckCodeBtn setEnabled:YES];

    }
    
}

- (void) setSendCheckCodeBtnText:(NSInteger)t {

    [self.sendCheckCodeBtn setTitle:[NSString stringWithFormat:@"重新发送%ld",t] forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_timer invalidate];
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

#pragma mark -delegate 

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int MAX_CHARS;
    
    if (textField == self.checkCodeTextField) {
        MAX_CHARS = 6;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        [newtxt replaceCharactersInRange:range withString:string];
        
        if ([newtxt length] == 6) {
            [self.confirmBtn setEnabled:YES];
        }
        return ([newtxt length] <= MAX_CHARS);
        
    }else if(textField == self.acountTextField) {
    
        MAX_CHARS = 11;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        return ([newtxt length] <= MAX_CHARS);
    }
   
    return YES;
}



@end
