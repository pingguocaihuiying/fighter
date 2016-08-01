//
//  FTInformationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

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
#import "FTRankingListViewController.h"
#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTRankViewController.h"
#import "DBManager.h"
#import "NetWorking.h"
#import "FTLYZButton.h"
#import "FTHomepageMainViewController.h"
#import "FTShareView.h"

@interface FTInformationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate, FTnewsDetailDelegate,FTTableViewdelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property (nonatomic, copy)NSString *currentItemValueEn;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, strong)UIView *headerView;

@property (nonatomic) NSInteger currentPage;


@end

@implementation FTInformationViewController

- (void)viewDidLoad {
//        NSLog(@"拳讯 view的宽度：%f,高度：%f",self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
    [self initTypeArray];//初始化标签数据
    [self initSubViews];
    [self getCycleData];//初次加载轮播图数据
    [self getDataFromDBWithType:@"new" currentPage:self.currentPage];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//初次加载数据
    
    
    [self.bottomGradualChangeView setHidden:YES];
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

- (void)initTypeArray{
//    NSMutableArray *enableTypeArray = [[NSMutableArray alloc]initWithArray:@[@"全部", @"拳击", @"自由搏击", @"综合格斗", @"泰拳", @"跆拳道"]];
//    NSMutableArray *enableTypeArray = [[NSMutableArray alloc]initWithArray:@[@"全部", @"综合格斗(UFC)", @"拳击", @"摔跤(WWE)", @"女子格斗", @"泰拳", @" 跆拳道", @"柔道", @"相扑"]];
    NSMutableArray *enableTypeArray = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
    [enableTypeArray insertObject:@{@"itemValueEn":@"All", @"itemValue":@"全部"} atIndex:0];
    [enableTypeArray insertObject:@{@"itemValueEn":@"News", @"itemValue":@"新闻"} atIndex:7];
    [enableTypeArray removeLastObject];
//    NSMutableArray *disableTypeArray= [[NSMutableArray alloc]initWithArray:@[@"柔道", @"空手道", @"截拳道", @"摔跤", @"相扑"]];
    
    NSMutableArray *disableTypeArray= [[NSMutableArray alloc]init];
    self.typeArray = @[enableTypeArray, disableTypeArray];
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

- (void)getCycleData{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *newsType = @"Hot";
    NSString *newsCurrId = @"-1";
    NSString *getType = @"0";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsType, newsCurrId, getType, ts, checkSign, [FTNetConfig showType]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSLog(@"轮播图url : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            self.cycleDataSourceArray = responseDic[@"data"];
            
            [self setCycleScrollView];
            [self initPageController];
            
                //隐藏infoLabel
            if (self.infoLabel.isHidden == NO) {
                self.infoLabel.hidden = YES;
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
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
        self.tableViewController.tableView.tableHeaderView = self.headerView;
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
    [self initNewsTypeScrollView];
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
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375 +15)];
    [_headerView setBackgroundColor:[UIColor clearColor]];
    
    
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

    [_headerView addSubview:_cycleScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载
//加载分类导航的scrollView
- (void)initNewsTypeScrollView
{
     NSArray *titlesArray = self.typeArray[0];
    float curContentWidth = 0;
    for(UIView *view in [_currentScrollView subviews]){
        [view removeFromSuperview];
    }
    for (int i = 0; i < titlesArray.count; i++) {
        FTLYZButton *bt = [[FTLYZButton alloc]init];
        NSDictionary *dic = titlesArray[i];
        bt.itemValue = dic[@"itemValue"];
        bt.itemValueEn = dic[@"itemValueEn"];
        [bt setTitle:bt.itemValue forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setTitleColor: Main_Text_Color forState:UIControlStateNormal];
        bt.tag = i+1;
        
        //设置button的宽度
        NSString *content = bt.titleLabel.text;
        UIFont *font = bt.titleLabel.font;
        CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
        CGSize buttonSize = [content boundingRectWithSize:size
                                                  options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{ NSFontAttributeName:font}
                                                  context:nil].size;
        
        [bt setFrame:CGRectMake(curContentWidth, 0, buttonSize.width, 40)];
        
        [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_currentScrollView addSubview:bt];
        
        
        //添加button下方的指示view
        bt.indexView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, buttonSize.width, 3)];
        bt.indexView.backgroundColor = [UIColor redColor];
        bt.indexView.tag = 1000 + i;
        bt.indexView.hidden = YES;
        if ([bt.itemValueEn isEqualToString:@"All"]) {
                bt.indexView.hidden = NO;
        }
        [bt addSubview:bt.indexView];
        
       
        if (i != titlesArray.count - 1) {
            curContentWidth += buttonSize.width + 35;
        }else{
            curContentWidth += buttonSize.width;
        }
    }
    _currentItemValueEn = @"All";
    _currentScrollView.showsHorizontalScrollIndicator = NO;
    _currentScrollView.bounces = YES;
    
    _currentScrollView.contentSize = CGSizeMake(curContentWidth, 40);
}

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
    
    self.tableViewController.tableView.tableHeaderView = self.headerView;
    
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
        if ([sself.currentItemValueEn isEqualToString:@"All"]) {//如果是“全部”标签，再刷新轮播图
            [sself getCycleData];
        }
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

#pragma mark - 按钮事件
//
- (void)clickAction:(FTLYZButton *)sender{
    
    //根据点击的按钮，更新当前button的标签，并更新下标
    self.currentItemValueEn = sender.itemValueEn;
    [self updateButtonsIndex];
    
    //只有选中全部时，才显示轮播图
    if ([_currentItemValueEn isEqualToString:@"All"]) {
        self.tableViewController.tableView.tableHeaderView = self.headerView;
    }else{
        
        self.tableViewController.tableView.tableHeaderView = nil;
    }
    
        
        //根据当前下标，先去缓存中查找是否有数据
        FTCache *cache = [FTCache sharedInstance];
        FTCacheBean *cacheBean = [cache.newsDataDic objectForKey:[NSString stringWithFormat:@"%@", _currentItemValueEn]];
        
        if (cacheBean) {//如果有当前标签的缓存，则接着对比时间
            
            if ([self.currentItemValueEn isEqualToString:@"All"]) {
                self.tableViewController.tableView.tableHeaderView = self.headerView;
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
        self.tableViewController.tableView.tableHeaderView = self.headerView;
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

#pragma mark -  设置当前的按钮颜色

- (void)updateButtonsIndex{
    for(UIView *subview in[_currentScrollView subviews]){
        if ([subview isKindOfClass:[FTLYZButton class]]) {
            FTLYZButton *button = (FTLYZButton *)subview;
            if ([button.itemValueEn isEqualToString:_currentItemValueEn]) {
                button.indexView.hidden = NO;
            }else{
                if (button.indexView.isHidden == NO) {
                    button.indexView.hidden = YES;
                }
            }
        }
    }
}

- (void)setCurrentSelectIndex:(NSString *)currentItemValueEn
{
    
//    //取消上面的背景色
//    if (_currentSelectIndex != NSNotFound) {
//        UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
//        indexView.hidden = YES;
//    }
//    
//    _currentSelectIndex = index;
//    UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
//    indexView.hidden = NO;
//    
//    UIButton *selectbt = [_currentScrollView viewWithTag:_currentSelectIndex + 1];
//    
//    NSLog(@"scroll");
//    
////    设置scrollView的偏移位置
//
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    self.currentPage = 0;
    return [self controllerWithSourceIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    self.currentPage = 0;
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


#pragma mark - FTTableViewdelegate
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

- (void)fttableView:(FTTableViewController *)tableView didSelectShareButton:(NSIndexPath *)indexPath {

    if (self.tableViewDataSourceArray) {
        
        FTNewsBean *bean = tableView.sourceArray[indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-news",bean.newsId];
        NSString *webUrl = [@"http://www.gogogofight.com/page/news_page.html?" stringByAppendingString:str];
        
        FTShareView *shareView = [FTShareView new];
        [shareView setUrl:webUrl];
        [shareView setTitle:bean.title];
        [shareView setSummary:bean.summary];
        [shareView setImage:@"微信用@200"];
        
        if ([bean.layout isEqualToString:@"1"]) {//大图
            [shareView setImageUrl:bean.img_big];
        }else if ([bean.layout isEqualToString:@"2"]) {//图
            [shareView setImageUrl:bean.img_small_one];
        }else if ([bean.layout isEqualToString:@"3"]) {//3图
            [shareView setImageUrl:bean.img_small_one];
        }
        
//        [self.view addSubview:shareView];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    }
    
}
#pragma -mark -排行榜按钮被点击
- (IBAction)rankButtonClicked:(id)sender {
//    [self gotoHomepageWithUseroldid:nil];
    

    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
//    rankHomeVC.title = @"排行榜";
//    [self.navigationController pushViewController:rankHomeVC animated:YES];
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




#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic {

    FTNewsDetail2ViewController *newsDetailVC = [FTNewsDetail2ViewController new];
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-news",dic[@"objId"]];
    
    newsDetailVC.webUrlString = [@"http://www.gogogofight.com/page/news_page.html?" stringByAppendingString:str];
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

- (void)updateCountWithNewsBean:(FTNewsBean *)newsBean indexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
//    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.voteCount] forKey:@"voteCount"];
//    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.commentCount] forKey:@"commentCount"];

  
    self.tableViewController.sourceArray[indexPath.row] = newsBean;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
}
@end
