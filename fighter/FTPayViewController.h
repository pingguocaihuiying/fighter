//
//  FTPayViewController.h
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankBaseViewController.h"

#define PowerCoin1 @"PowerCoin600P"//￥6
#define PowerCoin2 @"Power_Coin3000P" //￥30
#define PowerCoin3 @"PowerCoin_12800P" //￥128
#define PowerCoin4 @"PowerCoin_58800P" //￥588

@interface FTPayViewController : FTRankBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//账户余额

//@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (weak, nonatomic) IBOutlet UICollectionView *colectionView;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
