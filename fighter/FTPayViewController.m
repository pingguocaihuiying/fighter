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
#import "FTPaySingleton.h"

#define PowerCoin1 @"PowerCoin600P"//￥6
#define PowerCoin2 @"PowerCoin3000P" //￥30
#define PowerCoin3 @"PowerCoin12800P" //￥128
#define PowerCoin4 @"PowerCoin58800P" //￥588


enum{
    PowerCoin600P=10,
    PowerCoin3000P,
    PowerCoin12800P,
    PowerCoin58800P,
}productID;



@interface FTPayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    
    [self setNotification];
    
    [self initData];
    
    [self setNavigationBar];
    
    [self initSubviews];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    
    @try {
        
    
    [SKPaymentQueue canMakePayments];
        
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
    
}

- (void)dealloc {
    
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化

- (void) setNotification {
    

//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeCallback:) name:RechargeResultNoti object:nil];
    
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
    
    
    // 获取余额
    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
    [self setBalanceText:[NSString stringWithFormat:@"%ld",singleton.balance]];
    
    
    // 添加商品
    _goodsArray = [[NSMutableArray alloc]init];
    
    FTGoodsBean *goodsBean1 = [FTGoodsBean new];
    goodsBean1.goodsId = PowerCoin1;
    goodsBean1.price =  [[NSDecimalNumber alloc]initWithInt:6];
    goodsBean1.descriptions = @"Power币 600P";
    goodsBean1.details = @"Power币 600P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean1];
    
    FTGoodsBean *goodsBean2 = [FTGoodsBean new];
    goodsBean2.goodsId = PowerCoin2;
    goodsBean2.price = [[NSDecimalNumber alloc]initWithInt:30];
    goodsBean2.descriptions = @"Power币 3000P";
    goodsBean2.details = @"Power币 3000P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean2];
    
    FTGoodsBean *goodsBean3 = [FTGoodsBean new];
    goodsBean3.goodsId = PowerCoin3;
    goodsBean3.price = [[NSDecimalNumber alloc]initWithInt:128];
    goodsBean3.descriptions = @"Power币 12800P";
    goodsBean3.details = @"Power币 12800P，可以用来购买视频，格斗东西app相关服务";
    [_goodsArray addObject:goodsBean3];
    
    FTGoodsBean *goodsBean4 = [FTGoodsBean new];
    goodsBean4.goodsId = PowerCoin4;
    goodsBean4.price =[[NSDecimalNumber alloc]initWithInt:588];
    goodsBean4.descriptions = @"Power币 58800P";
    goodsBean4.details = @"Power币 58800P，可以用来购买视频，格斗东西app相关服务";
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
}

#pragma mark - 充值回调
- (void) rechargeCallback:(NSNotification *)noti {
    
    // 获取余额
    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
    [singleton fetchBalanceFromWeb:^{
        
        [self setBalanceText:[NSString stringWithFormat:@"%ld",singleton.balance]];
    }];
}



#pragma mark - response methods
//确认支付按钮
- (IBAction)payBtnAction:(id)sender {
    
    NSLog(@"select pay button");
    
    FTGoodsBean *bean = nil;
    NSArray *product = nil;
    switch (buyType) {
        case PowerCoin600P:
            bean = [_goodsArray objectAtIndex:0];
//            product=[[NSArray alloc] initWithObjects:PowerCoin1,nil];
            break;
        case PowerCoin3000P:
            bean = [_goodsArray objectAtIndex:1];
//            product=[[NSArray alloc] initWithObjects:PowerCoin2,nil];
            break;
        case PowerCoin12800P:
            bean = [_goodsArray objectAtIndex:2];
//            product=[[NSArray alloc] initWithObjects:PowerCoin3,nil];
            break;
        case PowerCoin58800P:
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
    
    FTPaySingleton *paySingleton = [FTPaySingleton shareInstance];
    [paySingleton payRequest:_productIdentifiers buyType:buyType];
}


- (void) backBtnAction:(id) ender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - delegate
#pragma mark  - UICollection delegate dataSource

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


#pragma mark - UICollectionViewDelegateFlowLayout
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
