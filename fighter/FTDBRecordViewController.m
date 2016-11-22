//
//  FTDBRecordViewController.m
//  fighter
//
//  Created by kang on 16/8/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDBRecordViewController.h"
#import "CreditConstant.h"


@interface FTDBRecordViewController ()<UIWebViewDelegate>
{
    
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}

@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareSubtitle;
@property(nonatomic,strong) NSString *shareThumbnail;

@property(nonatomic,strong) UIBarButtonItem *shareButton;

@end

static BOOL byPresent=NO;
static UINavigationController *navController;
static NSString *originUserAgent;

@implementation FTDBRecordViewController

#pragma mark  - 初始化对象

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




#pragma mark - life cycle

-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":originUserAgent}];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initWebView];
    
    [self setNotification];
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
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


-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 监听器

- (void) setNotification {
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setRefreshCurrentUrl:) name:@"duiba-autologin-visit" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    
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

- (void) initWebView {

    
//    [NetWorking getDuibaUrl:^(NSDictionary *dict) {
//        
//        NSLog(@"duiba dict:%@",dict);
//        
//        if (!dict) {
//            return ;
//        }
//        BOOL status = [dict[@"status"] boolValue];
//        if (status) {
//            
//            self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"data"]]];
//            [self.webView loadRequest:self.request];
//            //            self.webView.webDelegate=self;
//        }
//    }];
    
    [self.webView loadRequest:self.request];
    self.webView.delegate = self;
    [self startLoadingAnimation];
}


#pragma mark - response 

- (void) backBtnAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)onShareClick{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.shareUrl forKey:@"shareUrl"];
    [dict setObject:self.shareThumbnail forKey:@"shareThumbnail"];
    [dict setObject:self.shareTitle forKey:@"shareTitle"];
    [dict setObject:self.shareSubtitle forKey:@"shareSubtitle"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-share-click" object:self userInfo:dict];
}

-(UINavigationController*)getNavCon{
    if(byPresent){
        return self.navigationController;
    }
    return navController;
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dbnewopen" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        return NO;
    }else if([url rangeOfString:@"dbbackrefresh"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbbackrefresh"] withString:@"none"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackrefresh" object:nil userInfo:[NSDictionary dictionaryWithObject:url  forKey:@"url"]];
        return  NO;
        
    }else if([url rangeOfString:@"dbbackrootrefresh"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbbackrootrefresh"] withString:@"none"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackrootrefresh" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        return NO;
    }else if([url rangeOfString:@"dbbackroot"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbbackroot"] withString:@"none"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackroot" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        return NO;
    }else if([url rangeOfString:@"dbback"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbback"] withString:@"none"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dbback" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
        return NO;
        
    }
    
    return YES;
}


#pragma mark - 5 activite 交互事件


-(void)shouldNewOpen:(NSNotification*)notification{
    UIViewController *last=[[self getNavCon].viewControllers lastObject];
    
    FTDBRecordViewController *newvc=[[FTDBRecordViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [last.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:newvc animated:YES];
}

-(void)shouldBackRefresh:(NSNotification*) notification{
    NSInteger count=[[self getNavCon].viewControllers count];
    
    if(count>1){
        FTDBRecordViewController *second=[[self getNavCon].viewControllers objectAtIndex:count-2];
        second.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)shouldBack:(NSNotification*)notification{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shouldBackRoot:(NSNotification*)notification{

     [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)shouldBackRootRefresh:(NSNotification*)notification{
    
//    NSInteger count=[self getNavCon].viewControllers.count;
//    FTDBRecordViewController *rootVC=nil;
//    for(int i=0;i<count;i++){
//        UIViewController *vc=[[self getNavCon].viewControllers objectAtIndex:i];
//        if([vc isKindOfClass:[FTDBRecordViewController class]]){
//            rootVC=(FTDBRecordViewController*)vc;
//            break;
//        }
//    }
//    if(rootVC!=nil){
//        rootVC.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
//        [[self getNavCon] popToViewController:rootVC animated:YES];
//    }else{
//        [[self getNavCon] popViewControllerAnimated:YES];
//    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)setRefreshCurrentUrl:(NSNotification*)notify{
    
    if([notify.userInfo objectForKey:@"webView"]!=self.webView){
        self.needRefreshUrl=self.webView.request.URL.absoluteString;
    }
}

-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
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
