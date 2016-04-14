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
#import "FTNewsDetailViewController.h"



@interface FTInformationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;


@end

@implementation FTInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews{
        //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
        //设置状态栏的颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //设置右上角的按钮
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-搜索pre"] forState:UIControlStateHighlighted];
    [self.messageButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-消息pre"] forState:UIControlStateHighlighted];
    [self setOtherViews];
    [self getCycleData];
    [self getData];
}

- (void)getCycleData{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *newsType = @"Hot";
    NSString *newsCurrId = @"-1";
    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@", urlString, newsType, newsCurrId, getType, ts, checkSign];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"url : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSLog(@"ok");
            self.cycleDataSourceArray = responseDic[@"data"];
//            NSLog(@"%@", self.cycleDataSourceArray);
            [self setCycleScrollView];
            [self initPageController];
//            [self.tableViewController.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)getData{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsURL];
    NSString *newsType = @"All";
    NSString *newsCurrId = @"-1";
    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",newsType, newsCurrId, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?newsType=%@&newsCurrId=%@&getType=%@&ts=%@&checkSign=%@", urlString, newsType, newsCurrId, getType, ts, checkSign];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"news's url : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSLog(@"ok");
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
            NSMutableArray *hotArray = [NSMutableArray new];
            for(NSDictionary *dic in mutableArray){
                if ([dic[@"newsType"] isEqualToString:@"Hot"]) {
                    [hotArray addObject:dic];
                }
            }
            [mutableArray removeObjectsInArray:hotArray];
            self.tableViewDataSourceArray = mutableArray;
            [self initPageController];
            [self.tableViewController.tableView reloadData];
        }

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)setOtherViews{
    //设置分类栏
    [self setTypeNaviScrollView];
}

- (void)setTypeNaviScrollView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    self.sourceArry = @[@[@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1"],@[@"测试2",@"测试2",@"测试2",@"测试2",@"测试2",@"测试2"],@[@"测试3",@"测试3",@"测试3",@"测试3",@"测试3",@"测试3"],@[@"测试4",@"测试4",@"测试4",@"测试4",@"测试4",@"测试4"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"], @[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"]];
    
    [self initPageController];
    
}

- (void)setCycleScrollView{
    NSArray *imagesURLStrings = [NSArray new];
    if (self.cycleDataSourceArray) {
         imagesURLStrings =@[
                                     self.cycleDataSourceArray[0][@"img_big"],
                                     self.cycleDataSourceArray[1][@"img_big"]
                                     ];
    }
    //图片配文字
    NSArray *titles = @[@"test1 ",
                        @"test2",
                        @"test3",
                        @"test4"
                        ];

      _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.titlesGroup = titles;
    _cycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载
//视图加载
- (void)initView
{
    NSArray *titles = @[@"全部",@"拳击",@"自由搏击", @"散打", @"综合格斗",@"泰拳", @"跆拳道", @"柔道", @"空手道"];
    float curContentWidth = 0;
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
    }
    
    self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    
    if (self.tableViewDataSourceArray) {
    self.tableViewController.sourceArrry = self.tableViewDataSourceArray;
    }else{
    self.tableViewController.sourceArrry = _sourceArry[0];
    }

    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0}];
    self.pageViewController = pageVC;
    [pageVC.view setFrame:_currentView.bounds];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    [pageVC setViewControllers:@[self.tableViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        NSLog(@" 设置完成 ");
    }];
    [self addChildViewController:pageVC];
    [_currentView addSubview:[pageVC view]];
}



#pragma mark - 按钮事件
//
- (void)clickAction:(UIButton *)sender
{
    if(self.currentSelectIndex != sender.tag - 1){
        self.currentSelectIndex = sender.tag-1;
        FTTableViewController *tableVC = [self controllerWithSourceIndex:sender.tag-1];
        [self.pageViewController setViewControllers:@[tableVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            NSLog(@" 设置完成 ");
        }];
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
    FTTableViewController *tableVC = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
    if (index == 0) {
        tableVC.tableView.tableHeaderView = self.cycleScrollView;
    }
    tableVC.sourceArrry = _sourceArry[index];
    return tableVC;
}

//返回当前的索引值
- (NSInteger)indexofController:(FTTableViewController *)viewController
{
    NSInteger index = [self.sourceArry indexOfObject:viewController.sourceArrry];
    return index;
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
    
//    //设置scrollView的偏移位置
//    CGRect frame = [self.view convertRect:selectbt.frame fromView:selectbt.superview];
    CGRect frame = selectbt.frame;
    if (frame.origin.x + frame.size.width > SCREEN_WIDTH - 49) {
        NSLog(@"要滚出去了");
        NSInteger x = _currentScrollView.contentOffset.x;
//        [_currentScrollView setContentOffset:CGPointMake(frame.origin.x + selectbt.frame.size.width - SCREEN_WIDTH + x, 0) animated:YES];
                [_currentScrollView setContentOffset:CGPointMake(200, 0) animated:YES];
//        _currentScrollView.contentOffset = CGPointMake(200, 0);
    }
    else if (frame.origin.x < 0){
        [_currentScrollView setContentOffset:CGPointZero animated:YES];
    }
    
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
    //    NSLog(@" 开始动画  %@ ",[pendingViewControllers valueForKey:@"sourceArrry"]);
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
    NSLog(@"---点击了第%ld张图片", (long)index);
    FTNewsDetailViewController *newsDetailVC = [FTNewsDetailViewController new];
    newsDetailVC.urlString = self.cycleDataSourceArray[index][@"url"];
    
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}
@end
