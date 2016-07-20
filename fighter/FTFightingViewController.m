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
#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTRankViewController.h"
#import "DBManager.h"
#import "NetWorking.h"
#import "FTLYZButton.h"
#import "FTHomepageMainViewController.h"
#import "FTLaunchNewMatchViewController.h"


/**
 *  数据结构思路22：
 源数据用字典存，key值为比赛日期，对应的value为数组，数组中存放一个个比赛信息
 再用array顺序存放字典的key值（即日期），校正数据的顺序
 */

@interface FTFightingViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    _conditionOffset = 0;
}
- (IBAction)abountToStartButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = YES;
    _matchedButton.selected = NO;
    _conditionOffset = 1;
}
- (IBAction)matchedButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = NO;
    _matchedButton.selected = YES;
    _conditionOffset = 2;
}


- (void)getMatchList{
    [NetWorking getMatchListWithPageNum:_pageNum andPageSize:_pageSize andOption:^(NSArray *array) {
                if (array && array.count > 0) {
                    
                    if (_pageNum == 1) {//如果是第一页，替换
                        
                    }else if(_pageNum > 1){//如果是
                        
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
#pragma mark - 视图加载

- (void)setTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
        [self setJHRefresh];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
- (void)gotoHomepageWithUseroldid:(NSString *)olduserid{
    if (!olduserid) {
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        olduserid = localUser.olduserid;
    }
    FTHomepageMainViewController *homepageViewController = [FTHomepageMainViewController new];
    homepageViewController.olduserid = olduserid;
    [self.navigationController pushViewController:homepageViewController animated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
