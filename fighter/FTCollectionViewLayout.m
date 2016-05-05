//
//  FTCollectionViewLayout.m
//  fighter
//
//  Created by kang on 16/4/29.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCollectionViewLayout.h"

@interface FTCollectionViewLayout()

/** 计算每个item高度的block，必须实现*/
@property (nonatomic, copy) SizeBlock block;

/** 存放元素高宽的键值对 */
@property (nonatomic, strong) NSMutableArray *arrOfSize;
/**存放所有item的attrubutes属性 */
@property (nonatomic, strong) NSMutableArray *array;
/**存放所有section的高度的 */
@property (nonatomic, strong) NSMutableArray *arrOfSectionHeight;

/**总section高度,用于直接输出contentSize */
@property (nonatomic,assign) CGFloat collectionSizeHeight;
/**总共item个数 */
@property (nonatomic,assign) NSInteger itemCount;

@property (nonatomic,assign) CGFloat collectionWidth;

@end

@implementation FTCollectionViewLayout


@end
