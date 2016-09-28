//
//  FTPaySingleton.m
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPaySingleton.h"
#import <StoreKit/StoreKit.h>
#import "Base64-umbrella.h"
#import "GTMBase64-umbrella.h"
#import "FTPayViewController.h"

enum{
    PowerCoin600P=10,
    PowerCoin3000P,
    PowerCoin12800P,
    PowerCoin58800P,
}buyCoinsTag;

static FTPaySingleton * singleton = nil;

@interface FTPaySingleton () <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    
    int _buyType;
    NSString * _orderNO;
}

@property (nonatomic, strong) NSMutableDictionary *goodsDict;
@property (nonatomic, strong)NSString *orderNO;
@property (nonatomic, strong) SKProductsRequest *productRequest;

@end

@implementation FTPaySingleton

#pragma mark - 初始化单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
        [singleton registNotifacation];
        [singleton setGoodsArray];
        singleton.orderNO = @"1234567";
    });
    return singleton;
}

+ (instancetype) shareInstance {
    return [self allocWithZone:nil];
}

- (id) copyWithZone:(NSZone *)zone;{
    return self;
}

- (void) setGoodsArray {

    // 添加商品
    _goodsDict = [[NSMutableDictionary alloc]init];
    
    FTGoodsBean *goodsBean1 = [FTGoodsBean new];
    goodsBean1.goodsId = PowerCoin1;
    goodsBean1.price =  [[NSDecimalNumber alloc]initWithInt:6];
    goodsBean1.descriptions = @"Power币 600P";
    goodsBean1.details = @"Power币 600P，您可以用于购买我们的服务，包括不限于付费视频，优惠券等内容。";
    [_goodsDict setObject:goodsBean1 forKey:PowerCoin1];
    
    FTGoodsBean *goodsBean2 = [FTGoodsBean new];
    goodsBean2.goodsId = PowerCoin2;
    goodsBean2.price = [[NSDecimalNumber alloc]initWithInt:30];
    goodsBean2.descriptions = @"Power币 3000P";
    goodsBean2.details = @"Power币 3000P，您可以用于购买我们的服务，包括不限于付费视频，优惠券等内容。";
    [_goodsDict setObject:goodsBean2 forKey:PowerCoin2];
    
    FTGoodsBean *goodsBean3 = [FTGoodsBean new];
    goodsBean3.goodsId = PowerCoin3;
    goodsBean3.price = [[NSDecimalNumber alloc]initWithInt:128];
    goodsBean3.descriptions = @"Power币 12800P";
    goodsBean3.details = @"Power币 12800P，您可以用于购买我们的服务，包括不限于付费视频，优惠券等内容。";
    [_goodsDict setObject:goodsBean3 forKey:PowerCoin3];
    
    FTGoodsBean *goodsBean4 = [FTGoodsBean new];
    goodsBean4.goodsId = PowerCoin4;
    goodsBean4.price =[[NSDecimalNumber alloc]initWithInt:588];
    goodsBean4.descriptions = @"Power币 58800P";
    goodsBean4.details = @"Power币 58800P，您可以用于购买我们的服务，包括不限于付费视频，优惠券等内容。";
    [_goodsDict setObject:goodsBean4 forKey:PowerCoin4];
}

#pragma mark - 注册通知
- (void) registNotifacation {

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBalance:) name:RechargeResultNoti object:nil];
}

#pragma mark - 发起购买
- (void) payRequest:(NSSet *) productIdentifiers buyType:(int) buytpye {
    
    _buyType = buytpye;
    _productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    _productRequest.delegate =self;
    [_productRequest start];
    
     [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    @try {
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSArray *myProduct = response.products;
        //    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
        //    NSLog(@"产品付费数量: %lu", (unsigned long)[myProduct count]);
        
        FTGoodsBean *bean = [FTGoodsBean new];
        
        for(SKProduct *product in myProduct){
//            bean.goodsId =  product.productIdentifier; // Product id
//            bean.descriptions = product.localizedTitle;// 产品标题
//            bean.details = product.localizedDescription;// 产品描述信息
//            bean.price = product.price;//价格
            bean = [_goodsDict objectForKey:product.productIdentifier];
            NSLog(@"localizedTitle= %@",product.localizedTitle);
            NSLog(@"localizedDescription= %@",product.localizedDescription);
        }
        
        
        NSLog(@"goodsId= %@",bean.goodsId);
        NSLog(@"descriptions= %@",bean.descriptions);
        NSLog(@"details= %@",bean.details);
        NSLog(@"price= %@",bean.price);
        
        SKPayment *payment = nil;
        
        SKProduct *product = [myProduct objectAtIndex:0];
        switch (_buyType) {
            case PowerCoin600P:
                payment= [SKPayment paymentWithProduct:product];
                bean.power = [[NSDecimalNumber alloc]initWithInt:600];
                break;
            case PowerCoin3000P:
                payment= [SKPayment paymentWithProduct:product];
                bean.power = [[NSDecimalNumber alloc]initWithInt:3000];
                break;
            case PowerCoin12800P:
                payment= [SKPayment paymentWithProduct:product];
                bean.power = [[NSDecimalNumber alloc]initWithInt:12800];
                break;
            case PowerCoin58800P:
                payment= [SKPayment paymentWithProduct:product];
                bean.power = [[NSDecimalNumber alloc]initWithInt:58800];
                break;
                
            default:
                break;
        }
        
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [NetWorking rechargeIAPByGoods:bean option:^(NSDictionary *dict) {
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"dict:%@",dict);
            NSLog(@"message:%@",dict[@"message"]);
            NSString *order = dict[@"data"][@"orderNo"];
            
            if (dict == nil) {
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"从服务器获取订单数据失败，请稍后再试"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil];
                [alerView show];
                return ;
            }
            if (order.length > 0) {
                
                _orderNO = order;
                
                NSLog(@"---------发送购买请求------------");
                [[SKPaymentQueue defaultQueue] addPayment:payment];
                [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            }else {
                
                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil];
                [alerView show];
                
            }
            
        }];
        
    } @catch (NSException *exception) {
        
        NSLog(@"pay exception:%@",exception);
        
    } @finally {
        
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

-(void) requestDidFinish:(SKRequest *)request
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    NSLog(@"---------- 支付请求结束 --------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                
                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"购买失败，请重新尝试购买～"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                
                [alerView2 show];
            }
                
                break;
            case SKPaymentTransactionStateRestored: {
                
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            }
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - 交易处理
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------");
    
    NSString * transactionId = transaction.transactionIdentifier;
    NSLog(@"*******************************************************");
    NSLog(@"transactionId:%@",transactionId);
    NSLog(@"*******************************************************");
    
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSString *transactionReceiptString;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
            
            NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
            NSError *error = nil;
            NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
            transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
        }else {
            
            NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
            transactionReceiptString = [receipt base64String];
        }
        
        // 二次验证，将receiptdata base64 之后发送给服务器，有服务器向AppStore验证是否充值成功
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [NetWorking checkIAPByOrderNO:_orderNO receipt:transactionReceiptString transactionId:transactionId option:^(NSDictionary *dict) {
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"dict:%@",dict);
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if ([dict[@"status"] isEqualToString:@"success"]) {
                
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RechargeResultNoti object:@"RECHARGE"];
                
                
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"购买成功，请注意查收～"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                
                [alerView2 show];
                
                
            }
        }];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@" 交易恢复处理");
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark - 余额

// 刷新余额
- (void) refreshBalance:(NSNotification *)noti {
    
    [self fetchBalanceFromWeb:nil];
}


- (void) fetchBalanceFromWeb:(void (^)(void))option {
    
    //判断是否登录
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    if (localUserData == nil ) {
        return;
    }
    
    // 获取余额
    [NetWorking queryMoneyWithOption:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        if ([dict[@"status"] isEqualToString:@"success"] && dict[@"data"]) {
            
            NSDictionary *dic = dict[@"data"];
            
            NSInteger taskTotal = [dic[@"taskTotal"] integerValue];
            NSInteger otherTotal = [dic[@"otherTotal"] integerValue];
            NSInteger cost = [dic[@"cost"] integerValue];
            self.balance = taskTotal+otherTotal-cost;
            
            if (option) {
                option();
            }
           
        }else {
            
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

@end
