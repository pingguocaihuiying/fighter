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
#import "UILabel+FTLYZLabel.h"
#import "FTRatingBar.h"

#import "FTShareView.h"

@interface FTOrderCoachViewController ()<FTGymCourseTableViewDelegate, FTCoachOrderCourseViewDelegate, FTGymOrderCourseViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;//成就
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UIView *dividingLineView;
@property (strong, nonatomic) IBOutlet UILabel *yuanPerClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *perClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *yuanLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *tipButton;

@property (nonatomic, strong) FTGymSourceView *gymSourceView;//课程表
@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view
@property (strong, nonatomic) IBOutlet UIView *imagesView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMainViewHeight;

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, assign) BOOL isLoadCourseDataComplete;//已经加载课程数据

@property (nonatomic, assign)FTGymVIPType gymVIPType;//会员类型

@property (nonatomic, strong)NSMutableArray *coachImagesArray;
@property (strong, nonatomic) IBOutlet UIView *topMainView;
@property (nonatomic, strong) FTRatingBar *ratingBar;
@end

@implementation FTOrderCoachViewController

- (void)viewWillAppear:(BOOL)animated{
    //注册通知，当充值完成时，获取最新余额
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeMoney:) name:RechargeMoneytNoti object:nil];
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTips];
    [self initBaseData];
    [self setSubViews];
    
    FTUserBean *localUser = [FTUserTools getLocalUser];
    if (localUser) {
        [self getVIPInfo];//获取余额等会员信息
    }
    
    //网络数据加载
    [self getCoachRating];
    [self getTimeSection];//获取时间段信息
}

- (void)setTips{
    //如果读过，则不显示
    id readMark = [[NSUserDefaults standardUserDefaults]valueForKey:TIPS_COACH_COURSE];
    [_tipButton setHidden: readMark ? YES : NO];
}

/**
 初始化基本配置
 */
- (void)initBaseData{
    _gymVIPType = FTGymVIPTypeNope;//默认非会员
    
    /*
     测试数据
     */
    _coachImagesArray = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        NSString *imageURL = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1482147761&di=add7610d65cd18f82e43ea2918e11496&src=http://www.duotegame.com/picfile/NewsA/2013/02/27/image034_wm.jpg";
        [_coachImagesArray addObject:imageURL];
    }
    
}

- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setCoachCourceView];//设置教练课程表
    [self setCoachInfo];//设置教练信息
    [self setImagesView];//设置教练的相册
    [self setRatingBar];//设置教练的评分星级
}


- (void)setCoachInfo{
    [self labelsViewAdapter:_coachBean.labels];//项目标签
    _nameLabel.text = _coachBean.name;
    _genderLabel.text = _coachBean.sex;
    _ageLabel.text = [NSString stringWithFormat:@"%@岁", _coachBean.age];
    
    //如果年龄为0，数据一定有误，那么不显示年龄
    _ageLabel.text = @"";
    
    _achievementLabel.text = _coachBean.brief;
    
    _yuanPerClassLabel.text = [NSString stringWithFormat:@"%d元", [_coachBean.price intValue] / 100 ];
    _gymSourceView.yuanPerClassLabel.text = [NSString stringWithFormat:@"%d元", [_coachBean.price intValue] / 100 ];
    _gymSourceView.yuanPerClassLabel.hidden = NO;
    _gymSourceView.perClassLabel.hidden = NO;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_coachBean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
}

#pragma mark 设置教练的相册
/**
 设置教练的相册
 */
- (void)setImagesView{
    NSInteger num = _coachImagesArray.count;//图片数量
//    num = 0;
    if (num > 0) {
        _dividingLineView.hidden = NO;
        _imagesViewHeight.constant = 126;
        _topMainViewHeight.constant += _imagesViewHeight.constant;
        
        //增加点击事件
        UITapGestureRecognizer *imagesViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagesViewTap)];
        [_imagesView addGestureRecognizer:imagesViewTap];
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH - 15, 80)];
        scrollView.contentSize = CGSizeMake(80 * num + 5 * (num - 1), 80);
        
        //设置图片
        for (int i = 0; i < num; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake( (80 + 5) * i, 0, 80, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_coachImagesArray[i]] placeholderImage:[UIImage imageNamed:@"小占位图"]];
            [scrollView addSubview:imageView];
            
            //添加点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
            imageView.tag = 1000 + i;
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
        }
        
        [_imagesView addSubview:scrollView];
        
        //右下角部分
        //查看更多
        UILabel *moreLabel = [UILabel new];
        moreLabel.text = @"查看更多";
        moreLabel.textAlignment = NSTextAlignmentRight;
        moreLabel.font = [UIFont systemFontOfSize:12];
        moreLabel.textColor = [UIColor whiteColor];
        moreLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 15 - 8 - 5 - 100, scrollView.frame.origin.y + scrollView.height + 10 , 100, 12);
        [_imagesView addSubview:moreLabel];
        //右箭头
        UIImageView *moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 15 - 8, moreLabel.frame.origin.y - 10 + (32 - 9) / 2, 8, 9)];
        moreImageView.image = [UIImage imageNamed:@"右双箭头"];
        [_imagesView addSubview:moreImageView];
    }

}
#pragma mark 初始化评分控件
/**
 初始化评分控件
 */
- (void)setRatingBar{
    if (!_ratingBar) {
        _ratingBar = [[FTRatingBar alloc]initWithSpacing:5];
        float ratingBarWidth = 21 * 5 + 5 * 4;
        _ratingBar.frame = CGRectMake(SCREEN_WIDTH - 15 - ratingBarWidth, 15, ratingBarWidth, 28);
        [_topMainView addSubview:_ratingBar];
        
        //增加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingBarTap)];
        [_ratingBar addGestureRecognizer:tap];
        _ratingBar.userInteractionEnabled = YES;
        
        self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
        self.ratingBar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
        self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
        [self.ratingBar setRating:4.0f];
    }
}


/**
 评分框被点击
 */
- (void)ratingBarTap{
    NSLog(@"ratingBar clicked");
}

- (void)imagesViewTap{
    NSLog(@"imagesViewTap executed.");
}

- (void)imageTap:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *imageView = tap.view;
    NSInteger imageIndex = imageView.tag - 1000;
    
    NSLog(@"tap with index : %ld", imageIndex);
}

/**
 获取会员信息
 */
- (void)getVIPInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getVIPInfoWithGymId:[NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid] andOption:^(NSDictionary *dic) {
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


// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self getVIPInfo];
        [self gettimeSectionsUsingInfo];
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
    _gymSourceView.balanceLabel.text = balance;
    _gymSourceView.balanceLabel.hidden = NO;
    _gymSourceView.yueLabel.hidden = NO;
    _gymSourceView.yuanLabel.hidden = NO;
}

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    
    //自定义一些label、分割线（view）的颜色
    _yuanPerClassLabel.textColor = Custom_Red;
    _perClassLabel.textColor = Custom_Red;
    _yuanLabel.textColor = Custom_Red;
    _balanceLabel.textColor = Custom_Red;
    _dividingLineView.backgroundColor = Cell_Space_Color;
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
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *gymDetailButton = [[UIBarButtonItem alloc]initWithTitle:@"分享出去" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    self.navigationItem.rightBarButtonItem = gymDetailButton;
}

- (void) labelsViewAdapter:(NSString *) labelsString {
    
    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 30;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
//    labels = @[@"从前",@"有座山",@"山上有座庙",@"庙",@"里",@"住着一个",@"老和尚",@"和一个小和尚",@"小和尚",@"不满意",@"在这里",@"的", @"日子"];
    for (NSString *labelStr in labels) {
        NSString *labelCh = [FTTools getChNameWithEnLabelName:labelStr];
        UIView *labelView = [UIView new];
        CGSize labelSize = [labelCh sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 1, 5 * 2 + labelSize.width, 12)];
        label.text = labelCh;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        labelView.frame = CGRectMake(0, 0, labelSize.width + 5 * 2, 14);
        
        //添加背景图片
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:labelView.bounds];
        bgImageView.image = [UIImage imageNamed:@"拳种标签"];
        [labelView addSubview:bgImageView];
        [labelView sendSubviewToBack:bgImageView];
        
        [labelView addSubview:label];
//        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForENLabel:label]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        if (x + w <= width) {
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w;
        }else {
            x = 0;
            y = y + h + 6;
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w;
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
    _gymSourceView.titleLabel.text = @"时间表";
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.courseType = FTOrderCourseTypeCoach;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];
    if (_timeSectionsArray) {
        _gymSourceView.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
    }
    
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
            gymOrderCoachView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
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
                    gymOrderCourseView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
                    gymOrderCourseView.coachUserId = _coachBean.userId;
                    
                    NSLog(@"已经预约");
                    
                    NSDictionary *courseCellDic = courseCell.courserCellDic;
                    gymOrderCourseView.courserCellDic = courseCellDic;
                    
                    gymOrderCourseView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
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
                    gymOrderCoachView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
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
 获取教练评分
 */
- (void)getCoachRating{
    [NetWorking getCoachRatingByID:_coachBean.userId withBlock:^(NSDictionary *dic) {
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"]) {
            float score = [dic[@"data"] floatValue];
            [self.ratingBar displayRating:score];
        }
    }];
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
        }
        //获取场地使用信息后，刷新UI
        _gymSourceView.placesUsingInfoDic = _placesUsingInfoDic;
        [_gymSourceView reloadTableViews];

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

- (void)shareButtonClicked{
    FTShareView *shareView = [FTShareView new];
    
    //分享标题: “教练名 - 拳馆名“
    NSString *title = [NSString stringWithFormat:@"%@ - %@", _coachBean.name, _gymName];
    
    NSString *_webUrlString = [NSString stringWithFormat:@"%@?userId=%@", HomepageCoachWebViewURL, _coachBean.userId];//链接地址
    
    //分享简述
    [shareView setTitle:title];
    [shareView setSummary:_coachBean.brief];
    [shareView setImageUrl:_coachBean.headUrl];
    [shareView setUrl:_webUrlString];
    
    [self.view addSubview:shareView];
}

- (void)gotoCoachHomepage{
    NSLog(@"去个人主页");
    FTHomepageMainViewController *homepageMainViewController = [FTHomepageMainViewController new];
    homepageMainViewController.coachId = _coachBean.id;
    homepageMainViewController.olduserid = _coachBean.userId;
    [self.navigationController pushViewController:homepageMainViewController animated:YES];
}
- (IBAction)tipButtonClicked:(id)sender {
    _tipButton.hidden = YES;
    //已经读过，存入本地
    [[NSUserDefaults standardUserDefaults] setValue:@"read" forKey:TIPS_COACH_COURSE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
