//
//  FTPurchaseInApp.m
//  fighter
//
//  Created by kang on 16/7/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPurchaseInApp.h"
#import <StoreKit/StoreKit.h>

@interface FTPurchaseInApp () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProductsRequest *productRequest;
@property (nonatomic, strong) NSSet *productIdentifiers;
@end

@implementation FTPurchaseInApp


- (instancetype) init {

    self = [super init];
    
    if (self) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}


- (void) testPurchase {
    
    NSString *productIdentify1 = @"";
    NSString *productIdentify2 = @"";
    _productIdentifiers =  [NSSet setWithObjects:productIdentify1, productIdentify2, nil];
    _productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productRequest.delegate =self;
    [_productRequest start];
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
