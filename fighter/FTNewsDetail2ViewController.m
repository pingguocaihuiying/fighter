//
//  TestViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewsDetail2ViewController.h"
#import "FTCommentViewController.h"

@interface FTNewsDetail2ViewController ()<UIWebViewDelegate>

@end

@implementation FTNewsDetail2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
    NSLog(@"SCREEN_WIDTH : %f, SCREEN_HEIGHT : %f",SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setWebView];
}

- (void)setSubViews{
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
    
}

- (void)setWebView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view sendSubviewToBack:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.title = self.newsTitle;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commenButtonClicked:(id)sender {
    NSLog(@"commenButtonClicked.");
    FTCommentViewController *commentVc = [ FTCommentViewController new];
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (void)shareButtonClicked{
    self.bgView.hidden = NO;
}
- (IBAction)thumbButtonClicked:(id)sender {
    self.hasThumbUp = !self.hasThumbUp;
    if (self.hasThumbUp) {
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
    }else{
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
}
- (IBAction)cancelShareButtonClicked:(id)sender {
    self.bgView.hidden = YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
