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

@interface FTCoachSelfCourseViewController ()<FTGymCourseTableViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *historyOrderTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *courseHistoryTableViewHeight;
@property (nonatomic, strong) FTGymSourceView *gymSourceView;//课程表
@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@end

@implementation FTCoachSelfCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
}
- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setGymSourceView];
    [self setTableview];
}

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setGymSourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymSourceView" owner:nil options:nil]firstObject];
    _gymSourceView.titleLabel.text = [NSString stringWithFormat:@"%d月", [[FTTools getCurrentMonth] intValue]];
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.courseType = FTOrderCourseTypeCoachSelf;
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

- (void)setTableview{
    _historyOrderTableView.delegate = self;
    _historyOrderTableView.dataSource = self;
    [_historyOrderTableView registerNib:[UINib nibWithNibName:@"FTCoachHistoryCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    _tableViewHeight.constant = 40 * 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTCoachHistoryCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, tableView.width, 40);
    
    //下半部view
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, tableView.width, 20)];
    contentView.backgroundColor = [UIColor colorWithHex:0x282828];
    [headerView addSubview:contentView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 75, 12)];
    label1.textColor = [UIColor colorWithHex:0xb4b4b4];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"本月完成课程";
    [contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.width, 4, 50, 12)];
    label2.textColor = [UIColor colorWithHex:0xb4b4b4];
    label2.text = @"24节";
    label2.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:label2];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoCoachHomepage{
    NSLog(@"去个人主页");
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
