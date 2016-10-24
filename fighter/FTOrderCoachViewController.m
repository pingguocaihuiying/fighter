//
//  FTOrderCoachViewController.m
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTOrderCoachViewController.h"
#import "UIImage+LabelImage.h"
#import "FTGymSourceView.h"
#import "FTGymOrderCourseView.h"
#import "FTGymOrderCoachView.h"
#import "FTHomepageMainViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTPayForGymVIPViewController.h"

@interface FTOrderCoachViewController ()<FTGymCourseTableViewDelegate, FTCoachOrderCourseViewDelegate, FTGymOrderCourseViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;//成就
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UIView *dividingLineView;
@property (strong, nonatomic) IBOutlet UIView *dividingLineView2;
@property (strong, nonatomic) IBOutlet UILabel *yuanPerClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *perClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *yuanLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeight;

@property (nonatomic, strong) FTGymSourceView *gymSourceView;//课程表
@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view
@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMainViewHeight;

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, assign) BOOL isLoadCourseDataComplete;//已经加载课程数据

@property (nonatomic, assign)FTGymVIPType gymVIPType;//会员类型

@end

@implementation FTOrderCoachViewController

- (void)viewWillAppear:(BOOL)animated{
    //注册通知，当充值完成时，获取最新余额
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeMoney:) name:@"RechargeMoneytNoti" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self setSubViews];
    
    FTUserBean *localUser = [FTUserTools getLocalUser];
    if (localUser) {
        [self getVIPInfo];//获取余额等会员信息
    }
    
    [self getTimeSection];//获取时间段信息
}


/**
 初始化基本配置
 */
- (void)initBaseData{
    _gymVIPType = FTGymVIPTypeNope;//默认非会员
    

}

- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setCoachCourceView];//设置教练课程表
    [self setCoachInfo];//设置教练信息
    
}


- (void)setCoachInfo{
    [self labelsViewAdapter:_coachBean.labels];//项目标签
    _nameLabel.text = _coachBean.name;
    _genderLabel.text = _coachBean.sex;
    _ageLabel.text = [NSString stringWithFormat:@"%@岁", _coachBean.age];
    _achievementLabel.text = _coachBean.brief;
    _yuanPerClassLabel.text = [NSString stringWithFormat:@"%d元", [_coachBean.price intValue] / 100 ];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_coachBean.headUrl]];
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
        
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            _gymVIPType = [type integerValue];
            if (_gymVIPType == FTGymVIPTypeYep) {//如果已经是会员，更新会员信息的展示
                [self updateVIPInfoUIWithDic:dic[@"data"]];
            }else if (_gymVIPType == FTGymVIPTypeApplying){
                
            }
        }else{
            _gymVIPType = FTGymVIPTypeNope;
            
        }
        
    }];
}



- (void)rechargeMoney:(id)info{
    NSString *msg = [info object];
    if ([msg isEqualToString:@"SUCESS"]){
        [self getVIPInfo];
    }
}

- (void)updateVIPInfoUIWithDic:(NSDictionary *)dic{
    
    //余额
    NSString *balance = dic[@"money"];
    if (!balance) {
        balance = @"0";
    }
    _balance = [NSString stringWithFormat:@"%@", balance];
    
    balance = [NSString stringWithFormat:@"%.0lf", [balance doubleValue] / 100];
    
    _balanceLabel.text = balance;
}

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    
    //自定义一些label、分割线（view）的颜色
    _yuanPerClassLabel.textColor = Custom_Red;
    _perClassLabel.textColor = Custom_Red;
    _yuanLabel.textColor = Custom_Red;
    _balanceLabel.textColor = Custom_Red;
    _dividingLineView.backgroundColor = Cell_Space_Color;
        _dividingLineView2.backgroundColor = Cell_Space_Color;
    [UILabel setRowGapOfLabel:_achievementLabel withValue:8];
    
    
}

- (void)setNaviView{
    
    //设置默认标题
//    self.navigationItem.title = _gymDetailBean.gym_name;
    self.navigationItem.title = _coachBean.name;
    
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

- (void) labelsViewAdapter:(NSString *) labelsString {
    
    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 124;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
    
    for (NSString *label in labels) {
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForENLabel:label]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        if (x + w <= width) {
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }else {
            x = 0;
            y = y + h + 6;
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }
        
        [self.labelView addSubview:labelView];
    }
//    [self.labelView layoutIfNeeded];
//    [self.view layoutIfNeeded];
    _labelViewHeight.constant = y + h;
    _topMainViewHeight.constant += _labelViewHeight.constant;
}

- (void)setCoachCourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    _gymSourceView.titleLabel.text = @"预约私教";
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.courseType = FTOrderCourseTypeCoach;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];
    _gymSourceView.tableViewsHeight.constant = 42 * 4;
    [_gymSourceView reloadTableViews];
}

- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSectionIndex:(NSInteger) timeSectionIndex andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp{
    NSLog(@"day : %ld, timeSection : %@ dateString : %@", day, _timeSectionsArray[timeSectionIndex][@"timeSection"], dateString);
    if (_isLoadCourseDataComplete) {
        
        if (![FTUserTools getLocalUser]) {
            NSLog(@"没有登录");
            [self login];
            return;
        }
        
        if(_gymVIPType != FTGymVIPTypeYep){
            FTPayForGymVIPViewController *payForGymVIPViewController = [[FTPayForGymVIPViewController alloc]init];
            payForGymVIPViewController.gymDetailBean = _gymDetailBean;
            payForGymVIPViewController.gymVIPType = _gymVIPType;
            [self.navigationController pushViewController:payForGymVIPViewController animated:YES];
            return;
        }
        
        if (courseCell.isEmpty) {//如果是空的，说明可以预约
            NSLog(@"可以预约");
            FTGymOrderCoachView *gymOrderCoachView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCoachView" owner:nil options:nil] firstObject];
            gymOrderCoachView.delegate = self;
            gymOrderCoachView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
            gymOrderCoachView.dateString = dateString;
            gymOrderCoachView.dateTimeStamp = timeStamp;
            gymOrderCoachView.price = _coachBean.price;
            gymOrderCoachView.coachName = _coachBean.name;
            gymOrderCoachView.courserCellDic = courseCell.courserCellDic;
            gymOrderCoachView.timeSection = _timeSectionsArray[timeSectionIndex][@"timeSection"];
            gymOrderCoachView.timeSectionId = _timeSectionsArray[timeSectionIndex][@"id"];
            gymOrderCoachView.balance = _balance;
            gymOrderCoachView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
            gymOrderCoachView.coachUserId = _coachBean.userId;
            
            [gymOrderCoachView setDisplay];
            
            [self.view addSubview:gymOrderCoachView];
        }else{
            NSDictionary *courseDic = courseCell.courserCellDic;
            NSString *type = courseDic[@"type"];
            
            if ([type isEqualToString:@"3"]) {//如果不可约
                NSLog(@"不可预约");
            } else {//如果已约
                //"myIsOrd": 1,//当前用户是否预定该课程， 0 - 没有，1 - 已有预约
                NSString *myIsOrd = [NSString stringWithFormat:@"%@", courseDic[@"myIsOrd"]];
                if ([myIsOrd isEqualToString:@"1"]) {//如果是自己约的
                    NSLog(@"取消预约");
                    FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
                    gymOrderCourseView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
                    gymOrderCourseView.courseType = FTOrderCourseTypeCoach;
                    gymOrderCourseView.dateString = dateString;
                    gymOrderCourseView.dateTimeStamp = timeStamp;
                    
                    gymOrderCourseView.price = _coachBean.price;
                    gymOrderCourseView.coachName = _coachBean.name;
                    gymOrderCourseView.courserCellDic = courseCell.courserCellDic;
                    gymOrderCourseView.timeSection = _timeSectionsArray[timeSectionIndex][@"timeSection"];
                    gymOrderCourseView.timeSectionId = _timeSectionsArray[timeSectionIndex][@"id"];
                    gymOrderCourseView.balance = _balance;
                    gymOrderCourseView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
                    gymOrderCourseView.coachUserId = _coachBean.userId;
                    
                    NSLog(@"已经预约");
                    
                    NSDictionary *courseCellDic = courseCell.courserCellDic;
                    gymOrderCourseView.courserCellDic = courseCellDic;
                    
                    gymOrderCourseView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
                    gymOrderCourseView.delegate = self;
                    gymOrderCourseView.status = FTGymCourseStatusHasOrder;
                    [self.view addSubview:gymOrderCourseView];
                    
                }else{
                    NSLog(@"已被别人约了");
                    FTGymOrderCoachView *gymOrderCoachView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCoachView" owner:nil options:nil] firstObject];
                    gymOrderCoachView.delegate = self;
                    gymOrderCoachView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
                    gymOrderCoachView.dateString = dateString;
                    gymOrderCoachView.dateTimeStamp = timeStamp;
                    gymOrderCoachView.price = _coachBean.price;
                    gymOrderCoachView.coachName = _coachBean.name;
                    gymOrderCoachView.courserCellDic = courseCell.courserCellDic;
                    gymOrderCoachView.timeSection = _timeSectionsArray[timeSectionIndex][@"timeSection"];
                    gymOrderCoachView.timeSectionId = _timeSectionsArray[timeSectionIndex][@"id"];
                    gymOrderCoachView.balance = _balance;
                    gymOrderCoachView.gymId = [NSString stringWithFormat:@"%d", _gymDetailBean.corporationid];
                    gymOrderCoachView.coachUserId = _coachBean.userId;
                    
                    [gymOrderCoachView setDisplayWithInfo];
                    gymOrderCoachView.bookedByOthers = YES;
                    
                    [self.view addSubview:gymOrderCoachView];
                }
                
            }
        }
    } else {
        NSLog(@"没有加载到课程数据");
        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"没有加载到课程信息"];
    }

}
/**
 *  获取时间段信息
 */
- (void)getTimeSection{
    [NetWorking getGymTimeSlotsById:_coachBean.corporationid andOption:^(NSArray *array) {
        _timeSectionsArray = array;
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            //获取时间段信息后，根据内容多少设置tableviews的高度，再刷新一次tableview
            _gymSourceView.timeSectionsArray = _timeSectionsArray;
            _gymSourceView.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
            [self gettimeSectionsUsingInfo];
        }
        
    }];
}

// 跳转登录界面方法
- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//获取场地使用信息
- (void)gettimeSectionsUsingInfo{
    
    [NetWorking getCoachCourceInfoByCoachId:_coachBean.userId andGymId:_coachBean.corporationid andOption:^(NSArray *array) {
        _placesUsingInfoDic = [NSMutableDictionary new];
        _isLoadCourseDataComplete = YES;
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


- (void)bookSuccess{
    //取消预订成功后，刷新课程预订信息
    [self gettimeSectionsUsingInfo];
    
    //刷新余额
    [self getVIPInfo];
    
    if (SCREEN_WIDTH != 320) {
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:BookCoachSuccessNotification object:nil]];
    }
    //发送消费通知
    
}

- (void)bookCoachSuccess{
    //预订成功后，刷新课程预订信息
    [self gettimeSectionsUsingInfo];
    
    //刷新余额
    [self getVIPInfo];
    if (SCREEN_WIDTH != 320) {
    //发送消费通知
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:BookCoachSuccessNotification object:nil]];
    }
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoCoachHomepage{
    NSLog(@"去个人主页");
    FTHomepageMainViewController *homepageMainViewController = [FTHomepageMainViewController new];
    homepageMainViewController.coachId = _coachBean.id;
    homepageMainViewController.olduserid = _coachBean.userId;
    [self.navigationController pushViewController:homepageMainViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
