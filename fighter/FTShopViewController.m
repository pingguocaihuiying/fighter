//
//  FTShopViewController.m
//  fighter
//
//  Created by kang on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShopViewController.h"
//#import "JHRefresh.h"
#import "MJRefresh-umbrella.h"
#import "FTShopNewViewController.h"

@interface FTShopViewController () <UIWebViewDelegate,UIAlertViewDelegate>
{
    
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
    BOOL _isAppeared;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareSubtitle;
@property(nonatomic,strong) NSString *shareThumbnail;

@property(nonatomic,strong) UIBarButtonItem *shareButton;

@end

@implementation FTShopViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNotification];
    [self initNavigationBar];
    [self setWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    
//    if(self.needRefreshUrl!=nil){
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
//        self.needRefreshUrl=nil;
//    }
    
    if (_isAppeared ) {
        
        _isAppeared = NO;
        [self.webView stringByEvaluatingJavaScriptFromString:@"reloadSource()"];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {

    _isAppeared = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听器

-  (void) setNotification {
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeCallback:) name:RechargeResultNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchDetailAction:) name:SwitchShopDetailNoti object:nil];
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
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
}


- (void) setWebView {
    
    [self initWebview];
    [self setMJRefresh];
    
}

- (void) initWebview {
    
    FTUserBean *localUser = [FTUserBean loginUser];
    if (localUser) {
        
        self.webView.delegate = self;
        //获取网络请求地址url
        NSString *indexStr = [FTNetConfig host:Domain path:ShopNewURL];
        NSString *urlString = [NSString stringWithFormat: @"%@?userId=%@&loginToken=%@",indexStr,localUser.olduserid,localUser.token];
        NSLog(@"shop home urlString:%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest: request];
    }else {
        
        self.webView.delegate = self;
        //获取网络请求地址url
        NSString *indexStr = [FTNetConfig host:Domain path:ShopNewURL];
        NSURL *url = [NSURL URLWithString:indexStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest: request];
        
    }
    
}

- (void)setMJRefresh{
    
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.webView.scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf initWebview];
        [weakSelf.webView.scrollView.mj_header beginRefreshing];
    }];
    
}

#pragma mark - WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [self disableLoadingAnimation];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self setLoadingImageView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.webView.scrollView.mj_header endRefreshing];
//    [self disableLoadingAnimation];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    // 检测登录
    if([url rangeOfString:@"toLogin=1"].location!=NSNotFound){
        
        if ([self isLogined]) {
            
            FTUserBean *localUser = [FTUserBean loginUser];
            NSString *urlString = [NSString stringWithFormat: @"userId=%@&loginToken=%@",localUser.olduserid,localUser.token];
            [url replaceCharactersInRange:[url rangeOfString:@"toLogin=1"] withString:urlString];
            
        }else {
            
            return NO;
        }
    }
    
    if([url rangeOfString:@"js-call:userId="].location!= NSNotFound &&
       [url rangeOfString:@"&orderNo="].location!= NSNotFound &&
       [url rangeOfString:@"&price="].location!= NSNotFound  ) {
        NSLog(@"调用微信支付%@",url);
        return NO;
    }
    
    if([url rangeOfString:@"dbnewopen"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
        
        [self openNewVC:url];
        return NO;
    }
    
    return YES;
}

#pragma mark 5 activite
- (void) openNewVC:(NSString *)urlString {

    FTShopNewViewController *newvc = [[FTShopNewViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.navigationController pushViewController:newvc animated:YES];
}


#pragma mark - response
- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 通知事件
// 登录响应
- (void) loginCallBack:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self setWebView];
    }
}


// 充值后刷新界面
- (void) rechargeCallback:(NSNotification *)noti {
    
    [self setWebView];
}



/**
 应用内跳转，跳转到商品详情页

 @param noti
 */
- (void) switchDetailAction:(NSNotification *) noti {
    
    if (noti.userInfo != nil) {
    
    }
    
}

#pragma mark - loading动画

-(void)setLoadingImageView{
    
    //背景框imageview
    _loadingBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading背景"]];
    _loadingBgImageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    [self.view addSubview:_loadingBgImageView];
    
    //声明数组，用来存储所有动画图片
    _loadingImageView = [UIImageView new];
    _loadingImageView.frame = CGRectMake(10, 10, 80, 80);
    
    [_loadingBgImageView addSubview:_loadingImageView];//把用于显示动画的imageview放入背景框中
    //初始化数组
    NSMutableArray *photoArray = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        //获取图片名称
        NSString *photoName = [NSString stringWithFormat:@"格斗家-loading2000%d", i];
        //获取UIImage
        UIImage *image = [UIImage imageNamed:photoName];
        //把图片加载到数组中
        [photoArray addObject:image];
    }
    
    //给动画数组赋值
    _loadingImageView.animationImages = photoArray;
    
    //一组动画使用的总时间长度
    _loadingImageView.animationDuration = 1;
    
    //设置循环次数。0表示不限制
    _loadingImageView.animationRepeatCount = 0;
    [_loadingImageView startAnimating];
}

- (void)startLoadingAnimation{
    //启动动画
    [_loadingImageView startAnimating];
    
}

- (void)disableLoadingAnimation {
    //停止动画，移除动画imageview
    [_loadingImageView stopAnimating];
    [_loadingImageView removeFromSuperview];
    _loadingImageView = nil;
    [_loadingBgImageView removeFromSuperview];
    _loadingBgImageView = nil;
}




@end
