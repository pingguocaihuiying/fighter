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
#import "FTGymRechargeViewController.h"
#import "FTBaseNavigationViewController.h"


@interface FTGymSourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, FTGymCourseTableViewDelegate, FTGymOrderCourseViewDelegate>
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

@property (nonatomic, strong) NSArray *coachArray;//教练列表
@property (strong, nonatomic) IBOutlet UILabel *remainingTimesLabel;//团课剩余次数
@property (strong, nonatomic) IBOutlet UILabel *validTimelineLabel;//有效期标签


@end

@implementation FTGymSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self getCoachesOfGymFromServer];//获取该拳馆的教练列表
    [self setSubViews];
    [self getVIPInfo];
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


#pragma mark - response 

- (void)backBtnAction:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rechargeButtonAction:(id)sender {
    
    FTGymRechargeViewController *gymRechargeViewController = [FTGymRechargeViewController new];
    gymRechargeViewController.corporationId = self.gymDetailBean.corporationid;
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:gymRechargeViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}



- (void)getCoachesOfGymFromServer{
    [NetWorking getCoachesWithCorporationid:[NSString stringWithFormat:@"%d", _gymDetailBean.corporationid] andOption:^(NSArray *array) {
        if (array && array.count > 0) {
            _coachArray = array;
            [self setCollectionView];//设置教练模块的view
        }
    }];
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
    NSInteger count = _coachArray.count;//cell总数
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
    orderCoachViewController.gymDetailBean = _gymDetailBean;
    [self.navigationController pushViewController:orderCoachViewController animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _coachArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTCoachBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *coachDic = _coachArray[indexPath.row];
    cell.coachNameLabel.text = coachDic[@"name"];
    [cell.coachImageView sd_setImageWithURL:[NSURL URLWithString:coachDic[@"headUrl"]]];
    return cell;
}

- (void)setGymSourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    _gymSourceView.courseType = FTOrderCourseTypeGym;
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];

}
- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *) timeSection andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp{
    NSLog(@"day : %ld, timeSection : %@ dateString : %@", day, timeSection, dateString);
    
    FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
    gymOrderCourseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gymOrderCourseView.dateString = dateString;
    gymOrderCourseView.dateTimeStamp = timeStamp;
    
    if (courseCell.hasOrder) {
        NSLog(@"已经预约");

        NSDictionary *courseCellDic = courseCell.courserCellDic;
        gymOrderCourseView.courserCellDic = courseCellDic;
        
        gymOrderCourseView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
        gymOrderCourseView.delegate = self;
        gymOrderCourseView.status = FTGymCourseStatusHasOrder;
        [[[UIApplication sharedApplication] keyWindow] addSubview:gymOrderCourseView];

    } else if (courseCell.canOrder) {
        
        
        NSDictionary *courseCellDic = courseCell.courserCellDic;
        gymOrderCourseView.courserCellDic = courseCellDic;
        gymOrderCourseView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
        gymOrderCourseView.delegate = self;
        gymOrderCourseView.status = FTGymCourseStatusCanOrder;
        [[[UIApplication sharedApplication] keyWindow] addSubview:gymOrderCourseView];
        NSLog(@"可以预约");
        

    }else if (courseCell.isFull) {
        
        
        NSDictionary *courseCellDic = courseCell.courserCellDic;
        gymOrderCourseView.courserCellDic = courseCellDic;
        gymOrderCourseView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
        gymOrderCourseView.delegate = self;
        gymOrderCourseView.status = FTGymCourseStatusIsFull;
        [[[UIApplication sharedApplication] keyWindow] addSubview:gymOrderCourseView];
        NSLog(@"满员");
    }else{
        //不能预约（可能因为数据无效等原因）
    }
}

- (void)bookSuccess{
    //预订成功后，刷新课程预订信息
    [self gettimeSectionsUsingInfo];
}


/**
 获取会员信息
 */
- (void)getVIPInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getVIPInfoWithGymId:[NSString stringWithFormat:@"%d", _gymDetailBean.corporationid] andOption:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //无数据：非会员
        //"type"为会员类型： 0准会员 1会员 2往期会员
        
        NSString *status = dic[@"status"];
        NSLog(@"status : %@", status);
        FTGymVIPType gymVIPType;
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            gymVIPType = [type integerValue];
            if (gymVIPType == FTGymVIPTypeYep) {//如果已经是会员，更新会员信息的展示
                [self updateVIPInfoUIWithDic:dic[@"data"]];
            }else if (gymVIPType == FTGymVIPTypeApplying){
                
            }
        }else{
            gymVIPType = FTGymVIPTypeNope;
            
        }
        
    }];
}

- (void)updateVIPInfoUIWithDic:(NSDictionary *)dic{
    
    //团课剩余次数
    NSString *remainingTime = dic[@"remainTime"];
    if (!remainingTime) {
        remainingTime = @"0";
    }
    _remainingTimesLabel.text = [NSString stringWithFormat:@"团课剩余次数：%@次", remainingTime];
    
    //有效期
    NSString *validTimeString = dic[@"expireTime"];
    
    if (validTimeString) {
        NSString *validTime = [FTTools fixStringForDateWithoutTime2:validTimeString];
        _validTimelineLabel.text = [NSString stringWithFormat:@"有效期：%@", validTime];
        
        //如果是320屏幕，把中文的『：』改用『:』达到最简单适配的目的
        if (SCREEN_WIDTH == 320) {
            _validTimelineLabel.text = [NSString stringWithFormat:@"有效期:%@", validTime];
        }
        
    } else {
        _validTimelineLabel.text = [NSString stringWithFormat:@""];
    }
    
    //余额
    NSString *balance = dic[@"money"];
    if (!balance) {
      balance = @"0";
    }
    _balanceLabel.text = balance;
}

/**
 *  获取时间段信息
 */
- (void)getTimeSection{
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
