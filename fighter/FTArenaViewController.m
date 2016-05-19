//
//  FTArenaViewController.m
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaViewController.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "FTNWGetCategory.h"
#import "FTLabelBean.h"
#import "FTRankTableView.h"
#import "FTTableViewController.h"
#import "FTTableViewController.h"
#import "JHRefresh.h"
#import "FTInformationViewController.h"
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
#import "Mobclick.h"
#import "FTRankingListViewController.h"
#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTRankViewController.h"


@interface FTArenaViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate, FTnewsDetailDelegate>

{
    NIDropDown *_dropDown;
}


@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, copy)NSString *currentIndexString;
//@property (nonatomic, strong)FTTableViewController
@end

@implementation FTArenaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
                [self initPageController];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//初次加载数据
    
    [self initBaseConfig];
    [self initSubviews];
    NSArray *array = [FTNWGetCategory sharedCategories];
    
        for(FTLabelBean  *labelBean in array){

        }
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

/**
 *  初始化一些默认数据
 */
- (void)initBaseConfig{
    _currentIndexString = @"all";
}

- (void)initSubviews{
    
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
    
}

- (void)initPageController
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeArena;
        
        self.tableViewController.FTdelegate = self;
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
    self.tableViewController.tableView.frame = self.mainView.bounds;
    [self.mainView addSubview:self.tableViewController.tableView];
}

- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableViewController.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        [sself getDataWithGetType:@"new" andCurrId:@"-1"];
    }];
    //设置上拉刷新
    [self.tableViewController.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSString *currId;
        if (sself.tableViewController.sourceArray && sself.tableViewController.sourceArray.count > 0) {
            currId = [sself.tableViewController.sourceArray lastObject][@"newsId"];
        }else{
            return;
        }
        
        [sself getDataWithGetType:@"old" andCurrId:currId];
    }];
}


/**
 *  “全部视频”按钮被点击
 *
 *  @param sender “全部视频”按钮
 */
- (IBAction)allButtonClicked:(id)sender {
    if (![_currentIndexString isEqualToString:@"all"]) {
        [self changeCurrentIndex];//改变currentIndex的值
        [self refreshIndexView];//刷新红色下标的显示
    }
    //设置下拉框
    [self setDropDown:sender];
}
/**
 *  “本周最热”按钮被点击
 *
 *  @param sender “本周最热”按钮
 */
- (IBAction)hotThisWeekButtonClicked:(id)sender {
    if (![_currentIndexString isEqualToString:@"hot"]) {
        [self changeCurrentIndex];//改变currentIndex的值
        [self refreshIndexView];//刷新红色下标的显示
    }

}

- (void)setDropDown:(id)sender{
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender
                                                                       style:FTRankTableViewStyleLeft
                                                                     option:^(FTRankTableView *searchTableView) {
                                                                         searchTableView.dataArray = [[NSArray alloc] initWithObjects:@"拳击",@"综合格斗综合格斗综合格斗",@"散打",@"自由搏击",@"跆拳道",@"截拳道",@"sadasdfasdfasdfsadfsafsadfsa",nil];
                                                                         searchTableView.offsetX = -40;
                                                                         searchTableView.offsetY = 14;
                                                                     }];
    
    [self.view addSubview:kindTableView];
    
    [kindTableView  setAnimation];
    
    [kindTableView setDirection:FTAnimationDirectionToTop];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", _btnSelect.titleLabel.text);
}
- (void)rel{
    _dropDown = nil;
}
- (IBAction)newBlogButtonClicked:(id)sender {
    NSLog(@"发新帖");
}
 /**
  *  循环改变currentIndex的值
  */
- (void)changeCurrentIndex{
    if ([_currentIndexString isEqualToString:@"all"]) {
        _currentIndexString = @"hot";
    }else{
        _currentIndexString = @"all";
    }
}
- (void)refreshIndexView{
    if ([_currentIndexString isEqualToString:@"all"]) {
        _indexViewOfAllVideo.hidden = NO;
        _indexViewOfHot.hidden = YES;
    }else{
        _indexViewOfAllVideo.hidden = YES;
        _indexViewOfHot.hidden = NO;
    }
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
    
}


- (NSString *)getNewstype{
    NSString *newsType = @"";
    //根据当前button的下标来转换type
    if (self.currentSelectIndex == 0) {
        newsType = @"All";
    }else if (self.currentSelectIndex == 1) {
        newsType = @"MMA";
    }else if (self.currentSelectIndex == 2) {
        newsType = @"Boxing";
    }else if (self.currentSelectIndex == 3) {
        newsType = @"Wrestling";
    }else if (self.currentSelectIndex == 4) {
        newsType = @"FemaleWrestling";
    }else if (self.currentSelectIndex == 5) {
        newsType = @"ThaiBoxing";
    }else if (self.currentSelectIndex == 6) {
        newsType = @"Taekwondo";
    }else if (self.currentSelectIndex == 7) {
        newsType = @"Judo";
    }else if (self.currentSelectIndex == 8) {
        newsType = @"Sumo";
    }else if (self.currentSelectIndex == 9) {
        //暂无
        newsType = @"Wrestling";
    }else if (self.currentSelectIndex == 10) {
        //暂无
        newsType = @"Sumo";
    }
    return newsType;
}

- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)newsCurrId{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *newsType = [self getNewstype];
    
    
    //    NSString *newsCurrId = @"-1";
    //    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsType, newsCurrId, getType, ts, checkSign, [FTNetConfig showType]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSLog(@"news's url : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
            
            if ([newsType isEqualToString:@"All"]) {
                NSMutableArray *hotArray = [NSMutableArray new];
                for(NSDictionary *dic in mutableArray){
                    if ([dic[@"newsType"] isEqualToString:@"Hot"]) {
                        [hotArray addObject:dic];
                    }
                }
                [mutableArray removeObjectsInArray:hotArray];
            }
            
            if (self.tableViewDataSourceArray == nil) {
                self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
            }
            if ([getType isEqualToString:@"new"]) {
                self.tableViewDataSourceArray = mutableArray;
            }else if([getType isEqualToString:@"old"]){
                [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
            }
            //            [self initPageController];
            
            self.tableViewController.sourceArray = self.tableViewDataSourceArray;
            if ([newsType isEqualToString:@"All"]) {
                self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
            }else{
                //                [self.tableViewController.tableView.tableHeaderView removeFromSuperview];
                self.tableViewController.tableView.tableHeaderView = nil;
            }
            [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            [self.tableViewController.tableView footerEndRefreshing];
            
            [self.tableViewController.tableView reloadData];
            
            [self saveCache];
            //隐藏infoLabel
            if (self.infoLabel.isHidden == NO) {
                self.infoLabel.hidden = YES;
            }
        }else if([status isEqualToString:@"error"]){
            NSLog(@"message : %@", responseDic[@"message"]);
            
            [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            [self.tableViewController.tableView footerEndRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        [self.tableViewController.tableView footerEndRefreshing];
    }];
}

- (void)saveCache{
    FTCache *cache = [FTCache sharedInstance];
    NSArray *dataArray = [[NSArray alloc]initWithArray:self.tableViewDataSourceArray];
    FTCacheBean *cacheBean = [[FTCacheBean alloc] initWithTimeStamp:[[NSDate date] timeIntervalSince1970]  andDataArray:dataArray];
    
    [cache.newsDataDic setObject:cacheBean forKey:[NSString stringWithFormat:@"%ld", self.currentSelectIndex]];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载



#pragma mark - 按钮事件
//
- (void)clickAction:(UIButton *)sender
{
    if(self.currentSelectIndex != sender.tag - 1){
        //        self.currentSelectIndex = sender.tag-1;
        //        FTTableViewController *tableVC = [self controllerWithSourceIndex:sender.tag-1];
        //        [self.pageViewController setViewControllers:@[tableVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        //            NSLog(@" 设置完成 ");
        //        }];
        self.currentSelectIndex = sender.tag-1;//根据点击的按钮，设置当前的选中下标
        
        //根据当前下标，先去缓存中查找是否有数据
        FTCache *cache = [FTCache sharedInstance];
        FTCacheBean *cacheBean = [cache.newsDataDic objectForKey:[NSString stringWithFormat:@"%ld", self.currentSelectIndex]];
        
        if (cacheBean) {//如果有当前标签的缓存，则接着对比时间
            
            if (self.currentSelectIndex == 0) {
                
                self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
            }else{
                self.tableViewController.tableView.tableHeaderView = nil;
            }
            
            NSTimeInterval currentTS = [[NSDate date]timeIntervalSince1970];
            NSTimeInterval timeGap = currentTS - cacheBean.timeStamp;
            if (timeGap < 5 * 60) {//如果在5分钟内，而且videoTag一样，则用缓存
                self.tableViewDataSourceArray = [[NSMutableArray alloc]initWithArray:cacheBean.dataArray];
                self.tableViewController.sourceArray = self.tableViewDataSourceArray;
                [self.tableViewController.tableView reloadData];
                return;
            }
        }
        
        
        self.tableViewController.sourceArray = nil;
        [self.tableViewController.tableView reloadData];
        
        [self getDataWithGetType:@"new" andCurrId:@"-1"];
    }
}


- (IBAction)leftButtonItemClick:(id)sender {
    
    
    
    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }
}


#pragma mark - PrivateAPI
//
- (FTTableViewController *)controllerWithSourceIndex:(NSInteger)index
{
    if (self.sourceArry.count < index) {
        return nil;
    }
    NSLog(@"%ld", index);
    //    FTTableViewController *tableVC = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
    if (index == 0) {
        self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    }else{
        [self.tableViewController.tableView.tableHeaderView removeFromSuperview];
        self.tableViewController.tableView.tableHeaderView = nil;
    }
    //    self.tableViewController.sourceArrry = _sourceArry[index];
    self.tableViewController.order = index;
    return self.tableViewController;
}

//返回当前的索引值
- (NSInteger)indexofController:(FTTableViewController *)viewController
{
    //    NSInteger index = [self.sourceArry indexOfObject:viewController.sourceArray];
    //    return index;
    return self.tableViewController.order;
}



#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self controllerWithSourceIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.sourceArry count]) {
        return nil;
    }
    return [self controllerWithSourceIndex:index];
}


#pragma mark - UIPageViewControllerDelegate
//即将转换开始的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    //    NSLog(@" 开始动画  %@ ",[pendingViewControllers valueForKey:@"sourceArray"]);
}


//动画结束后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)complete
{
    FTTableViewController *VC = [pageViewController.viewControllers lastObject];
    self.currentSelectIndex = [self indexofController:VC];
    //    NSLog(@" 动画结束 %@ ",pageViewController.viewControllers);
}
- (IBAction)searchButtonClicked:(id)sender {
    NSLog(@"search button clicked.");
}

#pragma -mark -排行榜按钮被点击
- (IBAction)rankButtonClicked:(id)sender {
    
    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
    rankHomeVC.title = @"格斗之王";
    [self.navigationController pushViewController:rankHomeVC animated:YES];
    
    
    //    FTRankingListViewController *rankingListViewController = [FTRankingListViewController new];
    //    [self.navigationController pushViewController:rankingListViewController animated:YES];
    //    rankingListViewController.title = @"格斗之王";
}

- (IBAction)messageButtonClicked:(id)sender {
    NSLog(@"message button clicked.");
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"---点击了第%ld张图片", (long)index);
    
    FTNewsDetail2ViewController *newsDetailViewController = [FTNewsDetail2ViewController new];
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = self.cycleDataSourceArray[index];
    FTNewsBean *bean = [FTNewsBean new];
    [bean setValuesWithDic:newsDic];
    
    newsDetailViewController.newsBean = bean;
    
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
}

- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
    //    NSLog(@"第%ld个cell被点击了。", indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTNewsDetail2ViewController *newsDetailVC = [FTNewsDetail2ViewController new];
        //获取对应的bean，传递给下个vc
        NSDictionary *newsDic = tableView.sourceArray[indexPath.row];
        FTNewsBean *bean = [FTNewsBean new];
        [bean setValuesWithDic:newsDic];
        
        newsDetailVC.newsBean = bean;
        newsDetailVC.delegate = self;
        newsDetailVC.indexPath = indexPath;
        
        
        [self.navigationController pushViewController:newsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}
- (IBAction)filterButton:(id)sender {
    FTFilterTableViewController *filterTableViewController = [FTFilterTableViewController new];
    
    [self.typeArray[0] removeObjectAtIndex:0];
    filterTableViewController.arr = self.typeArray;
    filterTableViewController.delegate = self;
    [self.tabBarController.navigationController pushViewController:filterTableViewController animated:YES];
    filterTableViewController.navigationItem.title = @"选择类别";
}

//实现filterVC的代理，回调更新typeArray,刷新界面
- (void)updateTypeArray:(NSArray *)typeArray{
    [typeArray[0] insertObject:@"全部" atIndex:0];
    self.typeArray = typeArray;
    [self initSubViews];
}

- (void)updateCountWithNewsBean:(FTNewsBean *)newsBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
}



@end
