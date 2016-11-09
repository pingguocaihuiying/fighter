//
//  FTCourseViewController.m
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeViewController.h"
#import "FTTraineeCell.h"
#import "FTTraineeHeaderView.h"
#import "FTCollectionFowLaytout.h"
#import "FTTraineeCollectionFowLaytout.h"
#import "FTTraineeSkillViewController.h"

@interface FTTraineeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;

@property (copy, nonatomic) NSArray *dataArray;

@end

@implementation FTTraineeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self setSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (NSArray *) dataArray {

    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

#pragma mark  - 设置
- (void) setSubviews {
    
    [self setCollectionView];
    [self pullDataFromWebServer];
}


/**
 设置到导航栏样式
 */
- (void) setNavigationbar {
    self.title = @"我的课程";
    
//    //设置左侧按钮
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
//                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                   style:UIBarButtonItemStyleDone
//                                   target:self
//                                   action:@selector(backBtnAction:)];
//    //把左边的返回按钮左移
//    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    self.navigationItem.leftBarButtonItem = leftButton;
//    
//    //导航栏右侧按钮
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"个人中心"
//                                                                      style:UIBarButtonItemStyleDone
//                                                                     target:self
//                                                                     action:@selector(gotoHomePage:)];
//    
//    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    self.navigationItem.leftBarButtonItem = rightBarButton;

}


/**
 设置 collection View
 */
- (void) setCollectionView {
    
    FTTraineeCollectionFowLaytout *layout = [FTTraineeCollectionFowLaytout new];
    layout.headerItemSpace = 20*SCALE;
    self.collectionView.collectionViewLayout =layout;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FTTraineeCell" bundle:nil] forCellWithReuseIdentifier:@"TraineeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FTTraineeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
}

#pragma mark  - pull data from web 
- (void) pullDataFromWebServer {
    
    [self setCollectionViewHeight:15];
}

- (void) setCollectionViewHeight:(NSInteger)count {

    CGFloat height = 50 + ceil(count/4.0f) *(85 * SCALE +20* SCALE) + 20* SCALE;
    if (height <= SCREEN_HEIGHT - 64) {
        self.collectionHeightConstraint.constant = height;
    }else {
        self.collectionHeightConstraint.constant = SCREEN_HEIGHT - 64;
    }
}

#pragma mark  - delegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return _dataArray.count;
    return 15;
}



/**
 section headerView

 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader){
        
        FTTraineeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        return headerView;
    }
    
    return nil;
}



- (__kindof UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FTTraineeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TraineeCell" forIndexPath:indexPath];
    cell.avatarImageView.image = [UIImage imageNamed:@"学员头像-无头像男"];
    cell.nameLabel.text = @"traineeName";
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeSkillViewController *skillVC = [[FTTraineeSkillViewController alloc]init];
    [self.navigationController pushViewController:skillVC animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = 66 * SCALE;
    float height = 85 * SCALE;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20*SCALE, 24 * SCALE, 20*SCALE, 24 * SCALE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20* SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16 * SCALE;;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH , 50);
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    return CGSizeMake(SCREEN_WIDTH , 20);
//}

#pragma mark - response 

- (void) gotoHomePage:(id) sender {

}

@end
