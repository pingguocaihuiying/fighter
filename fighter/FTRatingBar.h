//
//  RatingBar.h
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  星级评分条代理
 */
@protocol RatingBarDelegate <NSObject>

/**
 *  评分改变
 *
 *  @param newRating 新的值
 */
- (void)ratingChanged:(float)newRating;

@end

@interface FTRatingBar : UIView

@property (nonatomic,strong) UIImage *unSelectedImage;
@property (nonatomic,strong) UIImage *halfSelectedImage;
@property (nonatomic,strong) UIImage *fullSelectedImage;
@property (nonatomic, weak) id<RatingBarDelegate> delegate;
@property (assign) CGFloat rating;

/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
- (void)displayRating:(float)rating;

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
- (CGFloat)rating;

/**
 *  是否是指示器，如果是指示器，就不能滑动了，只显示结果，不是指示器的话就能滑动修改值
 *  默认为NO
 */
@property (nonatomic,assign) BOOL isIndicator;

@end
