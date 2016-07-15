//
//  FTGoodsBean.h
//  fighter
//
//  Created by kang on 16/7/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTGoodsBean : FTBaseBean

@property (nonatomic,copy) NSString *goodsId;  // 商品标签
@property (nonatomic,strong) NSDecimalNumber *price;    // 商品价格
@property (nonatomic,copy) NSString *descriptions; // 商品简述，限制长度28
@property (nonatomic,copy) NSString *details;   // 商品详细描述

@property (nonatomic,strong) NSDecimalNumber *power;//商品对Power币

@end
