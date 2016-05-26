//
//  FTSlideTabBar.h
//  fighter
//
//  Created by kang on 16/5/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTSlideTabBar : UIView

@property (nonatomic, assign) NSInteger tabCount;

//@brife 整个视图的大小
//@property (assign) CGRect mViewFrame;

//@brife 下方SliferView 宽度
@property (assign) CGFloat sliderW;

//@brife 下方SliferView 高度
@property (assign) CGFloat sliderH;



//@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

//@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;



//@brife 上方的按钮数组
@property (strong, nonatomic) NSArray *btnTitles;

//@brife 下方的滑动view数组
@property (strong, nonatomic) NSArray *scrollViews;


//@brife 当前选中页数
@property (assign) NSInteger currentPage;






-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;

@end
