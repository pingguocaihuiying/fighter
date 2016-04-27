//
//  FTDrawerViewController.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerViewController.h"

@interface FTDrawerViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *interestsArray;
@end

@implementation FTDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    interestsArray = @[@[综合格斗],
//                       @[]]
}

- (void) setSubviews {
    
    UICollectionView *collectionView = [[UICollectionView alloc]init];
    
}



@end
