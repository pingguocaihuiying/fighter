//
//  FTPracticeView.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPracticeView.h"
#import "FTPracticeCell.h"
#import "FTTeachVideoController.h"

@interface FTPracticeView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *array;


@end

@implementation FTPracticeView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initData];
        [self initSubviews];
    }
    
    return self;
}


- (void) initData {
    
   
    _array =[[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
    
        for ( int i= 0; i < _array.count ; i++) {

        NSDictionary *dic = [_array objectAtIndex:i];
        NSLog(@"dic:%@",dic);
            if ([dic[@"itemValueEn"] isEqualToString:@"Others"] || [dic[@"itemValueEn"] isEqualToString:@"StreetFight"]) {
                    [_array removeObject:dic];
            }
    }
        
   
}

- (void) initSubviews {
    
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
//    //行间距
//    //    flow.minimumLineSpacing = 15 * SCALE;
//    //列间距
//    flow.minimumInteritemSpacing = 10 * SCALE;
//    flow.minimumLineSpacing = 8 * SCALE;
//    
//    float width = 116 * SCALE;
//    float height = 143.5 * SCALE;
//    flow.itemSize = CGSizeMake(width, height);
//    //section内嵌距离设置
//    flow.sectionInset = UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(6, 0, self.frame.size.width-12, self.frame.size.height) collectionViewLayout:flow];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerNib:[UINib nibWithNibName:@"FTPracticeCell" bundle:nil] forCellWithReuseIdentifier:@"practiceCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self addSubview:_collectionView];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FTPracticeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"practiceCell" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor clearColor];

    NSString *imgName = [_array objectAtIndex:indexPath.row][@"itemValueEn"];
    
    if (imgName ) {
        cell.imageView.image = [UIImage imageNamed:imgName];
    }

    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    FTTeachVideoController *videoVC = [[FTTeachVideoController alloc]init];
    videoVC.videoType = [_array objectAtIndex:indexPath.row][@"itemValueEn"];
    videoVC.title = [_array objectAtIndex:indexPath.row][@"itemValue"];
    
    if ([self.delegate performSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:videoVC];
    }
    
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_WIDTH >=375) {
        return (CGSize){115,143.5};
    }
    
    return (CGSize){115*SCREEN_WIDTH/375,143.5*SCREEN_WIDTH/375};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

@end
