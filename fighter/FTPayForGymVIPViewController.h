//
//  FTPayForGymVIPViewController.h
//  fighter
//
//  Created by 李懿哲 on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTCoachBean.h"
#import "FTGymDetailWebViewController.h"

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

@property (nonatomic, strong) FTCoachBean *coachBean;//用到了教练所在拳馆的信息

@property (nonatomic, assign) FTGymVIPType gymVIPType;//当前用户是否是当前拳馆的会员
@property (nonatomic, copy) NSString *gymName;//拳馆名字，之前从教练bean里边读取，现在接口没有返回拳馆名字，就加了这个属性用来传值 17-1-10 lyz
@end
