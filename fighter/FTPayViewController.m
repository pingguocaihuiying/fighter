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
#import "PBEWithMD5AndDES.h"
#import "Base64-umbrella.h"
#import "GTMBase64-umbrella.h"
#import <StoreKit/StoreKit.h>

#import "PBEWithMD5AndDES.h"


@interface FTPayViewController () <PKPaymentAuthorizationViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SKProductsRequestDelegate,SKPaymentTransactionObserver>


@property (nonatomic, strong) SKProductsRequest *productRequest;
@property (nonatomic, strong) NSSet *productIdentifiers;

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *preArray;
@end

@implementation FTPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self initData];
    
    [self setNavigationBar];
    
    [self initSubviews];
    
    
    [PBEWithMD5AndDES decodeWithPBE:@""];
    [PBEWithMD5AndDES encodeWithPBE:@""];

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

    
}

- (void) initSubviews {
    
    [self.colectionView registerNib:[UINib nibWithNibName:@"FTPracticeCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.colectionView.dataSource = self;
    self.colectionView.delegate = self;
    
    [_tipLabel1 setText:@"1Power = 100Strong"];
    [_tipLabel2 setText:@"Power币 与 Strong币，均为虚拟货币，只可在APP内部使用"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - apple pay

- (void) applePayAuthorization {

    //判断设备是否支持苹果支付
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        NSLog(@"Current device does not support ApplePay");
        self.payView.hidden = YES;
    }else {
        
        //判断当前设备是否添加了银行卡
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa]]) {
            
            //创建一个跳转按钮，跳转添加银行卡界面
            PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
            [button addTarget:self action:@selector(addcardAction) forControlEvents:UIControlEventTouchUpInside];
            [self.payView addSubview:button];
            //            NSLog(@"w=%f ,h=%f",button.frame.size.width,button.frame.size.height);
            
        }else {
            
            //创建一个跳转按钮，跳转添加银行卡界面
            PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleWhiteOutline];
            [button addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
            [self.payView addSubview:button];
            //            NSLog(@"w=%f ,h=%f",button.frame.size.width,button.frame.size.height);
        }
    }

    
}


#pragma mark - response methods
//确认支付按钮
- (IBAction)payBtnAction:(id)sender {
    
    NSLog(@"select pay button");
    NSString *productIdentify1 = @"";
    NSString *productIdentify2 = @"";
    _productIdentifiers =  [NSSet setWithObjects:productIdentify1, productIdentify2, nil];
    _productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productRequest.delegate =self;
    [_productRequest start];

}



- (void) backBtnAction:(id) ender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

//跳转添加银行卡界面
- (void) addcardAction {
    
    PKPassLibrary *pklib = [[PKPassLibrary alloc]init];
    [pklib openPaymentSetup];
    
}


//跳转购买界面
- (void) buyAction {
    
    NSLog(@"begin to buy !");
    //创建支付请求
    PKPaymentRequest *request = [[PKPaymentRequest alloc]init];
    
    //配置支付请求
    //商家ID配置
    request.merchantIdentifier = @"merchant.com.gogogofighter";
    //国家代码配置
    request.countryCode = @"CN";
    //货币代码配置
    request.currencyCode = @"CNY";
    //支付网络配置（银行卡）
    request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa];
    //商户处理方式配置
    request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
    
    //商品信息列表
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:@"0.01"];
//    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"cat" amount:price1];
    
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:@"0.01"];
//    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"dog" amount:price2];
    
    NSDecimalNumber *price3 = [price1 decimalNumberByAdding:price2];
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"北京图为先科技有限公司" amount:price3];
    //商品信息列表最后一项表示汇总，label一般设置成公司名称
//    request.paymentSummaryItems = @[item1,item2,item3];
     request.paymentSummaryItems = @[item3];
    
//    //配置请求附加项
//    //发票收货地址
//    request.requiredBillingAddressFields = PKAddressFieldAll;
////    快递收货地址
//    request.requiredShippingAddressFields = PKAddressFieldAll;
////    //快递方式
//    NSDecimalNumber *methodDecimal = [NSDecimalNumber zero];
//    PKShippingMethod *method = [PKShippingMethod summaryItemWithLabel:@"顺丰快递" amount:methodDecimal];
//    method.identifier = @"shunfeng";
//    method.detail = @"送货上门";
//    request.shippingMethods = @[method];
////    //配置快递类型
//    request.shippingType = PKShippingTypeStorePickup;
    
    
    //添加一些附加数据
//    request.applicationData = [@"buyID:123456" dataUsingEncoding:NSUTF8StringEncoding];
    
    //验证用户支付授权
    PKPaymentAuthorizationViewController *payVC = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    payVC.delegate = self;
    [self presentViewController:payVC animated:YES completion:nil];
    
}
#pragma mark - delegate

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //    NSArray *skProducts = response.products;
    // process....
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    // process....
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            caseSKPaymentTransactionStatePurchased:
                //                [self completeTransaction:transaction];
                break;
            caseSKPaymentTransactionStateFailed:
                //                [self failedTransaction:transaction];
                break;
            caseSKPaymentTransactionStateRestored:
                //                [self restoreTransaction:transaction];
                
            default:
                break;
        }
    }
}



#pragma mark  UICollection delegate dataSource

//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTPracticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    @try {
        NSString *imgName = [_array objectAtIndex:indexPath.row];
        
        if (imgName ) {
            cell.imageView.image = [UIImage imageNamed:imgName];
        }

    } @catch (NSException *exception) {
        
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
    
    return cell;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FTPracticeCell *cell = (FTPracticeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *imgName = [_preArray objectAtIndex:indexPath.row];
    
    if (imgName ) {
        cell.imageView.image = [UIImage imageNamed:imgName];
    }
}

// 释放选中状态
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    FTPracticeCell *cell = (FTPracticeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *imgName = [_array objectAtIndex:indexPath.row];
    
    if (imgName ) {
        cell.imageView.image = [UIImage imageNamed:imgName];
    }
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = 163 * SCALE;
    float height = 30 * SCALE;
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

#pragma mark PKPaymentAuthorizationViewControllerDelegate
//用户授权成功，调用此方法
//参数一 授权控制器
//参数二 支付对象
//参数三 系统给定的一个回调代码块，我们需要执行代码块来告诉用户支付状态是否成功
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    
    
    NSLog(@"payment");
    
    BOOL isSucess = YES;
    
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure
    if (isSucess) {
//        completion(PKPaymentAuthorizationStatusSuccess);
         NSLog(@"PKPaymentAuthorizationStatusSuccess");
    }else {
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"PKPaymentAuthorizationStatusFailure");
    }
  
    
    
//    NSError *error;
//    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//    NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
//    
//    // ... Send payment token, shipping and billing address, and order information to your server ...
//    
//    PKPaymentAuthorizationStatus status;  // From your server
//    completion(status);
    
}

//用户授权成功或者取消授权，调用此方法
//参数一 授权控制器
//参数二 支付对象
//参数三 系统给定的一个回调代码块，我们需要执行代码块来告诉用户支付状态是否成功
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"授权结束");
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - private method
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    //    [self recordTransaction:transaction];
    //    [self provideContent:transaction.payment.productIdentifier];
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



@end
