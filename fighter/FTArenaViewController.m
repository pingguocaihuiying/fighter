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
#import "FTNewPostViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

#import "FTArenaBean.h"
#import "FTArenaPostsDetailViewController.h"
#import "NetWorking.h"
#import "DBManager.h"
#import "FTRankViewController.h"

@interface FTArenaViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate, FTArenaDetailDelegate, FTSelectCellDelegate,FTTableViewdelegate>

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

@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@end

@implementation FTArenaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self initPageController];
    
    [self getDataFromDB];
    [self getDataFromWeb];//初次加载数据
//    [self reloadDate];
    
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [MobClick event:@"mainPage_BoxingNews"];
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
    _query = @"list-dam-blog-1";
    _pageNum = @"1";
    _pageSize = @"10";
    _labels = @"";
}

- (void)initSubviews{
    
    //设置左上角按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.leftBtn.layer setMasksToBounds:YES];
    self.leftBtn.layer.cornerRadius = 17.0;
    [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"头像-空"]];
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftBtn];
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
        NSLog(@"触发下拉刷新headerView");
        //下拉时请求最新的一页数据
        _pageNum = @"1";
//        [sself reloadDate];
        [sself getDataFromWeb];
    }];
    //设置上拉刷新
    [self.tableViewController.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
                NSLog(@"上拉刷新");
        //如果没有本地数据，pageNum不＋1
        if (self.tableViewController.sourceArray.count > 0) {
            //上拉时追加数据，把pageNum＋1
            int pageNumInt = [sself.pageNum intValue];
            pageNumInt++;
            _pageNum = [NSString stringWithFormat:@"%d", pageNumInt];
        }

//        [sself reloadDate];
        [sself getDataFromWeb];
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
    _query = @"list-dam-blog-3";
//    [self reloadDate];
    [self getDataFromWeb];
}

#pragma -mark -下拉框
- (void)setDropDown:(id)sender{

    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
    
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleLeft option:^(FTRankTableView *searchTableView) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
        [tempArray insertObject:@{@"itemValue":@"全部视频", @"itemValueEn":@"All"} atIndex:0];
         searchTableView.dataArray = tempArray;
        
        searchTableView.Btnframe = frame;
        searchTableView.tableW =frame.size.width;
        
         searchTableView.offsetX = -10;
         searchTableView.offsetY = 28;
        searchTableView.tableW = 100;
        searchTableView.tableH = 350;
    }];
    kindTableView.selectDelegate = self;
    [self.view addSubview:kindTableView];
    
    [kindTableView  setAnimation];
    
    [kindTableView setDirection:FTAnimationDirectionToTop];
}

- (void) selectedValue:(NSDictionary *)value{
    
        //如果点击的仍然是当前类别的，则跳过不刷新数据
    NSLog(@"_labels : %@, itemValueEn : %@",_labels, value[@"itemValueEn"]);
    if([_labels isEqualToString:value[@"itemValueEn"]]){
        return;
    }else if([_labels isEqualToString:@""] && [value[@"itemValueEn"] isEqualToString:@"All"]){
        return;
    }

    //根据点击的标签，去设置不同的请求参数
    if ([value[@"itemValue"] isEqualToString:@"全部视频"]) {
        NSLog(@"全部视频%@", value[@"itemValueEn"]);
        _query = @"list-dam-blog-1";
        _labels = @"";
    }else{
        NSLog(@"%@", value[@"itemValueEn"]);
        _query = @"list-dam-blog-2";
        _labels = value[@"itemValueEn"];
    }
    
    //先去找是否有缓存
        //根据当前下标，先去缓存中查找是否有数据
        FTCache *cache = [FTCache sharedInstance];
        FTCacheBean *cacheBean = [cache.arenaDataDic objectForKey:[NSString stringWithFormat:@"%@", self.labels]];
        
        if (cacheBean) {//如果有当前标签的缓存，则接着对比时间
            
            NSTimeInterval currentTS = [[NSDate date]timeIntervalSince1970];
            NSTimeInterval timeGap = currentTS - cacheBean.timeStamp;
            if (timeGap < 5 * 60) {//如果在5分钟内，则用缓存
                self.tableViewDataSourceArray = [[NSMutableArray alloc]initWithArray:cacheBean.dataArray];
                self.tableViewController.sourceArray = self.tableViewDataSourceArray;
                [self.tableViewController.tableView reloadData];
                return;
            }
        }
        self.tableViewController.sourceArray = nil;
        [self.tableViewController.tableView reloadData];
    

    
    //刷新数据
    _pageNum = @"1";
//    [self reloadDate];
    [self getDataFromWeb];
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
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        FTNewPostViewController *newPostViewController = [FTNewPostViewController new];
        newPostViewController.title = @"发新帖";
        [self.navigationController pushViewController:newPostViewController animated:YES];
        
    }
    
    
}

- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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
    [self.leftBtn.layer setMasksToBounds:YES];
    self.leftBtn.layer.cornerRadius = 17.0;
    [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftBtn];
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

#pragma mark -get data
-(void) getDataFromDB {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchArenasWithPage:[_pageNum integerValue] label:_labels];
    [dbManager close];
    
    
    if (self.tableViewDataSourceArray == nil) {
        self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
    }
    if ([_pageNum isEqualToString:@"1"]) {//如果是第一页数据，直接替换，不然追加
        self.tableViewDataSourceArray = mutableArray;
    }else{
        [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
    }
    
    self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    
    
    [self.tableViewController.tableView reloadData];
    
    [self saveCache];
    //隐藏infoLabel
    if (self.infoLabel.isHidden == NO) {
        self.infoLabel.hidden = YES;
    }
}

-(void) getDataFromWeb {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    
//    NSLog(@"urlString:%@",urlString);
    NetWorking *net = [[NetWorking alloc]init];
    
    NSLog(@"arena list url :  %@", urlString);
    
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
//            NSLog(@"AreaDic:%@",responseDic);
            if ([status isEqualToString:@"success"]) {
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                DBManager *dbManager = [DBManager shareDBManager];
                [dbManager connect];
                
                for (NSDictionary *dic in mutableArray)  {
                    [dbManager insertDataIntoArenas:dic];
                }
                
                [self getDataFromDB];
                
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                [self.tableViewController.tableView footerEndRefreshing];
            }else {
                [self getDataFromDB];
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
                [self.tableViewController.tableView footerEndRefreshing];
            }

        }else {
            [self getDataFromDB];
            [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
            [self.tableViewController.tableView footerEndRefreshing];
        }
    }];
}

- (void)reloadDate{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSLog(@"arena list  url : %@", urlString);

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = responseDic[@"status"];
        NSString *message = responseDic[@"message"];
        NSLog(@"status : %@, message : %@", status, message);
        if ([status isEqualToString:@"success"]) {
            
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
            
//            [ZJModelTool createModelWithDictionary:mutableArray[0] modelName:nil];
            
            if (self.tableViewDataSourceArray == nil) {
                self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
            }
            if ([_pageNum isEqualToString:@"1"] && mutableArray.count > 0) {//如果是1⃣️第一页数据2⃣️加载到的数据不为空，直接替换，不然追加
                self.tableViewDataSourceArray = mutableArray;
            }else{
                [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
            }
            
            self.tableViewController.sourceArray = self.tableViewDataSourceArray;
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
            NSLog(@"data : %@", responseDic[@"data"]);
            
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
    
    [cache.arenaDataDic setObject:cacheBean forKey:[NSString stringWithFormat:@"%@", self.labels]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - response
- (IBAction)leftBtnClickAction:(id)sender {
    
    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }
}

- (IBAction)rankBtnAction:(id)sender {
    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
    //    rankHomeVC.title = @"排行榜";
    [self.navigationController pushViewController:rankHomeVC animated:YES];
}


#pragma mark 排行榜按钮被点击
- (IBAction)rankButtonClicked:(id)sender {
    
    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
    
    [self.navigationController pushViewController:rankHomeVC animated:YES];
    
}

- (IBAction)messageButtonClicked:(id)sender {
    NSLog(@"message button clicked.");
}


- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
    //    NSLog(@"第%ld个cell被点击了。", indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTArenaPostsDetailViewController *postsDetailVC = [FTArenaPostsDetailViewController new];
        //获取对应的bean，传递给下个vc
//        NSDictionary *newsDic = tableView.sourceArray[indexPath.row];
//        FTArenaBean *bean = [FTArenaBean new];
//        [bean setValuesWithDic:newsDic];
        
        
        FTArenaBean *bean = tableView.sourceArray[indexPath.row];
        //标记已读
        if (![bean.isReader isEqualToString:@"YES"]) {
            bean.isReader = @"YES";
            //从数据库取数据
            DBManager *dbManager = [DBManager shareDBManager];
            [dbManager connect];
            [dbManager updateArenasById:bean.postsId isReader:YES];
            [dbManager close];
            
        }
        postsDetailVC.arenaBean = bean;
        postsDetailVC.delegate = self;
        postsDetailVC.indexPath = indexPath;
        
        
        [self.navigationController pushViewController:postsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}

#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic {
    
    FTArenaPostsDetailViewController *newsDetailVC = [FTArenaPostsDetailViewController new];
    newsDetailVC.webUrlString = dic[@"url"];
    [self.navigationController pushViewController:newsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    
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


- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
}


@end
