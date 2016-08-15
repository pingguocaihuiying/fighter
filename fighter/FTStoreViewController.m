//
//  FTDuibaViewController.m
//  fighter
//
//  Created by kang on 16/8/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTStoreViewController.h"
#import "FTRankViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

//#import "CreditNavigationController.h"

#import "CreditWebView.h"
#import "CreditConstant.h"

#import "FTDBRecordViewController.h"

@interface FTStoreViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{

    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}
//@property(nonatomic,strong) NSURLRequest *request;
//@property(nonatomic,strong) CreditWebView *webView;

@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareSubtitle;
@property(nonatomic,strong) NSString *shareThumbnail;

@property(nonatomic,strong) UIBarButtonItem *shareButton;


//@property(nonatomic,strong) UIActivityIndicatorView *activity;


@end

static BOOL byPresent=NO;

static NSString *originUserAgent;

//@interface FTStoreViewController () <UIWebViewDelegate>
//
//@property (nonatomic,strong) NSDictionary *loginData;
//
//@end

@implementation FTStoreViewController

-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    return self;
}

-(id)initWithUrlByPresent:(NSString *)url{
    
    self=[self initWithUrl:url];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem=leftButton;
    byPresent=YES;
    
    
    
    return self;
}
-(id)initWithRequest:(NSURLRequest *)request{
    self=[super init];
    self.request=request;
    
    
    return self;
}

-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":originUserAgent}];
    
}

- (void)viewDidLoad {
    
    [self setNotification];
    
    [super viewDidLoad];
    
    
    [self initWebview];
    
    [self setLoadingImageView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    

    if(originUserAgent==nil){
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        originUserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    NSString *ua=[originUserAgent stringByAppendingFormat:@" Duiba/%@",DUIBA_VERSION];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":ua}];
}

-(void)viewDidAppear:(BOOL)animated{
    //self.webView.frame=self.view.bounds;
    if(self.needRefreshUrl!=nil){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
        self.needRefreshUrl=nil;
    }
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
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
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setRefreshCurrentUrl:) name:@"duiba-autologin-visit" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"OpenNewController" object:nil];
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
}

#pragma mark - 初始化

- (void) initWebview {

    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (!localUser) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有登录哟，先去登录吧~" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
//        [alert show];
        
        
        FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
        loginVC.title = @"登录";
        FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        [loginVC.view addLabelWithMessage:@"兄弟，格斗商城只有在登录之后才能进入~" second:10];
        return;
    }
    
    [NetWorking getDuibaUrl:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        if (!dict) {
            return ;
        }
        BOOL status = [dict[@"status"] boolValue];
        if (status) {
            
            self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"data"]]];
            [self.webView loadRequest:self.request];
        }
    }];
    
    self.webView.delegate = self;
    
}

#pragma mark - button response


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        
        FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
        loginVC.title = @"登录";
        FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    [self disableLoadingAnimation];
}

#pragma mark - WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self disableLoadingAnimation];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self startLoadingAnimation];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self disableLoadingAnimation];
    
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *content=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('duiba-share-url').getAttribute('content');"];
    if(content.length>0){
        NSArray *d=[content componentsSeparatedByString:@"|"];
        if(d.count==4){
            self.shareUrl=[d objectAtIndex:0];
            self.shareThumbnail=[d objectAtIndex:1];
            self.shareTitle=[d objectAtIndex:2];
            self.shareSubtitle=[d objectAtIndex:3];
            
            if(self.shareButton==nil){
                self.shareButton=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(onShareClick)];
            }
            
            if(self.navigationItem.rightBarButtonItem==nil){
                self.navigationItem.rightBarButtonItem=self.shareButton;
            }
        }
    }else{
        if(self.shareButton!= nil && self.shareButton==self.navigationItem.rightBarButtonItem){
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    if([url rangeOfString:@"autoLogin/autologin" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        NSDictionary *dict=[NSDictionary dictionaryWithObject:self forKey:@"webView"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"duiba-autologin-visit" object:nil userInfo:dict];
    }
    NSArray *urlComps = [url componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"]){
        if([[urlComps objectAtIndex:1] hasPrefix:@"duiba/"]){
            NSArray *d=[[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
            if(d.count==2 && [d[1] isEqualToString:@"login"]){
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [dict setObject:webView.request.URL.absoluteString forKey:@"currentUrl"];
                [dict setObject:webView forKey:@"webView"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-login-click" object:self userInfo:dict];
                return NO;
            }
        }
    }
    
    if([url rangeOfString:@"dbnewopen"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"OpenNewController" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        return NO;
    }
    
    return YES;
}

-(void)onShareClick{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.shareUrl forKey:@"shareUrl"];
    [dict setObject:self.shareThumbnail forKey:@"shareThumbnail"];
    [dict setObject:self.shareTitle forKey:@"shareTitle"];
    [dict setObject:self.shareSubtitle forKey:@"shareSubtitle"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-share-click" object:self userInfo:dict];
}


#pragma mark - 5 activite 交互事件

-(void)shouldNewOpen:(NSNotification*)notification{

    FTDBRecordViewController *newvc=[[FTDBRecordViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
    [self.navigationController pushViewController:newvc animated:YES];
    
}


#pragma mark - 通知事件

-(void)setRefreshCurrentUrl:(NSNotification*)notify{
    
    self.needRefreshUrl=self.webView.request.URL.absoluteString;
}


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
