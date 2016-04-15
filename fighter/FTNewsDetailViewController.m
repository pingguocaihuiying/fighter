//
//  FTNewsDetailViewController.m
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewsDetailViewController.h"

@interface FTNewsDetailViewController ()<UIWebViewDelegate>

@end

@implementation FTNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;

    //设置分享按钮
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(popVC)];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(shareButtonClicked)];
    shareButton.tintColor = [UIColor whiteColor];
     [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    //设置默认标题
    self.navigationItem.title = @"加载中...";
    
    //设置webView
    [self setWebView];
    [self.view bringSubviewToFront:self.bottomView];
}

- (void)setWebView{
    CGRect r = self.view.frame;
    r.size.height -= 49;
        UIWebView *webView = [[UIWebView alloc]initWithFrame:r];
        webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.title = self.newsTitle;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
        self.navigationController.navigationBarHidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commenButtonClicked:(id)sender {
}

- (void)shareButtonClicked{
    
}
- (IBAction)thumbButtonClicked:(id)sender {
}

@end
