//
//  FTDrawerCollectionCell.h
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDrawerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *backImg;


@end