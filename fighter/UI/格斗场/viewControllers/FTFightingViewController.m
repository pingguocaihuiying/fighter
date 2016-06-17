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

@interface FTFightingViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate, FTnewsDetailDelegate,FTTableViewdelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property (nonatomic, copy)NSString *currentItemValueEn;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic) NSInteger currentPage;


@end

@implementation FTFightingViewController

- (void)viewDidLoad {
    //        NSLog(@"拳讯 view的宽度：%f,高度：%f",self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
    [self initSubViews];
    [self getDataFromDBWithType:@"new" currentPage:self.currentPage];
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
    
    [self setOtherViews];
}


- (void)getDataFromDBWithType:(NSString *)getType currentPage:(NSInteger) currentPage {
    
    NSString *newsType = _currentItemValueEn;
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchNewsWithType:newsType];
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
    if ([newsType isEqualToString:@"All"]) {
        self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    }else{
        
        self.tableViewController.tableView.tableHeaderView = nil;
    }
    
    [self.tableViewController.tableView reloadData];
    
    //隐藏infoLabel
    if (self.infoLabel.isHidden == NO) {
        self.infoLabel.hidden = YES;
    }
    [self saveCache];
}
- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)newsCurrId{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    //    NSString *newsType = [self getNewstype];
    NSString *newsType = _currentItemValueEn;
    
    
    //    NSString *newsCurrId = @"-1";
    //    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsType, newsCurrId, getType, ts, checkSign, [FTNetConfig showType]];
    NSLog(@"获取资讯 url ： %@", urlString);
    NetWorking *net = [[NetWorking alloc]init];
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                //                NSLog(@"data:%@",responseDic[@"data"]);
                //缓存数据到DB
                if (mutableArray.count > 0) {
                    DBManager *dbManager = [DBManager shareDBManager];
                    [dbManager connect];
                    [dbManager cleanNewsTable];
                    
                    for (NSDictionary *dic in mutableArray)  {
                        [dbManager insertDataIntoNews:dic];
                    }
                    
                    //缓存数据
                    [self saveCache];
                    
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


- (void)saveCache{
    FTCache *cache = [FTCache sharedInstance];
    NSArray *dataArray = [[NSArray alloc]initWithArray:self.tableViewDataSourceArray];
    FTCacheBean *cacheBean = [[FTCacheBean alloc] initWithTimeStamp:[[NSDate date] timeIntervalSince1970]  andDataArray:dataArray];
    
    [cache.newsDataDic setObject:cacheBean forKey:[NSString stringWithFormat:@"%@", _currentItemValueEn]];
    
}

- (void)setOtherViews{
    //设置分类栏
    [self setTypeNaviScrollView];
}

- (void)setTypeNaviScrollView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initPageController];
    
}

- (void)setCycleScrollView{
    NSMutableArray *imagesURLStrings = [NSMutableArray new];
    NSMutableArray *titlesArray = [NSMutableArray new];
    if (self.cycleDataSourceArray) {
        for(NSDictionary *dic in self.cycleDataSourceArray){
            [imagesURLStrings addObject:dic[@"img_big"]];
            [titlesArray addObject:dic[@"title"]];
            
        }
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:@"空图标大"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
#pragma -mark -暂时隐藏轮播图的标题（没有给轮播图传title的值）
    //    _cycleScrollView.titlesGroup = titlesArray;
    
    _cycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    //    [_cycleScrollView.mainView reloadData];
    
    //    //轮播图添加遮罩
    //    UIImageView *shadowView = [[UIImageView alloc]initWithFrame:_cycleScrollView.frame];
    //    shadowView.image = [UIImage imageNamed:@"头图暗影遮罩-ios"];
    //    shadowView.alpha = 0.8;
    ////    [_cycleScrollView addSubview:shadowView];
    //
    //    [_cycleScrollView insertSubview:shadowView atIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载

- (void)initPageController
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeNews;
        
        self.tableViewController.FTdelegate = self;
        self.tableViewController.order = 0;
        //设置上拉、下拉刷新
        [self setJHRefresh];
    }
    
    self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    
    if (self.tableViewDataSourceArray) {
        [self.tableViewController.tableView footerEndRefreshing];
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        //    self.tableViewController.sourceArray = _sourceArry[0];
        NSLog(@"没有数据源。");
    }
    
    self.tableViewController.tableView.frame = self.currentView.bounds;
    [self.currentView addSubview:self.tableViewController.tableView];
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
@end
