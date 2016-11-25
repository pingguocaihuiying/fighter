//
//  FTBoxingBarModuleCollectionView.m
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBoxingBarModuleCollectionView.h"
#import "FTModuleCollectionReusableView.h"

@interface FTBoxingBarModuleCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FTBoxingBarModuleCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSebViews];
        return self;
    } else {
        return nil;
    }
}



- (void)initSebViews{
    
#warning 测试用
    /*
        初始化一些数据配置，测试用
     */
    _array = [[NSMutableArray alloc]initWithArray:@[@1,@1,@1,@1]];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    if (SCREEN_WIDTH == 320) {
        flowLayout.itemSize = CGSizeMake(176 * SCALE, 80 * SCALE);
        flowLayout.sectionInset = UIEdgeInsetsMake(10 * SCALE, 8 * SCALE, 10 * SCALE, 8 * SCALE);
        flowLayout.minimumInteritemSpacing = 7 * SCALE;
        flowLayout.minimumLineSpacing = 10 * SCALE;
    } else {
        flowLayout.itemSize = CGSizeMake(176, 80);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
        flowLayout.minimumInteritemSpacing = 7;
        flowLayout.minimumLineSpacing = 10;
    }
    

    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[FTModuleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"FTModuleCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREEN_WIDTH, 30};
    return size;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 6;
    if([_array[section] isEqual:@1]){
        return 5;
    }else{
        return 0;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.backgroundColor = Cell_Space_Color;
        
        UIButton *rightButton;
        
        //*先看是否button已经存在
        for (UIView *view in [headerView subviews]){
            if(view.tag >= 10000){
                rightButton = (UIButton *)view;
                break;
            }
        }
        
        
        
        //如果不存在，创建添加
        if (!rightButton) {
            rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 30, 30)];
            [rightButton addTarget:self action:@selector(rightArrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
        }
        
        rightButton.tag = 10000 + indexPath.section;//添加最新的tag
        
        //设置显示的图片
        NSNumber *number = _array[indexPath.section];
        [rightButton setImage:[UIImage imageNamed:[number  isEqual: @1] ? @"展开收起箭头-下" : @"展开收起箭头-右"] forState:UIControlStateNormal];
        [headerView addSubview:rightButton];
        
        return headerView;
    }
    return nil;
}

- (void)rightArrowButtonClicked:(UIButton *)button{
    NSLog(@"button tag : %ld", button.tag);
    NSNumber *number = _array[button.tag - 10000];
    _array[button.tag - 10000] = [number isEqual:@1] ? @0 : @1;
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 10000]];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
