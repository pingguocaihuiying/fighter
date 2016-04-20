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
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setWebView];
}

- (void)setSubViews{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
//    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(popVC)];
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(shareButtonClicked)];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    //设置默认标题
    self.navigationItem.title = @"拳讯";

}

- (void)setWebView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor blackColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
    NSString *url = _bean.url;
    url = [self encodeToPercentEscapeString:url];
    NSString *title = _bean.title;
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _urlString = [NSString stringWithFormat:@"http://www.loufang.studio/page/news_page.html?objId=%@&title=%@&author=%@&newsTime=%@&commentCount=%@&voteCount=%@&url=%@&tableName=%@&type=%@", _bean.newsId, title, _bean.author, _bean.newsTime, _bean.commentCount, _bean.voteCount,url , @"c-news", _bean.newsType];
    NSLog(@"webViewUrl : %@", _urlString);
    

    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view sendSubviewToBack:webView];
}

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{

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

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

@end
