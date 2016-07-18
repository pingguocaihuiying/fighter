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
    
//    _array =[[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedTeachVideoCategories]];
    _array = [[NSMutableArray alloc]init];
    [NetWorking getTeachLabelsWithOption:^(NSDictionary *dict) {
        
        NSLog(@"获取教学标签");
        NSLog(@"dict:%@",dict);
        NSLog(@"massage:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        if (dict == nil) {
            return ;
        }
        
        if ([dict[@"status"] isEqualToString:@"success"]) {
            
            for(NSDictionary *dic in dict[@"data"]){
                if ([dic[@"name"] isEqualToString:@"教学视频"]) {
                    NSLog(@"itemValue : %@", dic[@"itemValue"]);
                    NSLog(@"itemValueEn : %@", dic[@"itemValueEn"]);
                    
                    [_array addObject:dic];
                }
            }
            
            
        }
        [self.collectionView reloadData];
    }];
    
}

- (void) initSubviews {
    
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
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
    
    NSLog(@"didSelec");
    FTTeachVideoController *videoVC = [[FTTeachVideoController alloc]init];
    videoVC.videoType = [_array objectAtIndex:indexPath.row][@"itemValueEn"];
    videoVC.title = [_array objectAtIndex:indexPath.row][@"itemValue"];
    
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:videoVC];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH -12 -16)/3;
    height = width/116 *143.5;
    
    return CGSizeMake(width, height);
//    if (SCREEN_WIDTH >=375) {
//        return (CGSize){115,143.5};
//    }
//    
//    return (CGSize){115*SCREEN_WIDTH/375,143.5*SCREEN_WIDTH/375};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}
//设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
}

@end
