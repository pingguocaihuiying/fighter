//
//  FTTraineeCollectionFowLaytout.h
//  fighter
//
//  Created by kang on 2016/11/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTraineeCollectionFowLaytout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat headerItemSpace;// header bottom 和 第一行item top 间距,默认为0
@property (nonatomic, assign) CGFloat collectionHeaderSpace;//  header top与父视图（collection top）间距,默认为0
@end
