//
//  FTNewsDetailViewController.m
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewsDetailViewController.h"

@interface FTNewsDetailViewController ()

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
    
    self.navigationItem.title = @"拳讯";
    
    //设置webView
    [self setWebView];
}

- (void)setWebView{
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        webView.delegate = self;
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

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

@end
