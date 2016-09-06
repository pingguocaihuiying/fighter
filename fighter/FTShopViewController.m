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
    [self initWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - 监听器

-  (void) setNotification {
    
    
    
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginCallback:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneLoginedCallback:) name:LoginNoti object:nil];
    
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeCallback:) name:RechargeResultNoti object:nil];
    
    
}

#pragma mark - 初始化

- (void) initWebview {
    
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //
    //    if (!localUser) {
    //
    ////        [self disableLoadingAnimation];
    //
    //        FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    //        loginVC.title = @"登录";
    //        FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    //        [self.navigationController presentViewController:nav animated:YES completion:nil];
    //
    //        [[UIApplication sharedApplication].keyWindow addLabelWithMessage:@"兄弟，格斗商城只有在登录之后才能进入~" second:3];
    //
    //
    //
    //    }
    
    
    
//    
//    [NetWorking getDuibaUrl:^(NSDictionary *dict) {
//        
//        NSLog(@"dict:%@",dict);
//        if (!dict) {
//            return ;
//        }
//        BOOL status = [dict[@"status"] boolValue];
//        if (status) {
//            
//            self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"data"]]];
//            [self.webView loadRequest:self.request];
//        }
//    }];
//    
    self.webView.delegate = self;
    
    
    
    //获取网络请求地址url
    NSString *indexStr = [FTNetConfig host:Domain path:ShopURL];
    NSString *urlString = [NSString stringWithFormat: @"%@?userId=%@&loginToken=%@",indexStr,localUser.olduserid,localUser.token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    NSString *body = [NSString stringWithFormat: @"userId=%@&loginToken=%@", localUser.olduserid,localUser.token];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
//    [request setHTTPMethod: @"POST"];
//    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    
    [self.webView loadRequest: request];
    
}

- (void)setJHRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.webView.scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initWebview];
    }];
    
    [self.webView.scrollView.mj_header beginRefreshing];
    
}

#pragma mark - WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [self disableLoadingAnimation];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self setLoadingImageView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self disableLoadingAnimation];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    
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


#pragma mark - 通知事件

// 微信登录响应
- (void) wxLoginCallback:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        
        [self initWebview];
    }
}

// 微信登录响应
- (void) phoneLoginedCallback:(NSNotification *)noti {
    
    [self initWebview];
}

// 充值后刷新界面
- (void) rechargeCallback:(NSNotification *)noti {
    
    [self initWebview];
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
