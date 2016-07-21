//
//  FTPayViewController.h
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankBaseViewController.h"

@interface FTPayViewController : FTRankBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//账户余额

//@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (weak, nonatomic) IBOutlet UICollectionView *colectionView;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
