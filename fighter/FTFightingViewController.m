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

@interface FTFightingViewController ()<SDCycleScrollViewDelegate, FTnewsDetailDelegate,FTTableViewdelegate, FTFightingMainVCButtonsClickedDelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;
@property (nonatomic) NSInteger currentPage;
@end

@implementation FTFightingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//初次加载数据
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


- (void)initSubViews{
    //设置控件的二态
    [self setControlsHightLightImage];
    
    [self.view bringSubviewToFront:_entryButton];//把“参赛”按钮放在最前边
    
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

/**
 *  设置控件的二态图片
 */
- (void)setControlsHightLightImage{
    [_entryButton setBackgroundImage:[UIImage imageNamed:@"参赛pre"] forState:UIControlStateHighlighted];
}

- (void)getDataFromDBWithType:(NSString *)getType currentPage:(NSInteger) currentPage {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchNewsWithType:@"foo"];
    [dbManager close];
    
    
    if (self.tableViewDataSourceArray == nil) {
        self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
    }
    if ([getType isEqualToString:@"new"]) {
        self.tableViewDataSourceArray = mutableArray;
    }else if([getType isEqualToString:@"old"]){
        [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
    }
    
    self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    [self.tableViewController.tableView reloadData];
    
    //隐藏infoLabel
    if (self.infoLabel.isHidden == NO) {
        self.infoLabel.hidden = YES;
    }
}
- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)newsCurrId{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@", newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsCurrId, getType, ts, checkSign, [FTNetConfig showType]];
    NSLog(@"获取资讯 url ： %@", urlString);
    NetWorking *net = [[NetWorking alloc]init];
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                //                NSLog(@"data:%@",responseDic[@"data"]);

                if (mutableArray.count > 0) {
                    DBManager *dbManager = [DBManager shareDBManager];
                    [dbManager connect];
                    [dbManager cleanNewsTable];
                    
                    for (NSDictionary *dic in mutableArray)  {
                        [dbManager insertDataIntoNews:dic];
                    }
                    
                    [self getDataFromDBWithType:getType currentPage:self.currentPage];
                }
                
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                [self.tableViewController.tableView footerEndRefreshing];
            }else {
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
                [self.tableViewController.tableView footerEndRefreshing];
            }
            
        }else {
            [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
            [self.tableViewController.tableView footerEndRefreshing];
            
        }
    }];
    
}
#pragma mark - 视图加载

- (void)setTableView
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeFighting;
        
        self.tableViewController.FTdelegate = self;
        self.tableViewController.fightingTableViewButtonsClickedDelegate = self;
//        self.tableViewController.order = 0;
        //设置上拉、下拉刷新
        [self setJHRefresh];
    }
    
    if (self.tableViewDataSourceArray) {
        [self.tableViewController.tableView footerEndRefreshing];
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        NSLog(@"没有数据源。");
    }
    
    self.tableViewController.tableView.frame = self.currentView.bounds;
    [self.currentView addSubview:self.tableViewController.tableView];
    [self.tableViewController.tableView reloadData];
}

- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableViewController.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.currentPage = 0;
        [sself getDataWithGetType:@"new" andCurrId:@"-1"];

    }];
    //设置上拉刷新
    [self.tableViewController.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.currentPage ++;
        NSString *currId;
        if (sself.tableViewController.sourceArray && sself.tableViewController.sourceArray.count > 0) {
            FTNewsBean *bean = [sself.tableViewController.sourceArray lastObject];
            currId = bean.newsId;
        }else{
            return;
        }
        
        [sself getDataWithGetType:@"old" andCurrId:currId];
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


- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
    //    NSLog(@"第%ld个cell被点击了。", indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTNewsDetail2ViewController *newsDetailVC = [FTNewsDetail2ViewController new];
        //获取对应的bean，传递给下个vc
        //        NSDictionary *newsDic = tableView.sourceArray[indexPath.row];
        //        FTNewsBean *bean = [FTNewsBean new];
        //        [bean setValuesWithDic:newsDic];
        
        
        FTNewsBean *bean = tableView.sourceArray[indexPath.row];
        //标记已读
        if (![bean.isReader isEqualToString:@"YES"]) {
            bean.isReader = @"YES";
            //从数据库取数据
            DBManager *dbManager = [DBManager shareDBManager];
            [dbManager connect];
            [dbManager updateNewsById:bean.newsId isReader:YES];
            [dbManager close];
        }
        newsDetailVC.newsBean = bean;
        newsDetailVC.delegate = self;
        newsDetailVC.indexPath = indexPath;
        
        [self.navigationController pushViewController:newsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
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
    
    
    self.tableViewController.sourceArray[indexPath.row] = newsBean;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
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
