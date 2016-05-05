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


@interface FTInformationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;

@end

@implementation FTInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTypeArray];
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
//    self.tabBarController.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
//        self.tabBarController.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBarHidden = NO;
}

- (void)initTypeArray{
//    NSMutableArray *enableTypeArray = [[NSMutableArray alloc]initWithArray:@[@"全部", @"拳击", @"自由搏击", @"综合格斗", @"泰拳", @"跆拳道"]];
    NSMutableArray *enableTypeArray = [[NSMutableArray alloc]initWithArray:@[@"全部", @"综合格斗(UFC)", @"拳击", @"摔跤(WWE)", @"女子格斗", @"泰拳", @" 跆拳道", @"柔道", @"相扑"]];
    NSMutableArray *disableTypeArray= [[NSMutableArray alloc]initWithArray:@[@"柔道", @"空手道", @"截拳道", @"摔跤", @"相扑"]];
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
    [self.leftNavButton sd_setBackgroundImageWithURL:[NSURL URLWithString:localUser.headpic]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"头像-空"]];
    [self setOtherViews];
    [self getCycleData];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];
}

- (void)getCycleData{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *newsType = @"Hot";
    NSString *newsCurrId = @"-1";
    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsType, newsCurrId, getType, ts, checkSign, ShowType];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"轮播图url : %@", urlString);
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
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@", urlString, newsType, newsCurrId, getType, ts, checkSign, ShowType];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"news's url : %@", urlString);
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
      _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375) delegate:self placeholderImage:[UIImage imageNamed:@"空图标大"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;

#pragma -mark -暂时隐藏轮播图的标题（没有给轮播图传title的值）
    _cycleScrollView.titlesGroup = titlesArray;
    
    _cycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//    [_cycleScrollView.mainView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载
//加载分类导航的scrollView
- (void)initNewsTypeScrollView
{
     NSArray *titles = self.typeArray[0];
    float curContentWidth = 0;
    for(UIView *view in [_currentScrollView subviews]){
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];

        [bt setTitle:titles[i] forState:UIControlStateNormal];
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
        UIView *indexView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, buttonSize.width, 3)];
        indexView.backgroundColor = [UIColor redColor];
        indexView.tag = 1000 + i;
        indexView.hidden = YES;
        [bt addSubview:indexView];
        
       
        
        if (i != titles.count - 1) {
            curContentWidth += buttonSize.width + 35;
        }else{
            curContentWidth += buttonSize.width;
        }
    }
    self.currentSelectIndex = 0;
    _currentScrollView.showsHorizontalScrollIndicator = NO;
    _currentScrollView.bounces = YES;
    
    _currentScrollView.contentSize = CGSizeMake(curContentWidth, 40);
}

- (void)initPageController
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.newsOrVideo = @"news";
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

//    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0}];
//    self.pageViewController = pageVC;
//    [pageVC.view setFrame:_currentView.bounds];
//    pageVC.delegate = self;
//    pageVC.dataSource = self;
//    [pageVC setViewControllers:@[self.tableViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
//        NSLog(@" 设置完成 ");
//    }];
//    [self addChildViewController:pageVC];
//    [_currentView addSubview:[pageVC view]];
    self.tableViewController.tableView.frame = self.currentView.bounds;
    [self.currentView addSubview:self.tableViewController.tableView];
}

- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableViewController.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        [sself getDataWithGetType:@"new" andCurrId:@"-1"];
        if (self.currentSelectIndex == 0) {//如果是“全部”标签，再刷新轮播图
            [sself getCycleData];
        }
        

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
        
        if (self.currentSelectIndex == 0) {
            self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
        }else{
            self.tableViewController.tableView.tableHeaderView = nil;
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

#pragma mark - SET方法
//设置当前的按钮颜色
- (void)setCurrentSelectIndex:(NSInteger)index
{
    //取消上面的背景色
    if (_currentSelectIndex != NSNotFound) {
        UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
        indexView.hidden = YES;
    }
    
    _currentSelectIndex = index;
    UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
    indexView.hidden = NO;
    
    UIButton *selectbt = [_currentScrollView viewWithTag:_currentSelectIndex + 1];
    
    NSLog(@"scroll");
    
//    设置scrollView的偏移位置

    
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
    
    newsDetailViewController.bean = bean;
    
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

@end
