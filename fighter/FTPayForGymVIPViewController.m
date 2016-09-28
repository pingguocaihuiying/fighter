//
//  FTPayForGymVIPViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPayForGymVIPViewController.h"
#import "FTJoinGymSuccessAlertView.h"
#import "FTGymSourceViewController.h"

@interface FTPayForGymVIPViewController ()<FTJoinGymSuccessAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (nonatomic, assign) BOOL hasBindingPhoneNum;//是否绑定手机号

@end

@implementation FTPayForGymVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationSytle];
    [self setSubViews];
}

// 设置导航栏
- (void) setNavigationSytle {
    [UILabel new].textColor = [UIColor colorWithHex:Custom_Red_Value];
    //设置默认标题
    self.navigationItem.title = _gymDetailBean.gym_name;
    
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
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)setSubViews{
    //设置label等控件的颜色
    [self setSubViewsColor];
    [self addGestureToView];//给self.view添加单点事件，点击后收起键盘
    [self setPhoneNumViews];
}

- (void)setPhoneNumViews{
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
    NSString *phoneNum;
    
    //根据绑定情况取手机号的值
    if (_hasBindingPhoneNum) {
        phoneNum = _phoneNumberLabel.text;
    }else{
        phoneNum = _phoneNumTextField.text;
    }
    
    NSLog(@"发送验证码");
}

#pragma mark - 加入会员按钮被点击
- (IBAction)joinGymButtonClicked:(id)sender {
    NSLog(@"请求加入会员");
    FTJoinGymSuccessAlertView *joinGynSuccessAlertView = [[[NSBundle mainBundle]loadNibNamed:@"FTJoinGymSuccessAlertView" owner:nil options:nil] firstObject];
    joinGynSuccessAlertView.delegate = self;
    joinGynSuccessAlertView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:joinGynSuccessAlertView];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:joinGynSuccessAlertView];
}

- (void)enterGymButtonClicked{
    NSLog(@"进入拳馆预约课程");
    FTGymSourceViewController *gymSourceViewController = [FTGymSourceViewController new];
    gymSourceViewController.gymDetailBean = _gymDetailBean;
    [self.navigationController pushViewController:gymSourceViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
