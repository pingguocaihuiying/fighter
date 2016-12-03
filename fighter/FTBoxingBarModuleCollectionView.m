//
//  FTBoxingBarModuleCollectionView.m
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#define DISPLAY @1

#import "FTBoxingBarModuleCollectionView.h"
#import "FTModuleCollectionReusableView.h"
#import "FTBoxingBarCollectionViewCell.h"

@interface FTBoxingBarModuleCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FTBoxingBarModuleCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        return self;
    } else {
        return nil;
    }
}



- (void)initSubViews{

    [self configSectionDisplayOrNot];
    
    /*
        设置collectionView
     */
        //设置collectionView的flowlayout
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
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册headerView
    [_collectionView registerClass:[FTModuleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"FTBoxingBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self addSubview:_collectionView];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREEN_WIDTH, 30};
    return size;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _moduleBeanArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if([_array[section] isEqual:@1]){
        NSDictionary *dic = _moduleBeanArray[section];
        NSArray *moduleArray = [[dic allValues]firstObject];
        return moduleArray.count;
    }else{
        return 0;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.backgroundColor = Cell_Space_Color;
        
        
        /*
            设置右边的小箭头
         */
        UIButton *rightButton;
        
        //*先根据标签，查找button是否已经存在
        for (UIView *view in [headerView subviews]){
            if(view.tag >= 10000){
                rightButton = (UIButton *)view;
                break;
            }
        }
        //如果不存在，创建，添加点击事件
        if (!rightButton) {
            rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 0, 30, 30)];
            [rightButton addTarget:self action:@selector(rightArrowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
        }
        
        rightButton.tag = 10000 + indexPath.section;//更新的tag
        
        //设置图片
        NSNumber *number = _array[indexPath.section];
        
        [rightButton setImage:[UIImage imageNamed:[number  isEqual: @1] ? @"展开收起箭头-下" : @"展开收起箭头-右"] forState:UIControlStateNormal];
        [headerView addSubview:rightButton];
        
        
        /*
            设置左边的label文字
         */
        UILabel *headerTitleLabel;
        
        //遍历headerView，查找label是否已经存在
        for(UIView *view in [headerView subviews]){
            if ([view isKindOfClass:[UILabel class]]) {
                headerTitleLabel = (UILabel *)view;
                break;
            }
        }
        
        //如果不存在，创建之，并设置通用属性
        if (!headerTitleLabel) {
            headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 9, 200, 12)];
            headerTitleLabel.font = [UIFont systemFontOfSize:12];
            headerTitleLabel.textColor = Nonmal_Text_Color;
        }
        NSDictionary *categoryDic = _moduleBeanArray[indexPath.section];
        headerTitleLabel.text = [categoryDic.allKeys firstObject];
        
        [headerView addSubview:headerTitleLabel];
        
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
    FTBoxingBarCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *categoryDic = _moduleBeanArray[indexPath.section];
    [cell setWithBean:[categoryDic.allValues firstObject][indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)setWithData:(NSMutableArray *)moduleBeanArray{
    _moduleBeanArray = moduleBeanArray;
    [self configSectionDisplayOrNot];
}

- (void)configSectionDisplayOrNot{
    /*
     初始化一些数据配置，测试用
     */
//    _array = [[NSMutableArray alloc]initWithArray:@[@1,@1,@1,@1]];
    _array = [NSMutableArray new];
    for (int i = 0; i < _moduleBeanArray.count; i++) {
        NSNumber *number = [[NSNumber alloc]initWithBool:DISPLAY];
        [_array addObject:number];
    }
}
@end
