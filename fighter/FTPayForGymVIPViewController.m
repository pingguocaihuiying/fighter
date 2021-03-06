//
//  FTPayForGymVIPViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPayForGymVIPViewController.h"
#import "FTJoinGymSuccessAlertView.h"
#import "FTGymSourceViewController2.h"
#import "FTGymDetailWebViewController.h"

@interface FTPayForGymVIPViewController ()<FTJoinGymSuccessAlertViewDelegate>
{
    NSTimer *_timer;
    NSInteger _t;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (nonatomic, assign) BOOL hasBindingPhoneNum;//是否绑定手机号
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *phoneNumberLabelLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkCodeTextFieldLeading;
@property (strong, nonatomic) IBOutlet UIButton *becomeVIPButton;
@property (strong, nonatomic) IBOutlet UIView *refreshView;
@property (strong, nonatomic) IBOutlet UIImageView *outCircleImageView;

@property (nonatomic, assign) BOOL stopAnimation;
@property (nonatomic, assign) double angle;

@end

@implementation FTPayForGymVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationSytle];
    [self setSubViews];
    [self getVIPInfo];
}

// 设置导航栏
- (void) setNavigationSytle {
    [UILabel new].textColor = [UIColor colorWithHex:Custom_Red_Value];
    //设置默认标题
    self.navigationItem.title = _gymName ? _gymName : @"";
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
- (void)getVIPInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getVIPInfoWithGymId:[NSString stringWithFormat:@"%@", _coachBean.corporationid] andOption:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //无数据：非会员
        //"type"为会员类型： 0准会员 1会员 2往期会员
        
        NSString *status = dic[@"status"];
        NSLog(@"status : %@", status);
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            _gymVIPType = [type integerValue];//
            if (_gymVIPType == FTGymVIPTypeYep) {
                [self showEnterGymCourseView];
            }else if (_gymVIPType == FTGymVIPTypeApplying){
                _becomeVIPButton.enabled = YES;
            }
        }else{
            _gymVIPType = FTGymVIPTypeNope;
            _becomeVIPButton.enabled = YES;
        }
        [self setWithVIPInfo];
    }];
}
- (void)setSubViews{
    [self setSubViewsColor];//设置label等控件的颜色
    [self addGestureToView];//给self.view添加单点事件，点击后收起键盘
    [self setPhoneNumViews];
}

- (void)setWithVIPInfo{
    if (_gymVIPType == FTGymVIPTypeApplying) {
        _waitLabel.hidden = NO;
        _becomeVIPButton.hidden = YES;
        _sendCheckCodeButton.enabled = NO;
        [_sendCheckCodeButton setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
        _checkCodeTextField.enabled = NO;
        
        _refreshView.hidden = NO;
        
    }else if (_gymVIPType == FTGymVIPTypeYep){
        _becomeVIPButton.hidden = YES;
        [self showEnterGymCourseView];
    }else if (_gymVIPType == FTGymVIPTypeYep){
//        _becomeVIPButton.hidden = NO;
    }
}

- (void)showEnterGymCourseView{
    //成为会员成功提示start
    FTJoinGymSuccessAlertView *joinGynSuccessAlertView = [[[NSBundle mainBundle]loadNibNamed:@"FTJoinGymSuccessAlertView" owner:nil options:nil] firstObject];
    joinGynSuccessAlertView.delegate = self;
    joinGynSuccessAlertView.gymNameLabel.text = _gymName ? _gymName : @"";
    joinGynSuccessAlertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:joinGynSuccessAlertView];
    //成为会员成功提示end
}

- (void)setPhoneNumViews{
    if (SCREEN_WIDTH == 320) {
        _phoneNumberLabelLeading.constant = 10;
        _checkCodeTextFieldLeading.constant = 10;
    }
    
    NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
    attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *checkCodePlaceholder2 = [[NSAttributedString alloc] initWithString:@"输入验证码" attributes:attr2];
    [_checkCodeTextField setAttributedPlaceholder:checkCodePlaceholder2];
    
    FTUserBean *localUser = [FTUserTools getLocalUser];
    if (localUser.tel && ![localUser.tel isEqualToString:@""]) {//如果手机号存在
        _hasBindingPhoneNum = YES;
        _phoneNumberLabel.hidden = NO;
        _phoneNumberLabel.text = localUser.tel;
    }else{
        _hasBindingPhoneNum = NO;
        _phoneNumTextField.hidden = NO;//显示手机号输入框
        
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
        NSAttributedString *checkCodePlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:attr];
        [_phoneNumTextField setAttributedPlaceholder:checkCodePlaceholder]; 
    }
}

- (void)addGestureToView{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewTapped{
    [_phoneNumTextField resignFirstResponder];
    [_checkCodeTextField resignFirstResponder];//收起键盘
}

- (void)setSubViewsColor{
    
    _moneyValueLabel.textColor = Custom_Red;
    _RMBSignLabel.textColor = Custom_Red;
    _ypyLabel.textColor = Custom_Red;
    _phoneNumberLabel.textColor = Custom_Red;
    
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *checkCodePlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:attr];
    [self.checkCodeTextField setAttributedPlaceholder:checkCodePlaceholder];
    [self.checkCodeTextField setTextColor:[UIColor whiteColor]];
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送验证码

- (IBAction)sendCheckCodeButtonClicked:(id)sender {
    
    [_phoneNumTextField resignFirstResponder];
    [_checkCodeTextField resignFirstResponder];
    
    NSString *phoneNum;
    
    //根据绑定情况取手机号的值
    if (_hasBindingPhoneNum) {
        phoneNum = _phoneNumberLabel.text;
    }else{
        phoneNum = _phoneNumTextField.text;
    }
    
    NSRange _range = [phoneNum rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (phoneNum.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(phoneNum.length  != 11){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号长度不正确"];
            return;
        }
    }
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [NetWorking getCheckCodeForNewBindingPhone:phoneNum withType:@"gymmenbership"
                              option:^(NSDictionary *dict) {
                                  
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  NSLog(@"dict:%@",dict);
                                  if (dict != nil) {
                                      
                                      bool status = [dict[@"status"] boolValue];
                                      NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                      NSLog(@"message:%@",message);
                                      
                                      if (status == true) {
                                          
                                          [_sendCheckCodeButton setEnabled:NO];
                                          _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSendCheckCodeButton:) userInfo:nil repeats:YES];
                                          _t = 60;
                                          [self setSendCheckCodeBtnText:_t];
                                          
                                          
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


- (void) updateSendCheckCodeButton:(id) time {
    _t--;
    if (_t > 0) {
        [self setSendCheckCodeBtnText:_t];
    }else {
        
        [_sendCheckCodeButton setEnabled:YES];
        _timer.fireDate = [NSDate distantPast];
    }
    
}

- (void) setSendCheckCodeBtnText:(NSInteger)t {
    
    [_sendCheckCodeButton setTitle:[NSString stringWithFormat:@"重新发送%ld",t] forState:UIControlStateDisabled];
}

#pragma mark - 加入会员按钮被点击
- (IBAction)joinGymButtonClicked:(id)sender {
    
    
    [_phoneNumTextField resignFirstResponder];
    [_checkCodeTextField resignFirstResponder];
    
    NSString *phoneNum;
    
    //根据绑定情况取手机号的值
    if (_hasBindingPhoneNum) {
        phoneNum = _phoneNumberLabel.text;
    }else{
        phoneNum = _phoneNumTextField.text;
    }
    
    NSRange _range = [phoneNum rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (phoneNum.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(phoneNum.length  != 11){
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
    
    NSLog(@"请求加入会员");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking validCheckCodeWithPhoneNum:phoneNum andCheckCode:_checkCodeTextField.text andOption:^(NSDictionary *dic) {
        NSString *status = dic[@"status"];
        NSString *message = dic[@"message"];
        
        if ([status isEqualToString:@"success"]) {
            NSLog(@"验证码正确");
                [NetWorking requestToBeVIPWithCorporationid:[NSString stringWithFormat:@"%@", _coachBean.corporationid] andPhoneNum:phoneNum andCheckCode:_checkCodeTextField.text andOption:^(NSDictionary *dic) {
                    NSString *status = dic[@"status"];
                    NSString *message = dic[@"message"];
                    NSLog(@"status : %@\n message : %@", dic[@"status"], dic[@"message"]);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([status isEqualToString:@"success"]){
                        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"申请加入会员成功"];
                        _gymVIPType = FTGymVIPTypeApplying;
                        NSArray *vcArray = [self.navigationController viewControllers];
                        for(UIViewController *vc in vcArray){
                            if ([vc isKindOfClass:[FTGymDetailWebViewController class]]) {
                                FTGymDetailWebViewController *detailVC = (FTGymDetailWebViewController *)vc;
                                detailVC.gymVIPType = _gymVIPType;
                            }
                        }
                        
                        _becomeVIPButton.hidden = YES;
                        _waitLabel.hidden = NO;
                        _timer.fireDate = [NSDate distantPast];
                        _sendCheckCodeButton.hidden = YES;
                        
                        //显示刷新按钮
                        _refreshView.hidden = NO;
                        
                        //更改userDefaults中绑定的手机号
                        FTUserBean *localUser = [FTUserTools getLocalUser];
                        localUser.tel = phoneNum;
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                        [[NSUserDefaults standardUserDefaults]setObject:data forKey:LoginUser];
                        
                        
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }else{
                        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
                    }
                }];
            
        } else if ([status isEqualToString:@"error"])  {
            NSLog(@"status : %@\n message : %@", status, message);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
        }
        
    }];
}

- (void)enterGymButtonClicked{  
    /*
     改版之后，返回拳馆详情页 10-21
     */
    [self.navigationController popViewControllerAnimated:YES];
    
    UIViewController *detailVC = [self.navigationController viewControllers][1];
    if([detailVC respondsToSelector:@selector(getVIPInfo)]){
        [detailVC performSelector:@selector(getVIPInfo)];//刷新vip信息
    }
    
    if ([self.navigationController viewControllers].count > 2) {
        UIViewController *detailVC2 = [self.navigationController viewControllers][2];
        if([detailVC2 respondsToSelector:@selector(getVIPInfo)]){
            [detailVC2 performSelector:@selector(getVIPInfo)];//刷新vip信息
        }
    }

    
}
- (IBAction)refreshButtonClicked:(id)sender {
    _stopAnimation = NO;
    [self startAnimation];
    [NetWorking getVIPInfoWithGymId:[NSString stringWithFormat:@"%@", _coachBean.corporationid] andOption:^(NSDictionary *dic) {
        
        //从服务器获取数据后，停止动画
        _stopAnimation = YES;
        
        //无数据：非会员
        //"type"为会员类型： 0准会员 1会员 2往期会员
        
        NSString *status = dic[@"status"];
        NSLog(@"status : %@", status);
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            _gymVIPType = [type integerValue];//
            if (_gymVIPType == FTGymVIPTypeYep) {
                
                //隐藏刷新按钮
                _refreshView.hidden = NO;
                
                //显示进入约客提示框
                [self showEnterGymCourseView];
                
                //发送通知，刷新拳馆列表的显示
                [FTNotificationTools postShowMembershipGymsNoti];
                
            }else if (_gymVIPType == FTGymVIPTypeApplying){
                
            }
        }else{
            
        }
    }];
}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _outCircleImageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    if (!_stopAnimation) {
        _angle += 20;
        [self startAnimation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
