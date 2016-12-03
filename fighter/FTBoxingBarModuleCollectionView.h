//
//  FTBoxingBarModuleCollectionView.h
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

@protocol FTCollectionViewDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>

@interface FTBoxingBarModuleCollectionView : UIView

@property (nonatomic, weak) id<FTCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *moduleBeanArray;//存储版块的数组


/**
 根据获取的数据配置数据源

 @param moduleBeanArray 分好组的版块
 */
- (void)setWithData:(NSMutableArray *)moduleBeanArray;
@end
