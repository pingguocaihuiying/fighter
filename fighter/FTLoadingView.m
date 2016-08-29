//
//  FTLoadingView.m
//  fighter
//
//  Created by 李懿哲 on 8/25/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTLoadingView.h"

@interface FTLoadingView()

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIImageView *loadingBgImageView;

@end

@implementation FTLoadingView

- (instancetype)init{
    if (self = [super init ]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //背景框imageview
    _loadingBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading背景"]];
    //    _loadingBgImageView.frame = CGRectMake(20, 100, 100, 100);
    _loadingBgImageView.center = CGPointMake(self.center.x, self.center.y - 64);
    [self addSubview:_loadingBgImageView];
    //声明数组，用来存储所有动画图片
    _loadingImageView = [UIImageView new];
    _loadingImageView.frame = CGRectMake(10, 10, 80, 80);
    
    [_loadingBgImageView addSubview:_loadingImageView];//把用于显示动画的imageview放入背景框中
    //初始化数组
    NSMutableArray *photoArray = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        //获取图片名称
        NSString *photoName = [NSString stringWithFormat:@"格斗家-loading2000%d", i];
        //获取UIImage
        UIImage *image = [UIImage imageNamed:photoName];
        //把图片加载到数组中
        [photoArray addObject:image];
    }
    //给动画数组赋值
    _loadingImageView.animationImages = photoArray;
    
    //一组动画使用的总时间长度
    _loadingImageView.animationDuration = 1;
    
    //设置循环次数。0表示不限制
    _loadingImageView.animationRepeatCount = 0;
    [_loadingImageView startAnimating];
}

@end
