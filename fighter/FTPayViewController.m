//
//  FTPayViewController.m
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPayViewController.h"
#import <PassKit/PassKit.h>
#import "FTPracticeCell.h"
#import "FTPayCell.h"

#import "FTEncoderAndDecoder.h"
#import "Base64-umbrella.h"
#import "GTMBase64-umbrella.h"
#import <StoreKit/StoreKit.h>

#import "FTEncoderAndDecoder.h"


#define PowerCoin1 @"PowerCoin_10P"//￥6
#define PowerCoin2 @"PowerCoin_80P" //￥30
#define PowerCoin3 @"PowerCoin_360p" //￥128
#define PowerCoin4 @"PowerCoin_2500P" //￥588


enum{
    PowerCoin_10P=10,
    PowerCoin_80P,
    PowerCoin_360P,
    PowerCoin_2500P,
}buyCoinsTag;


@interface FTPayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SKProductsRequestDelegate,SKPaymentTransactionObserver>

{

     int buyType;
}
@property (nonatomic, strong) SKProductsRequest *productRequest;
@property (nonatomic, strong) NSSet *productIdentifiers;

@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *preArray;
@property (nonatomic, copy) NSString *orderNO;

@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, strong) NSArray *powerArray;
@end

@implementation FTPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self fetchBalanceFromWeb]; // 获取余额
    
    [self initData];
    
    [self setNavigationBar];
    
    [self initSubviews];
    
//    [PBEWithMD5AndDES decodeWithPBE:@""];
//    [PBEWithMD5AndDES encodeWithPBE:@""];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void) initData {

    _array = @[
               @"充值4按钮a",
               @"充值4按钮b",
               @"充值4按钮c",
               @"充值4按钮d"
               ];
    _preArray = @[
               @"充值4按钮apre",
               @"充值4按钮bpre",
               @"充值4按钮cpre",
               @"充值4按钮dpre"
               ];
    
    _priceArray = @[
                    @"6",
                    @"30",
                    @"128",
                    @"588"
                    ];
    
    _powerArray = @[
                    @"600",
                    @"3000",
                    @"12800",
                    @"58800"
                    ];
    
    
    // 添加商品
    _goodsArray = [[NSMutableArray alloc]init];
    
    FTGoodsBean *goodsBean1 = [FTGoodsBean new];
    goodsBean1.goodsId = PowerCoin1;
    goodsBean1.price =  [[NSDecimalNumber alloc]initWithInt:6];
    goodsBean1.descriptions = @"Power币 10P";
    goodsBean1.details = @"Power币 10P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean1];
    
    FTGoodsBean *goodsBean2 = [FTGoodsBean new];
    goodsBean2.goodsId = PowerCoin2;
    goodsBean2.price = [[NSDecimalNumber alloc]initWithInt:30];
    goodsBean2.descriptions = @"Power币 80P";
    goodsBean2.details = @"Power币 80P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean2];
    
    FTGoodsBean *goodsBean3 = [FTGoodsBean new];
    goodsBean3.goodsId = PowerCoin3;
    goodsBean3.price = [[NSDecimalNumber alloc]initWithInt:128];
    goodsBean3.descriptions = @"Power币 360P";
    goodsBean3.details = @"Power币 360P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean3];
    
    FTGoodsBean *goodsBean4 = [FTGoodsBean new];
    goodsBean4.goodsId = PowerCoin4;
    goodsBean4.price =[[NSDecimalNumber alloc]initWithInt:588];
    goodsBean4.descriptions = @"Power币 2500P";
    goodsBean4.details = @"Power币 2500P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean4];
    
}

- (void) setNavigationBar {
    self.title = @"充值";
    
    //导航栏右侧按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [cancleBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    
    //取消返回按钮
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
}

- (void) initSubviews {
    
    [self.colectionView registerNib:[UINib nibWithNibName:@"FTPayCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.colectionView.dataSource = self;
    self.colectionView.delegate = self;
    
    [_tipLabel1 setText:@"*1Power = 100Strong"];
    [_tipLabel2 setText:@"*Power币 与 Strong币，均为虚拟货币，只可在APP内部使用"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - response methods
//确认支付按钮
- (IBAction)payBtnAction:(id)sender {
    
    NSLog(@"select pay button");
    
    FTGoodsBean *bean = nil;
    NSArray *product = nil;
    switch (buyType) {
        case PowerCoin_10P:
            bean = [_goodsArray objectAtIndex:0];
//            product=[[NSArray alloc] initWithObjects:PowerCoin1,nil];
            break;
        case PowerCoin_80P:
            bean = [_goodsArray objectAtIndex:1];
//            product=[[NSArray alloc] initWithObjects:PowerCoin2,nil];
            break;
        case PowerCoin_360P:
            bean = [_goodsArray objectAtIndex:2];
//            product=[[NSArray alloc] initWithObjects:PowerCoin3,nil];
            break;
        case PowerCoin_2500P:
            bean = [_goodsArray objectAtIndex:3];
//            product=[[NSArray alloc] initWithObjects:PowerCoin4,nil];
            break;
            
        default:
        {
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择充值金额！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alerView show];
            return;
        }
            break;
    }
    
    
    product=[[NSArray alloc] initWithObjects:bean.goodsId,nil];
    _productIdentifiers =  [NSSet  setWithArray:product];
    _productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productRequest.delegate =self;
    [_productRequest start];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void) backBtnAction:(id) ender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - delegate

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *myProduct = response.products;
//    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
//    NSLog(@"产品付费数量: %lu", (unsigned long)[myProduct count]);
    
    FTGoodsBean *bean = [FTGoodsBean new];
    
    for(SKProduct *product in myProduct){
//        NSLog(@"product info");
//        NSLog(@"SKProduct 描述信息%@", [product description]);
//        NSLog(@"产品标题 %@" , product.localizedTitle);
//        NSLog(@"产品描述信息: %@" , product.localizedDescription);
//        NSLog(@"价格: %@" , product.price);
//        NSLog(@"Product id: %@" , product.productIdentifier);
        
        bean.goodsId =  product.productIdentifier; // Product id
        bean.descriptions = product.localizedTitle;// 产品标题
        bean.details = product.localizedDescription;// 产品描述信息
        bean.price = product.price;//价格
    }
    
    SKPayment *payment = nil;
    SKProduct *product = [myProduct objectAtIndex:0];
    switch (buyType) {
        case PowerCoin_10P:
            payment= [SKPayment paymentWithProduct:product];
            bean.power = [[NSDecimalNumber alloc]initWithInt:10];
            break;
        case PowerCoin_80P:
            payment= [SKPayment paymentWithProduct:product];
            bean.power = [[NSDecimalNumber alloc]initWithInt:30];
            break;
        case PowerCoin_360P:
            payment= [SKPayment paymentWithProduct:product];
            bean.power = [[NSDecimalNumber alloc]initWithInt:128];
            break;
        case PowerCoin_2500P:
            payment= [SKPayment paymentWithProduct:product];
            bean.power = [[NSDecimalNumber alloc]initWithInt:588];
            break;
            
        default:
            break;
    }

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking rechargeIAPByGoods:bean option:^(NSDictionary *dict) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"dict:%@",dict);
        NSLog(@"message:%@",dict[@"message"]);
        NSString *order = dict[@"data"][@"orderNo"];
        
        if (order.length > 0) {
            
            _orderNO = order;
            
            NSLog(@"---------发送购买请求------------");
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else {
        
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"下单失败，请稍后再试~"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alerView show];

        }
        
    }];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

-(void) requestDidFinish:(SKRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"---------- 支付请求结束 --------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
   
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"购买失败，请重新尝试购买～"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
                
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWorking checkIAPByOrderNO:_orderNO receipt:transactionReceiptString transactionId:transactionId option:^(NSDictionary *dict) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"dict:%@",dict);
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if ([dict[@"status"] isEqualToString:@"success"]) {
                
                
                [self fetchBalanceFromWeb];
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeOrCharge" object:@"RECHARGE"];
                
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"购买成功，请注意查收～"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
                
                [alerView2 show];

//                NSInteger orderState = [dict[@"data"][@"order_status"] integerValue];
//                if (orderState == 1) {
//                                    }
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



#pragma mark  UICollection delegate dataSource

//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
//    return 1;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTPayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectImageView.hidden = YES;
    
    [cell setPriceLabelPrice:[_priceArray objectAtIndex:indexPath.row] Power:[_powerArray objectAtIndex:indexPath.row]];

//    if (indexPath.row == 0) {
//        NSString *imgName = [_array objectAtIndex:indexPath.row];
//        
//        if (imgName ) {
//            cell.backImageView.image = [UIImage imageNamed:imgName];
//        }
//    }else {
//    
//        NSString *imgName = [_preArray objectAtIndex:indexPath.row];
//        
//        if (imgName ) {
//            cell.backImageView.image = [UIImage imageNamed:imgName];
//        }
//
//        
//    }
    if (indexPath.row == 0) {
        
        cell.backImageView.image = [UIImage imageNamed:@"充值背景"];
        
    }else {
        
        cell.backImageView.image = [UIImage imageNamed:@"充值背景pre"];
    }
    
    
    return cell;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        FTPayCell *cell = (FTPayCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        NSString *imgName = [_preArray objectAtIndex:indexPath.row];
        cell.selectImageView.hidden = NO;
//        if (imgName ) {
//            cell.backImageView.image = [UIImage imageNamed:imgName];
//        }

        cell.backImageView.image = [UIImage imageNamed:@"充值背景pre"];
        
        buyType = (int) indexPath.row + 10;
    }else {
    
        buyType = 0;
    }
    
}

// 释放选中状态
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        FTPayCell *cell = (FTPayCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        NSString *imgName = [_array objectAtIndex:indexPath.row];
        cell.selectImageView.hidden = YES;
//        if (imgName ) {
//            cell.backImageView.image = [UIImage imageNamed:imgName];
//        }
        cell.backImageView.image = [UIImage imageNamed:@"充值背景"];
    }
    
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = 163 * SCALE;
    float height = 30 * SCALE;
//    float width = 340 * SCALE;
//    float height = 40 * SCALE;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15* SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16 * SCALE;;
}


#pragma mark - 查询余额
- (void) fetchBalanceFromWeb {
    
    // 获取余额
    [NetWorking queryMoneyWithOption:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        if ([dict[@"status"] isEqualToString:@"success"] && dict[@"data"]) {
            
            NSDictionary *dic = dict[@"data"];
            
            NSInteger taskTotal = [dic[@"taskTotal"] integerValue];
            NSInteger otherTotal = [dic[@"otherTotal"] integerValue];
            NSInteger cost = [dic[@"cost"] integerValue];
            
            [self setBalanceText:[NSString stringWithFormat:@"%ld",taskTotal+otherTotal-cost]];
//            [_balanceLabel setText:[NSString stringWithFormat:@"%ldP",taskTotal+otherTotal-cost]];
        }else {
            
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

#pragma mark - 显示余额
- (void) setBalanceText:(NSString *) balanceString {

    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: balanceString attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"P" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    
    [_balanceLabel setAttributedText:text];

}

@end
