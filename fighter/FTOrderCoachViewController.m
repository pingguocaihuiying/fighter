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

@interface FTOrderCoachViewController ()<FTGymCourseTableViewDelegate>

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


@end

@implementation FTOrderCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
    [self getVIPInfo];//获取余额等会员信息
}

- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setGymSourceView];
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
    
    //余额
    NSString *balance = dic[@"money"];
    if (!balance) {
        balance = @"0";
    }
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
    
    [self labelsViewAdapter:@"综合格斗(MMA),女子格斗,女子格斗,女子格斗"];
}

- (void)setNaviView{
    
    //设置默认标题
//    self.navigationItem.title = _gymDetailBean.gym_name;
    self.navigationItem.title = @"李小龙";
    
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
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForLabel:label]];
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

- (void)setGymSourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    _gymSourceView.titleLabel.text = @"预约私教";
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.courseType = FTOrderCourseTypeCoach;
    _gymSourceView.delegate = self;
    [_gymSourceViewContainerView addSubview:_gymSourceView];
    _gymSourceView.tableViewsHeight.constant = 42 * 4;
    [_gymSourceView reloadTableViews];
}

- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *)timeSection{
    NSLog(@"day : %ld, timeSection : %@", day, timeSection);
    if (courseCell.hasOrder) {
        NSLog(@"已经预约");
        
    } else if (courseCell.canOrder) {
//        FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
//        gymOrderCourseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        //        gymOrderCourseView.belowView2.hidden = YES;
//        //        gymOrderCourseView.belowView2Height.constant = 0;
//        gymOrderCourseView.status = FTGymCourseStatusCanOrder;
//        [[[UIApplication sharedApplication] keyWindow] addSubview:gymOrderCourseView];
        NSLog(@"可以预约");
    }else {
        NSLog(@"不可以预约");
    }
}
/**
 *  获取时间段信息
 */
- (void)getTimeSection{
    int corporationid = 158;
    [NetWorking getGymTimeSlotsById:[NSString stringWithFormat:@"%d", corporationid] andOption:^(NSArray *array) {
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
    
    [NetWorking getGymSourceInfoById:[NSString stringWithFormat:@"%d", 1]  andTimestamp:timestampString  andOption:^(NSArray *array) {
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


- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoCoachHomepage{
    NSLog(@"去个人主页");
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
