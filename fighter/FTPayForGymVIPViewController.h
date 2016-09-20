//
//  FTPayForGymVIPViewController.h
//  fighter
//
//  Created by 李懿哲 on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTPayForGymVIPViewController : FTBaseViewController

//价格相关的三个label
@property (strong, nonatomic) IBOutlet UILabel *moneyValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *RMBSignLabel;
@property (strong, nonatomic) IBOutlet UILabel *ypyLabel;

//手机号
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

//验证码输入框
@property (strong, nonatomic) IBOutlet UITextField *checkCodeTextField;

//分割线
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;

//发送验证码
@property (strong, nonatomic) IBOutlet UIButton *sendCheckCodeButton;
@property (strong, nonatomic) IBOutlet UILabel *waitLabel;

@end
