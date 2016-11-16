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
#import "FTTraineeBean.h"
#import "FTCourseBean.h"
#import "FTSchedulePublicBean.h"
#import "FTHomepageMainViewController.h"
#import "FTBaseNavigationViewController.h"

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
    
    FTUserBean *loginuser = [FTUserBean loginUser];
    NSString *userId = loginuser.olduserid;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (self.courseState == FTCourseStateWaiting) {
        FTSchedulePublicBean *courseBean = (FTSchedulePublicBean *)_bean;
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.timestamp] forKey:@"date"];
        [dic setObject:userId forKey:@"coachUserId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.timeId] forKey:@"timeId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.courseId] forKey:@"courseId"];
    }else {
        FTHistoryCourseBean *historyBean = (FTHistoryCourseBean *)_bean;
        [dic setObject:[NSString stringWithFormat:@"%ld",historyBean.date] forKey:@"date"];
        [dic setObject:userId forKey:@"coachUserId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",historyBean.timeId] forKey:@"timeId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",historyBean.courseId] forKey:@"courseId"];
    }
    

    if (self.courseType == FTCourseTypePublic) {
        [dic setObject:@"0" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }else if(self.courseType == FTCourseTypePrivate){
        [dic setObject:@"2" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }else {
         [dic setObject:@"2" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }
    
    NSLog(@"dic:%@",dic);
    [NetWorking getTraineeListWith:dic option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (!dict) {
            return;
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"]?YES:NO;
        if (status) {
            self.dataArray = dict[@"data"];
            [self setCollectionViewHeight:self.dataArray.count];
            [self.collectionView reloadData];
        }
    }];
    //团课必填
    
    //私课必填
}

- (void) setCollectionViewHeight:(NSInteger)count {

//    CGFloat height = 50 + ceil(count/4.0f) *(85 * SCALE +20* SCALE) + 20* SCALE;
     CGFloat height = 50 + ceil(count/4.0f) *(85  +20* SCALE) + 20* SCALE;
    if (height <= SCREEN_HEIGHT - 64) {
        self.collectionHeightConstraint.constant = height;
    }else {
        self.collectionHeightConstraint.constant = SCREEN_HEIGHT - 64;
    }
}

#pragma mark  - delegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
//    return 15;
}

/**
 section headerView
 */

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader){
        
        FTTraineeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (self.courseState == FTCourseStateWaiting) {
            FTSchedulePublicBean *courseBean = (FTSchedulePublicBean *)_bean;
            headerView.timeSectionLabel.text = courseBean.timeSection;
            headerView.dateLabel.text = courseBean.dateString;
            headerView.courseLabel.text = courseBean.courseName;
            headerView.memberLabel.text = [NSString stringWithFormat:@"%ld/%ld",courseBean.hasOrderCount,courseBean.topLimit];
            
        }else {
            FTHistoryCourseBean *historyBean = (FTHistoryCourseBean *)_bean;
            headerView.timeSectionLabel.text = historyBean.timeSection;
            headerView.dateLabel.text = historyBean.dateString;
            headerView.courseLabel.text = historyBean.name;
            headerView.memberLabel.text = [NSString stringWithFormat:@"%ld/%ld",historyBean.attendCount,historyBean.topLimit];
        }
        
        return headerView;
    }
    
    return nil;
}



- (__kindof UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FTTraineeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TraineeCell" forIndexPath:indexPath];
    FTTraineeBean *bean = [[FTTraineeBean alloc] initWithFTTraineeBeanDic:[self.dataArray objectAtIndex:indexPath.row]];
    [cell setCellWithBean:bean state:self.courseState];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeBean *bean = [[FTTraineeBean alloc] initWithFTTraineeBeanDic:[self.dataArray objectAtIndex:indexPath.row]];
    
        
        if (self.courseState == FTCourseStateWaiting) {
//            FTSchedulePublicBean *courseBean = (FTSchedulePublicBean *)_bean;
            FTHomepageMainViewController *homepageViewController = [FTHomepageMainViewController new];
            homepageViewController.olduserid = bean.userId;
            [self.navigationController pushViewController:homepageViewController animated:YES];
            
        }else  if (self.courseState == FTCourseStateDone){
            if (bean.signStatus != 0 && bean.hasGrade != 0) {
                // 旷课和已经评分的不能评分
                FTHistoryCourseBean *historyBean = (FTHistoryCourseBean *)_bean;
                historyBean.createName = bean.createName;
                historyBean.memberUserId = bean.userId;
                historyBean.bookId = bean.id;
                
                FTTraineeSkillViewController *skillVC = [[FTTraineeSkillViewController alloc]init];
                skillVC.bean = historyBean;
                [self.navigationController pushViewController:skillVC animated:YES];
            }
        }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    float width = 66 * SCALE;
//    float height = 85 * SCALE;
    
    float width = 66 ;
    float height = 85 ;
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
    return 16 * SCALE;
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
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    
    FTHomepageMainViewController *homepageViewController = [FTHomepageMainViewController new];
    homepageViewController.olduserid = userId;
    [self.navigationController pushViewController:homepageViewController animated:YES];
    
}

@end
