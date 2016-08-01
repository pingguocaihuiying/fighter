//
//  FTInformationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTFightingViewController.h"
#import "FTTableViewController.h"
#import "SDCycleScrollView.h"
#import "RBRequestOperationManager.h"
#import "FTNetConfig.h"
#import "ZJModelTool.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "FTNewsDetail2ViewController.h"
#import "FTFilterTableViewController.h"
#import "FTNewsBean.h"
#import "UIButton+LYZTitle.h"
#import "UIButton+WebCache.h"
#import "FTRankingListViewController.h"
#import "FTRankViewController.h"
#import "NetWorking.h"
#import "FTLYZButton.h"
#import "FTLaunchNewMatchViewController.h"
#import "FTFightingTableViewCell.h"
#import "FTMatchBean.h"


/**
 *  数据结构思路22：
 源数据用字典存，key值为比赛日期，对应的value为数组，数组中存放一个个比赛信息
 再用array顺序存放字典的key值（即日期），校正数据的顺序
 */

@interface FTFightingViewController ()<UITableViewDelegate, UITableViewDataSource, FTFightingTableViewCellButtonsClickedDelegate>


@property (nonatomic, strong)NSMutableArray *dateArray;//
@property (nonatomic, strong) NSMutableDictionary *matchesDic;//
@property (nonatomic, copy) NSString *pageSize;//每一页多少条数据
@property (nonatomic, assign) int pageNum;//当前页,1表示第一页
@property (weak, nonatomic) IBOutlet UITableView *tableView;//显示比赛列表的

//上方的条件筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *allMatchesButton;
@property (weak, nonatomic) IBOutlet UIButton *abountToStartButton;
@property (weak, nonatomic) IBOutlet UIButton *matchedButton;

//当前选中的筛选条件：0、1、2，默认为0
@property (nonatomic, assign)int conditionOffset;

//今日时间，明日时间的日期字符串，用于header文本显示，格式：“2016-12-23”
@property (nonatomic, copy) NSString *todayDateString;
@property (nonatomic, copy) NSString *tomorrowDateString;

@end

@implementation FTFightingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self initSubViews];
    [self getMatchList];//初次加载数据
}

- (void)viewWillAppear:(BOOL)animated{
    [MobClick event:@"mainPage_BoxingNews"];
    //    self.tabBarController.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    //        self.tabBarController.navigationController.navigationBarHidden = NO;
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)initBaseData{
    _pageNum = 1;
    _pageSize = @"10";
    
    _dateArray = [NSMutableArray new];
    _matchesDic = [NSMutableDictionary new];
    
    _todayDateString = [FTTools getDateStringWith:[[NSDate date] timeIntervalSince1970]];//根据当前时间戳获取当天日期,格式“2017-7-26"
    _tomorrowDateString = [FTTools getDateStringWith:[[NSDate date] timeIntervalSince1970] + 24 * 60 * 60];//根据(当前时间戳+1天的秒数)获取明天日期,格式“2017-7-26"
    
}

- (void)initSubViews{
    
    //设置状态栏的颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置右上角的按钮
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-搜索pre"] forState:UIControlStateHighlighted];
    [self.messageButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-消息pre"] forState:UIControlStateHighlighted];
    
    //设置左上角按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.leftNavButton.layer setMasksToBounds:YES];
    self.leftNavButton.layer.cornerRadius = 17.0;
    [self.leftNavButton sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftNavButton];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableView];//设置tableview
}

#pragma mark - 筛选按钮的点击事件
- (IBAction)allButtonClicked:(id)sender {
    _allMatchesButton.selected = YES;
    _abountToStartButton.selected = NO;
    _matchedButton.selected = NO;
    _conditionOffset = 0;//用于表示当前筛选条件，0为全部，1为即将开始，2为匹配我的
    
    //点击筛选按钮后，重置为第一页，刷新数据
    _pageNum = 1;
    [self getMatchList];
}
- (IBAction)abountToStartButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = YES;
    _matchedButton.selected = NO;
    _conditionOffset = 1;
    
    _pageNum = 1;
    [self getMatchList];
}

- (IBAction)matchedButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = NO;
    _matchedButton.selected = YES;
    _conditionOffset = 2;
    
    _pageNum = 1;
    [self getMatchList];
}


- (void)getMatchList{
    
    NSString *status = @"0";
    NSString *payStatus = @"0";
    NSString *label = @"";
    NSString *againstId = @"";
    NSString *weight = @"";
    if (_conditionOffset == 0) {
        
    } else if (_conditionOffset == 1){
        status = @"1";
        payStatus = @"1";
    }else if (_conditionOffset == 2){
        
#pragma mark -    warn    下面三个参数根据用户自己的信息去完善
        label = @"泰拳";
        label = [label stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        againstId = @"";
        weight = @"70";
    }
    
    [NetWorking getMatchListWithPageNum:_pageNum andPageSize:_pageSize andStatus:status andPayStatus:payStatus andLabel:label andAgainstId:againstId andWeight:weight andOption:^(NSArray *array) {
                if (array && array.count > 0) {
                    
                    if (_pageNum == 1) {//如果是第一页，清除历史数据
                        [_dateArray removeAllObjects];
                        [_matchesDic removeAllObjects];
                        
                        //处理获取的数据，把array组装成一个array和一个字典，字典的key值为转换后的日期，array按次序存放日期，用于矫正字典的顺序
                        for (int  i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            NSTimeInterval matchDateTimeStamp = [dic[@"theDate"] doubleValue ] / 1000;
                            NSString *matchDateString = [FTTools getDateStringWith:matchDateTimeStamp];
                            [FTTools saveDateStr:matchDateString ToMutableArray:_dateArray];//处理
                            
                            FTMatchBean *matchBean = [FTMatchBean new];
                            [matchBean setValuesForKeysWithDictionary:dic];
                            
                            [_matchesDic setObject:matchBean forKey:matchDateString];
                        }
                        
                    }else if(_pageNum > 1){//如果不是第一页，追加
                        //处理获取的数据，把array组装成一个array和一个字典，字典的key值为转换后的日期，array按次序存放日期，用于矫正字典的顺序
                        for (int  i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            NSTimeInterval matchDateTimeStamp = [dic[@"theDate"] doubleValue]/ 1000;
                            NSString *matchDateString = [FTTools getDateStringWith:matchDateTimeStamp] ;
                            [FTTools saveDateStr:matchDateString ToMutableArray:_dateArray];//处理
                            
                            FTMatchBean *matchBean = [FTMatchBean new];
                            [matchBean setValuesForKeysWithDictionary:dic];
                            
                            [_matchesDic setObject:matchBean forKey:matchDateString];
                        }
                    }
                    
                    //刷新成功
                    [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                    [self.tableView footerEndRefreshing];
                    
                    [self.tableView reloadData];
                    
                }else {
                    //刷新失败
                    [self.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
                    [self.tableView footerEndRefreshing];
                }
    }];
}

/**
 *  将字符串存入可变数组，如果存在，则不存
 *
 *  @param str 传入的字符串
 */
- (void)saveDateStrToArray:(NSString *)str{
    BOOL containStr = false;
    for (NSString *string in _dateArray) {
        if ([string isEqualToString:str]){
            containStr = true;
            break;
        }
    }
    if (!containStr) {
        [_dateArray addObject:str];
    }
}

#pragma mark - 视图加载
//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, 100, 14)];
    NSString *dateString = _dateArray[section];
    if ([dateString isEqualToString:_todayDateString]) {
        dateString = @"今日赛事";
    } else if ([dateString isEqualToString:_tomorrowDateString]){
        dateString = @"明日赛事";
    }
    label.text = dateString;
    label.textColor = [UIColor colorWithHex:0xb4b4b4];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}
//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

- (void)setTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FTFightingTableViewCell" bundle:nil] forCellReuseIdentifier:@"matchCell"];
        [self setJHRefresh];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 173;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTFightingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    cell.buttonsClickedDelegate = self;
    NSString *dateString = _dateArray[indexPath.section];
    FTMatchBean *matchBean = _matchesDic[dateString];
    [cell setWithBean:matchBean];
    return cell;
}

- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.pageNum = 1;
        [sself getMatchList];

    }];
    //设置上拉刷新
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.pageNum ++;
        [sself getMatchList];
    }];
}


- (IBAction)leftButtonItemClick:(id)sender {
    
    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }
}


#pragma -mark -排行榜按钮被点击
- (IBAction)rankButtonClicked:(id)sender {
    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
    [self.navigationController pushViewController:rankHomeVC animated:YES];
}

- (IBAction)messageButtonClicked:(id)sender {
    NSLog(@"message button clicked.");
}

#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic {
    
    FTNewsDetail2ViewController *newsDetailVC = [FTNewsDetail2ViewController new];
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-news",dic[@"objId"]];
    
    newsDetailVC.webUrlString = [@"http://www.gogogofight.com/page/news_page.html?" stringByAppendingString:str];
    [self.navigationController pushViewController:newsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    
}

- (void)updateCountWithNewsBean:(FTNewsBean *)newsBean indexPath:(NSIndexPath *)indexPath{
    
    //    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    //    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.voteCount] forKey:@"voteCount"];
    //    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.commentCount] forKey:@"commentCount"];
    
    
//    self.tableViewController.sourceArray[indexPath.row] = newsBean;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

//购票、赞助等按钮的点击事件
- (void)buttonClickedWithIdentifycation:(NSString *)identifycationString andRaceId:(NSString *)raceId{
    NSLog(@"identifycation : %@, raceId : %@", identifycationString, raceId);
}
/**
 *  参赛按钮被点击
 *
 */
- (IBAction)entryButtonClicked:(id)sender {
    NSLog(@"参赛");
    FTLaunchNewMatchViewController *launchNewMatchViewController = [FTLaunchNewMatchViewController new];
    [self.navigationController pushViewController:launchNewMatchViewController animated:YES];
}

#pragma mark - cell中购票、观战、赞助、下注等按钮的点击回掉代理方法



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
