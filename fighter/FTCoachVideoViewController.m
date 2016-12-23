//
//  FTCoachVideoViewController.m
//  fighter
//
//  Created by 李懿哲 on 21/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachVideoViewController.h"

@interface FTCoachVideoViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FTCoachVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _videoBean.title;
    [self setWebView];
}

- (void)setWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    NSString  *webViewUrlString = [NSString stringWithFormat:@"%@", _videoBean.url];//12月31日 lyz修改 把webView地址统一了，不管是咨询还是视频
    NSLog(@"webViewUrlString : %@", webViewUrlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];
}

@end
