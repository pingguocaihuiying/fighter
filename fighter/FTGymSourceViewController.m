//
//  FTGymSourceViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymSourceViewController.h"
#import "FTCoachBigImageCollectionViewCell.h"
#import "FTGymSourceView.h"
#import "FTJoinGymSuccessAlertView.h"
#import "FTGymOrderCourseView.h"
#import "FTOrderCoachViewController.h"
#import "FTCoachSelfCourseViewController.h"

@interface FTGymSourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, FTGymCourseTableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;//动态label:余额的值
@property (strong, nonatomic) IBOutlet UILabel *yuanLabel;//固定label：『元』

//collectionView的一些约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeftMargin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewRightMargin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;//教练的collectionView

//分割线
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;


@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view

@property (nonatomic, strong) FTGymSourceView *gymSourceView;//课程表

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况

@end

@implementation FTGymSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self setSubViews];
    [self getTimeSection];//获取拳馆时间段配置
}

- (void)initBaseConfig{
//    _placesUsingInfoDic = [NSMutableDictionary new];
    //key为周几（数字类型），value为数组，存储那一天的课程信息
//    for (int i = 0; i < 6; i++) {
//       [_placesUsingInfoDic setObject:[NSMutableArray new] forKey:[NSString stringWithFormat:@"%ld", [FTTools getWeekdayOfTodayAfterToday:i]]];
//    }

}

- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setCollectionView];//设置教练模块的view
    [self setGymSourceView];
}

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    
    //自定义一些label、分割线（view）的颜色
    _balanceLabel.textColor = Custom_Red;
    _yuanLabel.textColor = Custom_Red;
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;

}

- (void)setNaviView{
    
    //设置默认标题
    self.navigationItem.title = _gymDetailBean.gym_name;
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
        UIBarButtonItem *gymDetailButton = [[UIBarButtonItem alloc]initWithTitle:@"拳馆详情" style:UIBarButtonItemStylePlain target:self action:@selector(gotoGymDetail)];
        self.navigationItem.rightBarButtonItem = gymDetailButton;
}

- (void)backBtnAction:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCollectionView{
    
    //根据设备调整左右间距
    _collectionViewLeftMargin.constant *= SCALE;
    _collectionViewRightMargin.constant *= SCALE;
    
    
    //设置layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //item宽、高、行间距
    CGFloat itemWidth = 64 * SCALE;
    CGFloat itemHeight = 64 * SCALE + 8 + 14;
    CGFloat lineSpacing = 15 * SCALE;
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);//cell大小
    flowLayout.minimumLineSpacing = lineSpacing;//行间距
    flowLayout.minimumInteritemSpacing = 29 * SCALE;//列间距
    _collectionView.collectionViewLayout = flowLayout;
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //加载cell用于复用
    [_collectionView registerNib:[UINib nibWithNibName:@"FTCoachBigImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    //根据数据源个数，计算collectionView的高度（这段代码应该放在获取数据源之后）
    NSInteger count = 8;//cell总数
    NSInteger line = 0;//行数
    NSInteger numberPerLine = 4;//每行cell数
    if(count % numberPerLine == 0){
        line = count / numberPerLine;
    }else if (count % numberPerLine > 0){
        line = count / numberPerLine + 1;
    }
    _collectionViewHeight.constant = line * itemHeight + (line - 1) * lineSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个", indexPath.row);
    FTOrderCoachViewController *orderCoachViewController = [FTOrderCoachViewController new];
    [self.navigationController pushViewController:orderCoachViewController animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTCoachBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)setGymSourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    _gymSourceView.courseType = FTOrderCourseTypeGym;
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];

}
- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *)timeSection{
    NSLog(@"day : %ld, timeSection : %@", day, timeSection);
    if (courseCell.hasOrder) {
        NSLog(@"已经预约");

    } else if (courseCell.canOrder) {
        FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
        gymOrderCourseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        gymOrderCourseView.belowView2.hidden = YES;
//        gymOrderCourseView.belowView2Height.constant = 0;
        gymOrderCourseView.status = FTGymCourseStatusCanOrder;
        [[[UIApplication sharedApplication] keyWindow] addSubview:gymOrderCourseView];
        NSLog(@"可以预约");
    }else {
        NSLog(@"不可以预约");
    }
}
/**
 *  获取时间段信息
 */
- (void)getTimeSection{
//    _gymDetailBean.corporationid = 158;
    [NetWorking getGymTimeSlotsById:[NSString stringWithFormat:@"%d", _gymDetailBean.corporationid] andOption:^(NSArray *array) {
        _timeSectionsArray = array;
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            //获取时间段信息后，根据内容多少设置tableviews的高度，再刷新一次tableview
            _gymSourceView.timeSectionsArray = _timeSectionsArray;
            _gymSourceView.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
            [self gettimeSectionsUsingInfo];
        }
        
    }];
}

//获取场地使用信息
- (void)gettimeSectionsUsingInfo{
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970]];
    
    [NetWorking getGymSourceInfoById:[NSString stringWithFormat:@"%d", _gymDetailBean.corporationid]  andTimestamp:timestampString  andOption:^(NSArray *array) {
        _placesUsingInfoDic = [NSMutableDictionary new];
        if (array) {
            for(NSDictionary *dic in array){
                NSString *theDate = [NSString stringWithFormat:@"%@", dic[@"theDate"]];//周几
                NSMutableArray *mArray = _placesUsingInfoDic[theDate];
                if(!mArray){
                    mArray = [NSMutableArray new];
                    [_placesUsingInfoDic setValue:mArray forKey:theDate];
                }
                [mArray addObject:dic];
            }
            //获取场地使用信息后，刷新UI
            _gymSourceView.placesUsingInfoDic = _placesUsingInfoDic;
            [_gymSourceView reloadTableViews];
        }
    }];
}

- (void)gotoGymDetail{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
