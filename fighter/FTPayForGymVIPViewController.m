//
//  FTPayForGymVIPViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPayForGymVIPViewController.h"

@interface FTPayForGymVIPViewController ()

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
    self.navigationItem.title = @"必图培训中心";
    
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
}

- (void)addGestureToView{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewTapped{
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
    NSLog(@"发送验证码");
}

#pragma mark - 微信支付按钮被点击
- (IBAction)wechatPayButtonClicked:(id)sender {
    NSLog(@"微信支付");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
