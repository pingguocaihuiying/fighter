//
//  FTInvitationCodeViewController.m
//  fighter
//
//  Created by kang on 2016/12/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTInvitationCodeViewController.h"
#import "FTInvitationCodePopUpView.h"
#import "NSDate+Tool.h"
@interface FTInvitationCodeViewController () <UITextFieldDelegate>
{

    NSInteger type;//type:邀请码类型：0时间卡 1次卡 2充值卡(本地避免默认值为零，统一 +1)
    NSInteger corporationId;//邀请码的所属拳馆
//    NSInteger typeParms;//typeParms：跟type绑定的参数，时间卡单位天，次卡单位次，充值卡单位分
    NSInteger remainTimes; //剩余约课次数
    NSInteger money;// 账户余额
    NSTimeInterval deadline;//会员到期时间
    NSString *gymName;
   
}
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeTextField;

@end

@implementation FTInvitationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init


- (void) setNotification {

    
}


- (void) setNavigationBar {

    self.title = @"输入邀请码";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void) setSubviewws {
    
    self.invitationCodeTextField.delegate = self;
    
}

#pragma mark - response


- (void) backBtnAction:(id) sender {

    [self.invitationCodeTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)submitButton:(id)sender {
    
    // test code
//    self.invitationCodeTextField.text = @"YQMBA24160E0A1D47FDA";
    if (self.invitationCodeTextField.text.length == 0) {
        [self.view showMessage:@"请输入邀请码"];
    }
    
    [self userInvitationCode];
//    [self getInvigationCodeInfo];
}


#pragma mark - 获取服务器信息

/**
 使用邀请码
 */
- (void) userInvitationCode {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking useInvitationCode:self.invitationCodeTextField.text option:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"invitation use dic=%@",dic);
        if (!dic) {
            [self.view showMessage:@"网络错误，请稍后再试"];
            return ;
        }
        
        if ([dic[@"status"] isEqualToString:@"success"]) {
            [self getInvigationCodeInfo];
        }else {
            [self.view showMessage:[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}



/**
 查询邀请码信息
 */
- (void) getInvigationCodeInfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getInvitationCodeInfo:self.invitationCodeTextField.text option:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"invitation info dic=%@",dic);
        NSLog(@"name=%@",dic[@"data"][@"name"]);
        if (!dic) {
            [self.view showMessage:@"网络错误，请稍后再试"];
            return ;
        }
        
        if ([dic[@"status"] isEqualToString:@"success"]) {
            type = [dic[@"data"][@"type"] integerValue] +1;
            corporationId = [dic[@"data"][@"corporationId"] integerValue];
            [self getVIPInfo];
        }else {
            [self.view showMessage:[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }];
}


/**
 添加本地会员拳馆
 */
- (void) addLocationMemberCorporation {

    FTUserBean *loginUser = [FTUserBean loginUser];
    if (![loginUser.isGymUser containsObject:[NSNumber numberWithInteger:corporationId]]) {
        NSMutableArray *memberArray = [[NSMutableArray alloc]initWithArray:loginUser.isGymUser];
        [memberArray addObject:[NSNumber numberWithInteger:corporationId]];
        loginUser.isGymUser = memberArray;
        
        // 存储数据到本地
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginUser];
        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        // 刷新会员拳馆列表通知
        [FTNotificationTools postShowMembershipGymsNoti];
    }
}

/**
 查询会员信息
 */
- (void) getVIPInfo {
    
    NSString *ddd = [NSString stringWithFormat:@"%ld",corporationId];
    [NetWorking getVIPInfoWithGymId:ddd andOption:^(NSDictionary *dic) {
        NSLog(@"dic=%@",dic);
        NSLog(@"dic=%@",[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        if (!dic) {
            [self.view showMessage:@"网络错误，请稍后再试"];
            return ;
        }
        
        if ([dic[@"status"] isEqualToString:@"success"]) {
            
            money = [dic[@"data"][@"money"] integerValue];
            remainTimes = [dic[@"data"][@"remainType"] integerValue];
            deadline = [dic[@"data"][@"expireTime"] doubleValue];
            gymName = dic[@"gym_name"];
            
            [self popUpView];
        }
        
    }];
}


/**
 弹出提示框
 */
- (void) popUpView {

    FTInvitationCodePopUpView * popUpView = [[FTInvitationCodePopUpView alloc] initWithFrame:self.view.bounds];
    popUpView.corporationid = [NSString stringWithFormat:@"%ld",corporationId];
    popUpView.gymName = gymName;
    
    if (type == 1) { // time car code
        popUpView.memberType = FTMemberTypeDate;
        NSString *expireTime = [NSDate dateStringWithWordSpace:[NSString stringWithFormat:@"%f",deadline]];
        popUpView.deadline = expireTime;
    }else if (type == 2) {// times car code
        popUpView.memberType = FTMemberTypeTimes;
        popUpView.times = [NSString stringWithFormat:@"%ld",remainTimes];
    }else if (type == 3) {//charge car code
        popUpView.memberType = FTMemberTypeMoney;
        popUpView.balance = [NSString stringWithFormat:@"%ld",money];
    }
    popUpView.dismissBlock = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    [self.view addSubview:popUpView];
}

#pragma mark - delegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    NSString *text = [textField text];
//    
//    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
//        return NO;
//    }
//    
//    text = [text stringByReplacingCharactersInRange:range withString:string];
//    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSString *newString = @"";
//    while (text.length > 0) {
//        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
//        newString = [newString stringByAppendingString:subString];
//        if (subString.length == 4) {
//            newString = [newString stringByAppendingString:@" "];
//        }
//        text = [text substringFromIndex:MIN(text.length, 4)];
//    }
//    
//    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
//    
//    if (newString.length >= 20) {
//        return NO;
//    }
//    
//    [textField setText:newString];
//    
//    return NO;
//}




@end
