//
//  FTMatchLiveViewController.m
//  fighter
//
//  Created by mapbar on 16/8/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTMatchLiveViewController.h"
#import "WXApi.h"
#import "FTShareView.h"

@interface FTMatchLiveViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *blueProgressBarImageView;

@end

@implementation FTMatchLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];

}

- (void)initSubViews{
    [self setTopNaviViews];
    [self setLiveWebView];
}

- (void)setTopNaviViews{
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
    //        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    //设置默认标题
    self.navigationItem.title = @"直播";
}

- (void)setLiveWebView{
    _liveWebView.scrollView.scrollEnabled = NO;//禁止滚动
    
    //适配
    _webViewTopHeight.constant *= SCREEN_HEIGHT / 568;
    _webViewHeight.constant *= SCREEN_HEIGHT / 568;
    /**
     *  企鹅直播  http://live.qq.com/10002905
     *  斗鱼直播  http://www.douyu.com/611813
     */
        [_liveWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://live.qq.com/10002905"]]];
    //根据不同的机型，调整遮盖view的高度，到达完美遮挡的目的
    NSLog(@"SCREEN_WIDTH : %f", SCREEN_WIDTH);
    if (SCREEN_WIDTH == 375) {//如果屏幕宽度是375，即6、6P
        NSLog(@"等于375");
        _customViewTopheight.constant = 271;
    } else if (SCREEN_WIDTH == 540){//如果是6s、6Ps
        NSLog(@"等于540");
        _customViewTopheight.constant = 295;
    }else if (SCREEN_WIDTH == 320){//如果是5、5s、se
        NSLog(@"等于320");
        _customViewTopheight.constant = 240;
    }
    
    //拉伸图片
//    UIImage *image = [UIImage imageNamed:@"拳头-进度条-兰2"];
//    [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch];
////    [image stretchableImageWithLeftCapWidth:1 topCapHeight:image.size.height / 2];
//    _blueProgressBarImageView.image = image;
    
    
//    
//    // 加载图片
//    UIImage *image = [UIImage imageNamed:@"拳头-进度条-兰2"];
//    
//    // 设置端盖的值
//    CGFloat top = image.size.height * 0.5;
//    CGFloat left = image.size.width * 0.5;
//    CGFloat bottom = image.size.height * 0.5;
//    CGFloat right = image.size.width * 0.5;
//    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
//    
//    // 拉伸图片
//    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets];
//    
//    // 设置按钮的背景图片
////    [btn setBackgroundImage:newImage forState:UIControlStateNormal];
//    _blueProgressBarImageView.image = newImage;
//    
//    _blueProgressBarHeight.constant = 22.5;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClicked{
    //友盟分享事件统计
    NSLog(@"分享");
    [MobClick event:@"rankingPage_HomePage_ShareUp"];
    NSLog(@"转发");
    //友盟分享事件统计
    [MobClick event:@"newsPage_DetailPage_share"];
    
    //链接地址
    NSString *_webUrlString = @"";
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:_webUrlString];
    
    //分享标题
    NSString *title = @"直播";
    NSString *webUrlString = @"";
    
    
    //分享简述
    NSString *summaryString = @"国内顶尖高手直播";

    [shareView setTitle:title];
    [shareView setSummary:summaryString];
            [shareView setImage:@"微信用@200"];
    [shareView setImageUrl:@""];
    
    [shareView setUrl:webUrlString];

    [self.view addSubview:shareView];
}

@end
