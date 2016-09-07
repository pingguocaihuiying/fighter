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

@interface FTShopNewViewController () <UIWebViewDelegate,UIAlertViewDelegate>
{
    NSString *_orderNo;
    NSString *_tradeNO;
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
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeCallback:) name:RechargeResultNoti object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallback:) name:WXPayResultNoti object:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]removeObserver:self name:RechargeResultNoti object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WXPayResultNoti object:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) initWebView {
    
    [self.webView loadRequest:self.request];
    self.webView.delegate = self;
    
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
    
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    
    
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
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        
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

    if([url rangeOfString:@"dbnewopen"].location!=NSNotFound){
        [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
        
        [self openNewVC:url];
        return NO;
    }

    return YES;
}

#pragma mark  webView 交互
- (void) openNewVC:(NSString *)urlString {
    
    FTShopNewViewController *newvc = [[FTShopNewViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.navigationController pushViewController:newvc animated:YES];
}

#pragma mark - 监听器回调

- (void) rechargeCallback:(NSNotification *) noti {

    // 获取余额
    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
    [singleton fetchBalanceFromWeb:^{}];
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
            NSString *status = dic[@"status"] ;
            if ([status isEqualToString:@"success"]) {
                [[UIApplication sharedApplication].keyWindow addMessage:@"购买商品支付成功~" ];
            }else {
                [[UIApplication sharedApplication].keyWindow addMessage:@"购买商品支付失败，请到兑换记录中去重新支付~" ];
            }
        }];
        
    }else {
        [[UIApplication sharedApplication].keyWindow addMessage:@"微信支付失败，请到兑换记录中去重新支付~" ];
    }
    
    [self openOrderVC];

//    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


- (void) openOrderVC {

    FTShopOrderViewController *orderVC = [[FTShopOrderViewController alloc]init];
    orderVC.orederNO = _orderNo;
    
    [self.navigationController pushViewController:orderVC animated:YES];
}

@end
