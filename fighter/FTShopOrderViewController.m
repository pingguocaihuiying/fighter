//
//  FTShopOrderViewController.m
//  fighter
//
//  Created by kang on 16/9/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShopOrderViewController.h"

@interface FTShopOrderViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FTShopOrderViewController

#pragma mark  - 初始化对象

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    return self;
}


-(id)initWithRequest:(NSURLRequest *)request{
    self=[super init];
    self.request=request;
    return self;
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initWebView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

- (void) initNavigationBar {
    
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) initWebView {
    
    FTUserBean *localUser = [FTUserBean loginUser];
    self.webView.delegate = self;
    //获取网络请求地址url
    NSString *indexStr = [FTNetConfig host:Domain path:ShopOrderURL];
    NSString *urlString = [NSString stringWithFormat: @"%@?userId=%@&loginToken=%@&orderNo=%@",indexStr,localUser.olduserid,localUser.token,self.orederNO];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest: request];

    
}


#pragma mark - response

- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
