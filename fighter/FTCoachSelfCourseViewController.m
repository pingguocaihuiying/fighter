//
//  FTCoachSelfCourseViewController.m
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachSelfCourseViewController.h"
#import "FTGymSourceView.h"
#import "FTCoachHistoryCourseTableViewCell.h"
#import "NSDate+Tool.h"
#import "FTHistoryCourseBean.h"
#import "FTGymCoachStateSwitcher.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "FTGymCourceViewNew.h"
#import "FTPublicHistoryCourseTableViewCell.h"
#import "FTTraineeViewController.h"
#import "FTTraineeSkillViewController.h"
#import "FTCourseHeaderFile.h"

@interface FTCoachSelfCourseViewController ()<FTGymCourseTableViewDelegate, UITableViewDelegate, UITableViewDataSource, FTCoachChangeCourseStatusDelegate>
{
    CGFloat scrollY;
    CGFloat tableY;
    NSSet<UITouch *> *touchSet;
    UIEvent *touchEvent;
}
@property (nonatomic, assign) FTCourseType courseType;
@property (strong, nonatomic) IBOutlet UIView *dividingViewTop;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITableView *historyOrderTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *courseHistoryTableViewHeight;
@property (nonatomic, strong) FTGymSourceView *gymSourceView;//课程表(私教)
@property (nonatomic, strong) FTGymCourceViewNew *gymSourceViewPublic;//课程表(教练的团课)
@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (nonatomic, strong) NSMutableArray *historyArray;//私教课程数据
@property (nonatomic, strong) NSMutableArray *historyArrayPublic;//公开课课程数据

@property (strong, nonatomic) IBOutlet UIButton *publicCourseButton;
@property (strong, nonatomic) IBOutlet UIButton *personalCourseButton;

@property (nonatomic, copy) NSString *userId;

@end

@implementation FTCoachSelfCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registLoginNoti];
    [self initDefaultConfig];
    [self setSubViews];
    [self updateCourseTableDisplay];
}


/**
 注册登录的通知，在新用户登录时刷新
 */
- (void)registLoginNoti{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginCallback:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneLoginedCallback:) name:LoginNoti object:nil];
}

// 微信登录响应
- (void) wxLoginCallback:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
//        _gymSourceViewPublic = nil;
//        _gymSourceView = nil;
        [self updateCourseTableDisplay];
    }
}

// 账号登录响应
- (void) phoneLoginedCallback:(NSNotification *)noti {
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"LOGIN"]) {//退出登录
//        _gymSourceViewPublic = nil;
//        _gymSourceView = nil;
        [self updateCourseTableDisplay];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - 初始化界面
- (void)setSubViews{
    
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setTableview];//设置历史课程的tableView
}


/**
 初始化默认配置：默认展示团课（或私课）
 */

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    _dividingViewTop.backgroundColor = Cell_Space_Color;
}

- (void)setNaviView{
    
    //设置默认标题
    //    self.navigationItem.title = _gymDetailBean.gym_name;
    self.navigationItem.title = @"我的课程";
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *gymDetailButton = [[UIBarButtonItem alloc]initWithTitle:@"个人主页" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCoachHomepage)];
    self.navigationItem.rightBarButtonItem = gymDetailButton;
}


/**
 初始化默认配置：默认展示团课（或私课）
 */
- (void)initDefaultConfig{
    _courseType = FTCourseTypePublic;//默认左侧按钮被点击，显示公开课
//        _coachCourseType = FTCoachCourseTypePersonal;
}




#pragma mark - response
/**
    “我的团课”按钮被点击
 @param sender
 */
- (IBAction)publicCourseButtonClicked:(id)sender {
    _courseType = FTCourseTypePublic;
    [self updateCourseTableDisplay];
}

/**
 “私教课程”按钮被点击
 @param sender
 */
- (IBAction)personalCourseButtonClicked:(id)sender {
    _courseType = FTCourseTypePrivate;
    [self updateCourseTableDisplay];
}


/**
 根据二选按钮的状态，更新要显示的课程表（团课、私教课）
 */
- (void)updateCourseTableDisplay{
    
    if (_courseType == FTCourseTypePublic) {
    //团课
        //清空私教历史课程数据
        [_historyArray removeAllObjects];
        [_historyOrderTableView reloadData];
        
        NSLog(@"更新团课信息");
        //设置按钮的状态
        _publicCourseButton.selected = YES;
        _personalCourseButton.selected = NO;
        [_gymSourceView removeFromSuperview]; //隐藏私教课程表
        [self setPublicCourseView];
        
    } else if(_courseType == FTCourseTypePrivate){
    //私教
        //清空私教历史课程数据
        [_historyArrayPublic removeAllObjects];
        [_historyOrderTableView reloadData];
        
        //设置按钮的状态
        _publicCourseButton.selected = NO;
        _personalCourseButton.selected = YES;
        
        [_gymSourceViewPublic removeFromSuperview];//隐藏公开课view
        [self setPersonalCourseView];

    }
    
}

//设置团课课程表view
- (void)setPublicCourseView{
    [self setGymSourceViewPublic];//设置私教课程表
    [self getTimeSection];//获取时间段信息(成功之后再获取课程内容)
    [self getPublicCourseRecordFromServer];//获取团课课程记录信息
}

//设置私教课程表view
- (void)setPersonalCourseView{
    [self setGymSourceView];//设置私课课程表
    [self getTimeSection];//获取时间段信息(成功之后再获取课程内容)
    [self getTeachRecordFromServer];//获取私教课程记录信息
}

- (void)setGymSourceView{
    
    if (!_gymSourceView) {
        _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    }
    
    _gymSourceView.courseType = FTOrderCourseTypeCoachSelf;
    _gymSourceView.titleLabel.text = [NSString stringWithFormat:@"%d月", [[FTTools getCurrentMonth] intValue]];
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.courseType = FTOrderCourseTypeCoachSelf;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];
//    _gymSourceView.tableViewsHeight.constant = 42 * 4;
    [_gymSourceView reloadTableViews];
}

- (void)setGymSourceViewPublic{
    if (!_gymSourceViewPublic) {
        _gymSourceViewPublic = [[[NSBundle mainBundle]loadNibNamed:@"FTGymCourceViewNew" owner:nil options:nil]firstObject];
        _gymSourceViewPublic.courseType = FTGymPublicCourseTypeForCoach;
    }
    
    //    _gymSourceView.courseType = FTOrderCourseTypeGym;
    _gymSourceViewPublic.frame = _gymSourceViewContainerView.bounds;
    _gymSourceViewPublic.delegate = self;
    
#warning mark -
    __weak typeof(self) weakslef= self;
    _gymSourceViewPublic.pushblock = ^(id bean){
        
        if (weakslef.courseType == FTCourseTypePublic) {

            FTTraineeViewController *traineeListVC = [[FTTraineeViewController alloc]init];
            traineeListVC.courseState = FTCourseStateWaiting;
            traineeListVC.courseType = weakslef.courseType;
            traineeListVC.bean = bean;
            [weakslef.navigationController pushViewController:traineeListVC animated:YES];
        }
        
//        else {
//            FTTraineeSkillViewController *traineeSkillVC = [[FTTraineeSkillViewController alloc]init];
//            //    traineeSkillVC.courseState = FTTraineeCourseStateComplete;
//            //    traineeSkillVC.courseType = _coachCourseType;
//            //    traineeSkillVC.bean = bean;
//            [weakslef.navigationController pushViewController:traineeSkillVC animated:YES];
//        }
    };
    
    [_gymSourceViewContainerView addSubview:_gymSourceViewPublic];
    
}

- (void)setTableview{
    _historyOrderTableView.delegate = self;
    _historyOrderTableView.dataSource = self;
    [_historyOrderTableView registerNib:[UINib nibWithNibName:@"FTCoachHistoryCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];//私教历史课程cell
    [_historyOrderTableView registerNib:[UINib nibWithNibName:@"FTPublicHistoryCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellForPublic"];//公开课历史课程cell
}





#pragma mark - NetWorking

- (void)setJHRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.scrollView.mj_header setHidden:NO];
        
        [weakSelf getTimeSection];
        //        [sself gettimeSectionsUsingInfo];
        [weakSelf getTeachRecordFromServer];
        
        [weakSelf.scrollView.mj_header beginRefreshing];
    }];
}


/**
 *  获取时间段信息
 */
- (void)getTimeSection{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getGymTimeSlotsById:[NSString stringWithFormat:@"%@", _corporationid] andOption:^(NSArray *array) {
        
        BOOL removeHUDSuccess;//是否成功移除，如果成功移除，可能还有其他HUD view，需要再次移除，直到返回false
        removeHUDSuccess = [MBProgressHUD hideHUDForView:self.view animated:YES];
        while (removeHUDSuccess) {
            removeHUDSuccess = [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        _timeSectionsArray = array;
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            //获取时间段信息后，根据内容多少设置tableviews的高度，再刷新一次tableview
            
            if (_courseType == FTCourseTypePublic) {
                _gymSourceViewPublic.timeSectionsArray = _timeSectionsArray;
//                _gymSourceViewPublic.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
                [self getPublicTimeSectionsUsingInfo];
            } else if (_courseType == FTCourseTypePrivate){
                _gymSourceView.timeSectionsArray = _timeSectionsArray;
                _gymSourceView.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
                [self gettimeSectionsUsingInfo];
            }
            

        }
        
    }];
}

//获取私教场地使用信息
- (void)gettimeSectionsUsingInfo{
    
    FTUserBean *localBean = [FTUserTools getLocalUser];
    NSString *userId = localBean.olduserid;//教练的id
    [NetWorking getCoachCourceInfoByCoachId:userId andGymId:[NSString stringWithFormat:@"%@", _corporationid] andOption:^(NSArray *array) {
        
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

//获取团课场地使用信息
- (void)getPublicTimeSectionsUsingInfo{
    
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970]];
    
    [NetWorking getGymSourceInfoById:[NSString stringWithFormat:@"%@", _corporationid]  andTimestamp:timestampString  andOption:^(NSArray *array) {
        
        _placesUsingInfoDic = [NSMutableDictionary new];
        if (array) {
            for(NSDictionary *dic in array){
                NSString *theDate = [NSString stringWithFormat:@"%@", dic[@"theDate"]];//周几
                NSMutableArray *mArray = _placesUsingInfoDic[theDate];
                if(!mArray){
                    mArray = [NSMutableArray new];
                    [_placesUsingInfoDic setValue:mArray forKey:theDate];
                }
                if (!_userId) {
                    FTUserBean *loginedUser = [FTUserBean loginUser];
                    _userId = loginedUser.olduserid;
                }
                if ([_userId isEqualToString:dic[@"coachUserId"]]){//如果是教练自己的课，才存起来
                    [mArray addObject:dic];
                }
            }
            //获取场地使用信息后，刷新UI
            _gymSourceViewPublic.placesUsingInfoDic = _placesUsingInfoDic;
            [_gymSourceViewPublic reloadTableViews];
        }
    }];
}


/**
 获取公开课历史课程记录
 */
- (void)getPublicCourseRecordFromServer{
    NSLog(@"**************获取公开课历史课程记录*****************");
    [NetWorking getCoachTeachRecordWithCorporationid:self.corporationid andCourseType:@"0" option:^(NSDictionary *dict) {
        
        SLog(@"dict:%@",dict);
        BOOL status = [dict[@"status"] isEqualToString:@"success"]? YES:NO;
        if (status) {
            NSArray *arrayTemp = dict[@"data"];
            
            //测试用，给array赋值
//            arrayTemp = [self setTempArray];
            
            [self sortArray:arrayTemp];
            
            [self.historyOrderTableView reloadData];
        }
        
        [self.scrollView.mj_header endRefreshing];
    }];
}


- (NSArray *)setTempArray{
    NSDictionary *dic = @{
        @"id": @33,
        @"name": @"格斗之夜",
        @"createName": @"李懿哲",
        @"createTime": @1472659200000,
        @"updateName": @"李懿哲",
        @"updateTime": @1472659200000,
        @"createTimeTamp": @"1472659200000",
        @"updateTimeTamp": @"1472659200000",
        @"courseId": @94,
        @"date": @1472659200000,
        @"timeId": @44,
        @"placeId": @0,
        @"coachUserId": @"4c364ca3120d4a01a2766f155c55cc3d",
        @"hasOrderCount": @2,
        @"topLimit" : @10,
        @"hasGradeCount" : @"1",
        @"attendCount" : @"2",
        @"statu": @1,
        @"type": @"0",
        @"corporationid": @187,
        @"label": @"拳击",
        @"timeSection": @"11:10~12:00"
    };
    NSDictionary *dic2 = @{
                          @"id": @33,
                          @"name": @"格斗入门",
                          @"createName": @"茂凯",
                          @"createTime": @1478142181000,
                          @"updateName": @"李懿哲",
                          @"updateTime": @1478142181000,
                          @"createTimeTamp": @"1478142181000",
                          @"updateTimeTamp": @"1478142181000",
                          @"courseId": @94,
                          @"date": @1478142600000,
                          @"timeId": @44,
                          @"placeId": @0,
                          @"coachUserId": @"4c364ca3120d4a01a2766f155c55cc3d",
                          @"hasOrderCount": @1,
                          @"statu": @1,
                          @"type": @"0",
                          @"corporationid": @187,
                          @"label": @"拳击",
                          @"attendCount" : @"1",
                          @"hasGradeCount" : @1,
                          @"timeSection": @"11:10~12:00"
                          };
    NSDictionary *dic3 = @{
                          @"id": @33,
                          @"name": @"柔术从入门到精通",
                          @"createName": @"李懿哲",
                          @"createTime": @1422903722000,
                          @"updateName": @"李懿哲",
                          @"updateTime": @1422903722000,
                          @"createTimeTamp": @"1478142181000",
                          @"updateTimeTamp": @"1478142181000",
                          @"courseId": @94,
                          @"date": @1422903722000,
                          @"timeId": @44,
                          @"placeId": @0,
                          @"coachUserId": @"4c364ca3120d4a01a2766f155c55cc3d",
                          @"hasOrderCount": @1,
                          @"statu": @1,
                          @"type": @"0",
                          @"corporationid": @187,
                          @"label": @"拳击",
                          @"timeSection": @"11:10~12:00"
                          };
    
    NSArray *array = [[NSArray alloc]initWithObjects:dic, dic2, dic3, nil ];
    
    return array;
}

/**
 获取私教的历史课程记录
 */
- (void) getTeachRecordFromServer {
    
    [NetWorking getCoachTeachRecordWithCorporationid:self.corporationid andCourseType:@"2" option:^(NSDictionary *dict) {
        
        SLog(@"dict:%@",dict);
        BOOL status = [dict[@"status"] isEqualToString:@"success"]? YES:NO;
        if (status) {
            NSArray *arrayTemp = dict[@"data"];
            
            //测试用，给array赋值
//            arrayTemp = [self setTempArray];

            
            [self sortArray:arrayTemp];
            
            [self.historyOrderTableView reloadData];
        }
        
        [self.scrollView.mj_header endRefreshing];
    }];
}




/**
 历史课程排序分组

 @param tempArray 历史课程字典数组
 */
- (void) sortArray:(NSArray *)tempArray {
    
    if (_courseType == FTCourseTypePublic) {//公开课
        if (!_historyArrayPublic) {
            _historyArrayPublic = [[NSMutableArray alloc]init];
        }
        [_historyArrayPublic removeAllObjects];
    } else {//私教
        if (!_historyArray) {
            _historyArray = [[NSMutableArray alloc]init];
        }
        [_historyArray removeAllObjects];
    }
    

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in tempArray) {
        
        FTHistoryCourseBean *bean = [[FTHistoryCourseBean alloc]initWithFTHistoryCourseBeanDic:dic];
        NSString *currentYearMonthString = [NSDate currentYearString];

        NSLog(@"date:%.0f",bean.date);
        NSString *date = [NSString stringWithFormat:@"%.0f",bean.date];

        NSString *yearString = [NSDate yearString:date];

        if ([yearString isEqualToString:currentYearMonthString]) {
            bean.dateString = [NSDate monthDayStringWithWordSpace:date];
        }else {
            bean.dateString = [NSDate dateStringWithWordSpace:date];
        }
        
        NSString *dateString = _courseType == FTCourseTypePublic ? [NSDate dateStringWithWordSpace:date] : [NSDate dateStringWithYearMonth:date];
        NSLog(@"dateString:%@",dateString);
        if ([dict.allKeys containsObject:dateString]) {
            NSMutableArray *array = [dict objectForKey:dateString];
            [array addObject:bean];
            
        }else {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:bean];
            [_courseType == FTCourseTypePublic ? _historyArrayPublic : _historyArray addObject:array];
            [dict setObject:array forKey:dateString];
        }
        

    }
}

#pragma mark - delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _courseType == FTCourseTypePublic ? _historyArrayPublic.count : _historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array =(_courseType == FTCourseTypePublic ? _historyArrayPublic : _historyArray)[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_courseType == FTCourseTypePublic) {//团课
        
        FTPublicHistoryCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForPublic"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FTHistoryCourseBean *bean = _historyArrayPublic[indexPath.section][indexPath.row];
        [cell setWithCourseHistoryBean:bean];
        return cell;
        
    }else{//如果当前展示的是私教课
        
        FTHistoryCourseBean *bean = _historyArray[indexPath.section][indexPath.row];
        FTCoachHistoryCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    FTCourseHistoryBean *bean = _historyArray[0][indexPath.row];
        [cell setWithCourseHistoryBean:bean];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    id bean = ((_courseType == FTCourseTypePublic) ? _historyArrayPublic : _historyArray )[indexPath.section][indexPath.row];
//    NSLog(@"课程bean:%@", bean);
    
    if (_courseType == FTCourseTypePublic) {
    
        FTHistoryCourseBean *bean = _historyArrayPublic[indexPath.section][indexPath.row];
        
        FTTraineeViewController *traineeListVC = [[FTTraineeViewController alloc]init];
        traineeListVC.courseState = FTCourseStateDone;
        traineeListVC.courseType = _courseType;
        traineeListVC.bean = bean;
        [self.navigationController pushViewController:traineeListVC animated:YES];
    }else {
        
        FTHistoryCourseBean *bean = _historyArray[indexPath.section][indexPath.row];
        if (bean.attendCount == 0) {
            return; // 旷课不能评分
        }
        FTTraineeSkillViewController *traineeSkillVC = [[FTTraineeSkillViewController alloc]init];
//        traineeSkillVC.courseState = FTCourseStateDone;
//        traineeSkillVC.courseType = _courseType;
        traineeSkillVC.bean = bean;
        [self.navigationController pushViewController:traineeSkillVC animated:YES];
    }

}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithHex:0x282828];
    headerView.frame = CGRectMake(0, 0, tableView.width, 20);
    
    //
//    //下半部view
//    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//    contentView.backgroundColor = [UIColor colorWithHex:0x282828];
//    [headerView addSubview:contentView];
    
    if (_courseType == FTCourseTypePublic) {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 150, 12)];
        label1.textColor = [UIColor colorWithHex:0xb4b4b4];
        label1.font = [UIFont systemFontOfSize:12];
        FTHistoryCourseBean *bean = [_historyArrayPublic[section] firstObject];
        NSString *beanDate = [NSString stringWithFormat:@"%.0f",bean.date];
        NSLog(@"beanFoo: %@", beanDate);
        
        NSString *currentYearString = [NSDate currentYearString];
        NSString *yearString = [NSDate yearString:beanDate];
        
        NSString *date = @"";
        if ([yearString isEqualToString:currentYearString]) {
            date = [NSDate monthDayStringWithWordSpace:beanDate];
        }else {
            date = [NSDate dateStringWithWordSpace:beanDate];
        }
        
        label1.text = date;
        [headerView addSubview:label1];
    } else {
        FTHistoryCourseBean *bean = [_historyArray[section] firstObject];
        NSString *beanDate = [NSString stringWithFormat:@"%.0f",bean.date];
        NSString *currentYearMonthString = [NSDate currentYearMonthString2];
        NSString *yearMonthString = [NSDate dateStringWithYearMonth:beanDate];
        
        NSString *currentMonthString = [NSDate currentMonthString];
        NSString *monthString = [NSDate monthString:beanDate];
        
        NSString *date = @"";
        UILabel *label1;
        if ([yearMonthString isEqualToString:currentYearMonthString]) {
            if ([monthString isEqualToString:currentMonthString]) {
                    date = @"本月完成课程";
            } else {
                date = [NSString stringWithFormat:@"%@月完成课程", monthString];
            }
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 75, 12)];
        }else {
            date = [NSString stringWithFormat:@"%@完成课程", yearMonthString];
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 120, 12)];
        }
        
        label1.textColor = [UIColor colorWithHex:0xb4b4b4];
        label1.font = [UIFont systemFontOfSize:12];
        label1.text = date;
        [headerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.width, 4, 50, 12)];
        label2.textColor = [UIColor colorWithHex:0xb4b4b4];
        label2.text = [NSString stringWithFormat:@"%ld节", [_historyArray[section] count] ];
        label2.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:label2];
    }
    

    
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.frame = CGRectMake(0, 0, tableView.width, 20);
    
    return  footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}


#pragma mark - scorllView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//
//    scrollY = self.scrollView.contentOffset.y;
//    tableY = self.historyOrderTableView.contentOffset.y;
//    
//    if (scrollView == self.historyOrderTableView) {
//        NSLog(@"offSetY:%f",scrollView.contentOffset.y);
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    if (scrollView == self.historyOrderTableView) {
//        NSLog(@"offSetY:%f",scrollView.contentOffset.y);
//        if (offsetY > tableY) {//向上
//            if (scrollY < self.tableViewHeight.constant +20.0) {
//                
//                [self.historyOrderTableView touchesCancelled:touchSet withEvent:touchEvent];
//                return;
//            }
//            
//        }else {
//        
//            
//        }
//    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

//    if (scrollView == self.scrollView) {
//        NSLog(@"offSetY:%f",scrollView.contentOffset.y);
//    }
}

#pragma mark - response

- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSectionIndex:(NSInteger) timeSectionIndex andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp{
    NSLog(@"day : %ld, timeSection : %@ dateString : %@", day, _timeSectionsArray[timeSectionIndex][@"timeSection"], dateString);
    
    if (courseCell.isEmpty) {//如果是空的，说明可以预约
        NSLog(@"可以预约");
        FTGymCoachStateSwitcher *gymCoachStateSwitcher = [[[NSBundle mainBundle]loadNibNamed:@"FTGymCoachStateSwitcher" owner:nil options:nil]firstObject];
        gymCoachStateSwitcher.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
        gymCoachStateSwitcher.delegate = self;
        gymCoachStateSwitcher.canOrderOriginal = YES;
        gymCoachStateSwitcher.canOrder = YES;
        
        gymCoachStateSwitcher.timeSection = _timeSectionsArray[timeSectionIndex][@"timeSection"];
        gymCoachStateSwitcher.timeSectionId = _timeSectionsArray[timeSectionIndex][@"id"];
        gymCoachStateSwitcher.dateString = dateString;
        gymCoachStateSwitcher.dateTimeStamp = timeStamp;
        gymCoachStateSwitcher.corporationid = _corporationid;
        
        [gymCoachStateSwitcher updateDisplay];
        
        [self.view addSubview:gymCoachStateSwitcher];
        
    }else{
        NSDictionary *courseDic = courseCell.courserCellDic;
        NSString *type = courseDic[@"type"];
        
        if ([type isEqualToString:@"3"]) {//如果不可约
            NSLog(@"不可预约");
            FTGymCoachStateSwitcher *gymCoachStateSwitcher = [[[NSBundle mainBundle]loadNibNamed:@"FTGymCoachStateSwitcher" owner:nil options:nil]firstObject];
            gymCoachStateSwitcher.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
            gymCoachStateSwitcher.delegate = self;
            gymCoachStateSwitcher.canOrderOriginal = NO;
            gymCoachStateSwitcher.canOrder = NO;
            
            gymCoachStateSwitcher.timeSection = _timeSectionsArray[timeSectionIndex][@"timeSection"];
            gymCoachStateSwitcher.timeSectionId = _timeSectionsArray[timeSectionIndex][@"id"];
            gymCoachStateSwitcher.dateString = dateString;
            gymCoachStateSwitcher.dateTimeStamp = timeStamp;
            gymCoachStateSwitcher.corporationid = _corporationid;
            
            [gymCoachStateSwitcher updateDisplay];
            
            [self.view addSubview:gymCoachStateSwitcher];
        } else {//如果已约
            
        }
    }
    
}

- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *) timeSection andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp{
    NSLog(@"day : %ld, timeSection : %@ dateString : %@", day, timeSection, dateString);
    
    NSDictionary *courseDic = courseCell.courserCellDic;
    NSLog(@"课程的字典信息：%@", courseDic);

}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeCourseStatusSuccess{
    [self gettimeSectionsUsingInfo];
}

- (void)gotoCoachHomepage{
    NSLog(@"去个人主页");
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    touchSet = touches;
    touchEvent = event;
}

@end
