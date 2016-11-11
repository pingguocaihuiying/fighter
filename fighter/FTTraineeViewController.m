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
    if (self.courseType == FTTraineeCourseStateWaiting) {
        FTSchedulePublicBean *courseBean = (FTSchedulePublicBean *)_bean;
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.theDate] forKey:@"date"];
        [dic setObject:userId forKey:@"coachUserId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.timeId] forKey:@"timeId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",courseBean.id] forKey:@"courseId"];
    }else {
        FTCourseHistoryBean *historyBean = (FTCourseHistoryBean *)_bean;
        [dic setObject:[NSString stringWithFormat:@"%@",historyBean.date] forKey:@"date"];
        [dic setObject:userId forKey:@"coachUserId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",historyBean.timeId] forKey:@"timeId"];
        [dic setObject:[NSString stringWithFormat:@"%ld",historyBean.id] forKey:@"courseId"];
    }
    

    if (self.courseType == FTCoachCourseTypePublic) {
        [dic setObject:@"0" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }else if(self.courseType == FTCoachCourseTypePersonal){
        [dic setObject:@"2" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }else {
         [dic setObject:@"2" forKey:@"type"];//课程类型，0-团课，2-私教,3-其他
    }
    
    [NetWorking getTraineeListWith:dic option:^(NSDictionary *dict) {
        NSLog(@"dic:%@",dict);
        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (!dict) {
            return;
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"]?YES:NO;
        if (status) {
            self.dataArray = dict[@"data"];
            [self setCollectionViewHeight:self.dataArray.count];
        }
    }];
    //团课必填
    
    //私课必填
    
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
        if (self.courseType == FTTraineeCourseStateWaiting) {
            FTSchedulePublicBean *courseBean = (FTSchedulePublicBean *)_bean;
            headerView.timeSectionLabel.text = courseBean.timeSection;
            headerView.dateLabel.text = [NSString stringWithFormat:@"%ld",courseBean.theDate];
            headerView.courseLabel.text = courseBean.courseName;
            headerView.memberLabel.text = [NSString stringWithFormat:@"%ld/%ld",courseBean.hasOrderCount,courseBean.topLimit];
            
        }else {
            FTCourseHistoryBean *historyBean = (FTCourseHistoryBean *)_bean;
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
    
//    FTTraineeBean *bean = [[FTTraineeBean alloc] initWithFTTraineeBeanDic:[self.dataArray objectAtIndex:indexPath.row]];
//    if ([bean.sex isEqualToString:@"男性"]) {
//        
//        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage: [UIImage imageNamed:@"学员头像-无头像男"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                cell.avatarMaskImageView.image = [UIImage imageNamed:@"学员头像-有头像男"];
//            }
//        }];
//        
//    }else {
//        
//        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage: [UIImage imageNamed:@"学员头像-无头像女"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                cell.avatarMaskImageView.image = [UIImage imageNamed:@"学员头像-有头像女"];
//            }
//        }];
//    }
//    cell.nameLabel.text = bean.createName;
//    
//    
//    if (self.courseState == FTTraineeCourseStateComplete) {
//        cell.markImageView.hidden = YES;
//        if (bean.signStatus) {
//            cell.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-旷课"];
//        }else {
//            if (bean.hasGrade == 0) {
//                cell.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-未评分"];
//            }else {
//                cell.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-已评分"];
//            }
//        }
//    }else {
//        cell.traineeStateImageView.hidden = YES;
//        if (bean.newMember == 0) {
//            cell.markImageView.hidden = YES;
//        }
//    }
    
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
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    
    FTHomepageMainViewController *homepageViewController = [FTHomepageMainViewController new];
    homepageViewController.olduserid = userId;
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:homepageViewController];
    baseNav.navigationBarHidden = NO;
    
    [self presentViewController:baseNav animated:YES completion:nil];
    
}

@end
