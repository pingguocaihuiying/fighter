//
//  FTPracticeView.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPracticeView.h"
@interface FTPracticeView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;


@end

@implementation FTPracticeView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    
    return self;
}


- (void) initSubviews {
    
    
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
    flow.minimumLineSpacing = 8;
    //列间距
    flow.minimumInteritemSpacing = 10;
    
    //cell大小设置
    flow.itemSize = CGSizeMake(100, 18);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
}

@end
