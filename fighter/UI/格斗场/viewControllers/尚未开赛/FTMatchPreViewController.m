//
//  FTMatchPreViewController.m
//  fighter
//
//  Created by 李懿哲 on 8/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTMatchPreViewController.h"

@interface FTMatchPreViewController ()

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation FTMatchPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self setWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setWebView{
    _webView = [UIWebView new];
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewURL]]];
}

- (void)setNavi{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
