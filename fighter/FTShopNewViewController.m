//
//  FTShopNew.m
//  fighter
//
//  Created by kang on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShopNewViewController.h"
#import "WXApi.h"
#import "FTShopOrderViewController.h"
#import "FTShopViewController.h"

@interface FTShopNewViewController () <UIWebViewDelegate,UIAlertViewDelegate>
{
    NSString *_orderNo;
    NSString *_tradeNO;
    BOOL _isAppeared;

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation FTShopNewViewController


#pragma mark  - 初始化对象

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


#pragma mark - life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self initNavigationBar];
    
    [self initWebView];
    
    [self setNotifications];
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallback:) name:WXPayResultNoti object:nil];
    if(self.needRefreshUrl!=nil){
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
        self.needRefreshUrl=nil;
        
    }else {
        if (_isAppeared) {
            
            _isAppeared = NO;
            NSLog(@"reloadSource excute");
            [self.webView stringByEvaluatingJavaScriptFromString:@"reloadSource()"];
        }
    }
    
    NSMutableString *url=[[NSMutableString alloc]initWithString:[self.request.URL absoluteString]];
    NSLog(@"url:%@",url);
}

- (void) viewDidDisappear:(BOOL)animated {
    
    _isAppeared = YES;
    //添加监听器，充值购买
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:RechargeResultNoti object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WXPayResultNoti object:nil];
   
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 初始化
- (void) setNotifications {

    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginCallback:) name:WXLoginResultNoti object:nil];
    //添加监听器，监听手机login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneLoginedCallback:) name:LoginNoti object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    
}

- (void) initNavigationBar {
    
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) initWebView {
    
    [self.webView loadRequest:self.request];
    self.webView.delegate = self;
}

- (void) loginRefresh {
   
    NSMutableString *url=[[NSMutableString alloc]initWithString:[self.request.URL absoluteString]];
    FTUserBean *localUser = [FTUserBean loginUser];
    if (localUser) {
        
        // 商品详情页登录后刷新
        if([url rangeOfString:@"loginState=false"].location!=NSNotFound ){
            
            NSString *urlString = [NSString stringWithFormat: @"userId=%@&loginToken=%@",localUser.olduserid,localUser.token];
//            [url replaceCharactersInRange:[url rangeOfString:@"shopNew"] withString:@"shop"];
            [url replaceCharactersInRange:[url rangeOfString:@"loginState=false"] withString:@"none=1"];
            [url replaceCharactersInRange:[url rangeOfString:@"userId=?&loginToken=?"] withString:urlString];
            
            self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:self.request];
        }
        
        // 兑换记录页登陆后刷新
        if ([url rangeOfString:@"toLogin=1"].location!=NSNotFound) {
        
            NSString *urlString = [NSString stringWithFormat: @"userId=%@&loginToken=%@",localUser.olduserid,localUser.token];
//            [url replaceCharactersInRange:[url rangeOfString:@"shopNew"] withString:@"shop"];
            [url replaceCharactersInRange:[url rangeOfString:@"toLogin=1"] withString:@"none=1"];
            [url replaceCharactersInRange:[url rangeOfString:@"userId=?&loginToken=?"] withString:urlString];
            
            self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:self.request];
        }else if ([url rangeOfString:@"userId=?&loginToken=?"].location!=NSNotFound) {
        
            NSString *urlString = [NSString stringWithFormat:@"userId=%@&loginToken=%@",localUser.olduserid,localUser.token];
            [url replaceCharactersInRange:[url rangeOfString:@"userId=?&loginToken=?"] withString:urlString];
            
            self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.webView loadRequest:self.request];

        }
        
    }
    
}

#pragma mark - response
- (void) backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
 
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
     self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
   
    
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    NSLog(@"url:%@",url);
    
    
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


    
    
    NSRange userIdRange = [url rangeOfString:@"js-call:userId="];
    NSRange orderNORange = [url rangeOfString:@"&orderNo="];
    NSRange priceRange = [url rangeOfString:@"&price="];
    
    if(userIdRange.location!= NSNotFound && orderNORange.location!= NSNotFound && priceRange.location!= NSNotFound  ) {
        NSLog(@"调用微信支付%@",url);
        
        
//        NSString *userId = [url substringWithRange:NSMakeRange(userIdRange.location+ userIdRange.length, orderNORange.location - userIdRange.location - userIdRange.length)];
        NSString *orderNo = [url substringWithRange:NSMakeRange(orderNORange.location+ orderNORange.length, priceRange.location - orderNORange.location - orderNORange.length)];
        NSString *price = [url substringFromIndex:priceRange.location+ priceRange.length];
       
        NSLog(@"norderNO = %@ ",orderNo);
        NSLog(@"price = %@",price);
        
        _orderNo = orderNo;
        //从本地读取存储的用户信息
         FTUserBean *localUser = [FTUserBean loginUser];
        
        NSString *userId = localUser.olduserid;//发起人id
        NSLog(@"userId = %@ ",userId);
        
        NSString *objType = @"shop";//类型
        NSString *objId = orderNo;//比赛id
        NSString *tableName = @"pl-shop";//表名：1. 下注为：pl-bet； 2. 购票为：pl-tic 3. 赛事成本支付相关：pl-mat
//        NSString *type = matchBean.payType;//3. 赛事成本支付相关为支付类型，0-我支付，1-对方支付，2-赢家支付，3-AA支付，4-输家支付，5-赞助支付
        NSString *isDelated = @"3";//0-无效记录；1-s支付；2-p支付;3-RMB元支付(默认为元)
        NSString *money = price;//交易人民币（单位：分）
        NSString *payWay = @"1";//默认为0-积分支付； 值为1-微信支付
        NSString *body = @"购买商品";//商品描述，需传入应用市场上的APP名字-实际商品名称，天天爱消除-游戏充值，示例：腾讯充值中心-QQ会员充值
        NSString *detail = @"";//商品详情，商品名称明细列表，示例：Ipad mini 16G 白色
        NSString *loginToken = localUser.token;//当前用户的login token
        NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
        
        //md5前的checkSign字典
        NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                             @"userId":userId,
                                                                                             @"objType":objType,
                                                                                             @"objId":objId,
                                                                                             @"tableName":tableName,
                                                                                             @"isDelated":isDelated,
                                                                                             @"money":money,
                                                                                             @"payWay":payWay,
                                                                                             @"body":body,
                                                                                             @"detail":detail,
                                                                                             @"loginToken":loginToken,
                                                                                             @"ts":ts}];
        NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahdggrdearyhreayt251grd"];
        [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];

        //把中文参数转码
        [dicBeforeMD5 setValue:[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"body"];
        [dicBeforeMD5 setValue:[detail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"detail"];
        
        NSDictionary *parmamDic = dicBeforeMD5;
        
        
        
        [NetWorking WXpayWithParamDic:parmamDic andOption:^(NSDictionary* dic) {
            NSLog(@"dic:%@",dic);
            NSLog(@"message:%@",[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            _tradeNO = nil;
            _tradeNO = dic[@"out_trade_no"];
            
            if (dic && dic.count > 0) {
                NSLog(@"成功");
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = dic[@"partnerid"];
                request.prepayId= dic[@"prepayid"];
                //                        request.package = @"Sign=WXPay";
                request.package = dic[@"package"];
                request.nonceStr= dic[@"noncestr"];
                request.timeStamp= [dic[@"timestamp"] intValue];
                request.sign= dic[@"sign"];
                [WXApi sendReq:request];
            } else {
                NSLog(@"失败");
            }
            
        }];
        
        return NO;
    }
    
   
    
    // 刷新积分
    if([url rangeOfString:@"refreshPoint"].location!=NSNotFound && [url rangeOfString:@"dbnewopen"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"refreshPoint"] withString:@"none"];
        [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
        
        [self openNewVC:url];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:RechargeResultNoti object:@"RECHARGE"];
        return NO;
        
    }else if([url rangeOfString:@"refreshPoint"].location!=NSNotFound) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:RechargeResultNoti object:@"RECHARGE"];
    }
    
    if([url rangeOfString:@"dbnewopen"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
        [self openNewVC:url];
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
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }

    return YES;
}

#pragma mark  webView 交互
- (void) openNewVC:(NSString *)urlString {
    
    FTShopNewViewController *newvc = [[FTShopNewViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.navigationController pushViewController:newvc animated:YES];
}

-(void)shouldBackRefresh:(NSNotification*) notification{
    NSInteger count = [self.navigationController.viewControllers count];
    
    
    if(count>1){
        FTShopNewViewController *second=[self.navigationController.viewControllers objectAtIndex:count-2];
        second.needRefreshUrl = [second.request.URL absoluteString];
    }
    NSString *urlString = [notification.userInfo objectForKey:@"url"];
    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shouldBackRoot:(NSNotification*)notification{
   
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)shouldBackRootRefresh:(NSNotification*)notification{
    
    FTShopViewController *rootVC= [self.navigationController.viewControllers objectAtIndex:0];
    rootVC.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 监听器回调

//- (void) rechargeCallback:(NSNotification *) noti {
//
//    // 获取余额
//    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
//    [singleton fetchBalanceFromWeb:^{}];
//}

#pragma mark - 通知事件
// 微信登录响应
- (void) wxLoginCallback:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        
//        [self.webView stringByEvaluatingJavaScriptFromString:@"reloadSource()"];
        [self loginRefresh];
    }
}

// 手机登录响应
- (void) phoneLoginedCallback:(NSNotification *)noti {
//    [self.webView stringByEvaluatingJavaScriptFromString:@"reloadSource()"];
    [self loginRefresh];
}



- (void) wxPayCallback:(NSNotification *) noti {
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        
        if (_tradeNO == nil) {
            return;
        }
        
        [NetWorking wxPayStatusWithOrderNO:_tradeNO andOption:^(NSDictionary *dic) {
            NSLog(@"dic:%@",dic);
            NSLog(@"message:%@",dic[@"message"]);
            NSString *status = dic[@"status"];
            if ([status isEqualToString:@"success"]) {
                [[UIApplication sharedApplication].keyWindow addMessage:@"购买商品支付成功~" ];
                [self backRefresh];
            }else {
                [[UIApplication sharedApplication].keyWindow addMessage:@"购买商品支付失败，请到兑换记录中去重新支付~" ];
                [self.webView loadRequest:self.request];
            }
        }];
        
    }else {
        
        [[UIApplication sharedApplication].keyWindow addMessage:@"微信支付失败，请到兑换记录中去重新支付~" ];
        
        [self.webView loadRequest:self.request];
    }
    
    

//    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


- (void) backRefresh {
    
    FTUserBean *localUser = [FTUserBean loginUser];
    
    //获取网络请求地址url
    NSString *indexStr = [FTNetConfig host:Domain path:ShopOrderURL];
    NSString *urlString = [NSString stringWithFormat: @"%@?userId=%@&loginToken=%@&orderNo=%@",indexStr,localUser.olduserid,localUser.token,_orderNo];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackrefresh" object:nil userInfo:[NSDictionary dictionaryWithObject:urlString  forKey:@"url"]];
    
    
    NSInteger count = [self.navigationController.viewControllers count];
    
    
    if(count>1){
        FTShopNewViewController *second=[self.navigationController.viewControllers objectAtIndex:count-2];
        second.needRefreshUrl = urlString;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
//    FTShopNewViewController *newvc = [[FTShopNewViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
//    [self.navigationController pushViewController:newvc animated:YES];
    
}

@end
