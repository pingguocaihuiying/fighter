//
//  FTBoxingBarMainViewController.m
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//
#define FOLLOWED_MODULE @"关注版块"

#import "FTBoxingBarMainViewController.h"

#import "FTSegmentButtonView.h"//导入二选按钮
#import "FTBoxingBarModuleCollectionView.h"//导入显示模块的collectionView
#import "FTPostListViewController.h"//导入帖子列表（按摩快）vc
#import "FTPostListTableView.h"//导入帖子列表tableView
#import "FTModuleBean.h" //导入版块bean

#import "FTTableViewController.h"
#import "JHRefresh.h"
#import "DBManager.h"
#import "FTArenaPostsDetailViewController.h"

@interface FTBoxingBarMainViewController ()<FTSegmentButtonViewDelegate, FTCollectionViewDelegate, FTTableViewdelegate, FTArenaDetailDelegate>

@property (strong, nonatomic) IBOutlet UIView *segButtonViewContainer;//二选按钮容器view
@property (nonatomic, strong) FTSegmentButtonView *segButtonView;//二选按钮
@property (strong, nonatomic) IBOutlet UIView *mainContentView;//主内容view：根据情况展示collectionView或tableView
@property (nonatomic, strong) FTBoxingBarModuleCollectionView *moduleCollectionView;//显示模块的collectionView
//@property (nonatomic, strong) FTPostListTableView *postListTableView;//显示帖子列表的tableView

@property (nonatomic, copy)NSString *currentIndexString;
@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;

/**
 一维：存储一个类别的所有版块
 二维是一个地点，key为类别名称，value为数组，存放该类别下的所有版块
 */
@property (nonatomic, strong) NSMutableArray *moduleBeanArray;//存储版块的数组
@property (nonatomic, strong) NSMutableDictionary *followedModuleDic;//我关注的版块

@end

@implementation FTBoxingBarMainViewController


- (void)viewDidAppear:(BOOL)animated{
    [self loadModuleDataFromServer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];//初始化一些基本配置
    [self setSubViews];//设置子view
    //默认显示模块列表
    [self leftButtonClicked];

    
    [self initBaseConfig];
    [self initPageController];
    
    [self getDataFromDB];
    [self getDataFromWeb];//初次加载数据
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


- (void)initPageController
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeArena;
        self.tableViewController.FTdelegate = self;
        self.tableViewController.tableView.hidden = YES;//默认隐藏
        //设置上拉、下拉刷新
        [self setJHRefresh];
    }
    
    //    self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    
    if (self.tableViewDataSourceArray) {
        [self.tableViewController.tableView footerEndRefreshing];
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        //    self.tableViewController.sourceArray = _sourceArry[0];
        NSLog(@"没有数据源。");
    }
    self.tableViewController.tableView.frame = _mainContentView.bounds;
    [_mainContentView addSubview:self.tableViewController.tableView];
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

#pragma mark -get data
-(void) getDataFromDB {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchArenasWithLabel:_labels hotTag:_query];
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
    
}

-(void) getDataFromWeb {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@&source=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName, @"1"];
    
    NSLog(@"arena list urlString:%@",urlString);
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        //        NSLog(@"responseDic:  %@", responseDic);
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            //            NSLog(@"AreaDic:%@",responseDic);
            if ([status isEqualToString:@"success"]) {
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                //缓存数据到DB
                if (mutableArray.count > 0) {
                    DBManager *dbManager = [DBManager shareDBManager];
                    [dbManager connect];
                    [dbManager cleanArenasTable];
                    
                    for (NSDictionary *dic in mutableArray)  {
                        [dbManager insertDataIntoArenas:dic];
                    }
                    
                    [self getDataFromDB];
                }else if (mutableArray.count == 0){//如果返回一个空的数组，说明没有数据
                    [self.tableViewDataSourceArray removeAllObjects];
                    self.tableViewController.sourceArray = self.tableViewDataSourceArray;
                    [self.tableViewController.tableView reloadData];
                }
                
                
                
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                [self.tableViewController.tableView footerEndRefreshing];
            }else {
                //                [self getDataFromDB];
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
                [self.tableViewController.tableView footerEndRefreshing];
            }
            
        }else {
            //            [self getDataFromDB];
            [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
            [self.tableViewController.tableView footerEndRefreshing];
        }
    }];
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

- (void)setSubViews{
    /*
     初始化二选按钮
     */
    [self initSegmentButtonView];
    
    /*
        初始化collectionView
     */
    [self initCollectionView];
    
    //初始化tableView
//    [self initTableView];
    
}

#pragma mark 初始化二选按钮
- (void)initSegmentButtonView{
    _segButtonView = [[[NSBundle mainBundle]loadNibNamed:@"FTSegmentButtonView" owner:self options:nil] firstObject];
    _segButtonView.frame = _segButtonViewContainer.bounds;
    
    //设置按钮title
    [_segButtonView.buttonLeft setTitle:@"版块分类" forState:UIControlStateNormal];
    [_segButtonView.buttonRight setTitle:@"最新最热" forState:UIControlStateNormal];
    
    _segButtonView.delegate = self;//设置代理
    
    [_segButtonViewContainer addSubview:_segButtonView];
}

- (void)leftButtonClicked{
    _moduleCollectionView.hidden = NO;//显示模块列表
//    _postListTableView.hidden = YES;//隐藏帖子列表
    self.tableViewController.tableView.hidden = YES;
    
    [self loadModuleDataFromServer];
}

- (void)rightButtonClicked{
    _moduleCollectionView.hidden = YES;//隐藏模块列表
//    _postListTableView.hidden = NO;//显示帖子列表
    self.tableViewController.tableView.hidden = NO;
    
    [self.tableViewController.tableView reloadData];
}

#pragma mark 加载数据
- (void)loadModuleDataFromServer{
    [NetWorking getBoxingBarSectionsWithOption:^(NSDictionary *dic) {
        if ([dic[@"status"] isEqualToString:@"success"]) {
            [self handleResponseArray:dic[@"data"]];
//            _moduleCollectionView.moduleBeanArray = _moduleBeanArray;
            [_moduleCollectionView setWithData:_moduleBeanArray];
            [_moduleCollectionView.collectionView reloadData];
        }else{
//            [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:[NSString stringWithFormat:@"%@", dic[@"message"]]];
            [self.view showMessage:dic[@"message"]];
        }
    }];
}


/**
 把服务器返回的版块数组按所属类别分类存储

 @param array 版块数组
 */
- (void)handleResponseArray:(NSArray *)array{
    
    if (!_moduleBeanArray) {//如果不存在，初始化
        _moduleBeanArray = [NSMutableArray new];
    } else {//如果已经存在，置空
        [_moduleBeanArray removeAllObjects];
    }
    
    NSMutableArray *followedModuleArray;//我关注的array
    if (!_followedModuleDic) {//如果“我关注的”字典不存在，初始化
        _followedModuleDic = [NSMutableDictionary new];
        followedModuleArray = [NSMutableArray new];
        [_followedModuleDic setObject:followedModuleArray forKey:FOLLOWED_MODULE];
    } else {//如果“我关注的”字典已经存在，置空
        followedModuleArray = _followedModuleDic[FOLLOWED_MODULE];
        [followedModuleArray removeAllObjects];
    }
    
    //遍历源数组，转换为字典，并分类存储
    for(NSDictionary *moduleDic in array){
        //把字典转换为bean
        FTModuleBean *moduleBean = [FTModuleBean new];
        [moduleBean setValuesWithDic:moduleDic];
        
        //查找该分组字典是否存在
        NSMutableDictionary *categoryDic;
        for(NSMutableDictionary *dic in _moduleBeanArray){
            if([[[dic allKeys] firstObject] isEqualToString:moduleBean.category]){
                categoryDic = dic;
                break;
            }
        }
        
        NSMutableArray *moduleBeanArrayInTheCategory;
        if (!categoryDic) {//如果尚不存在，初始化字典和数组，并关联
            moduleBeanArrayInTheCategory = [NSMutableArray new];
            categoryDic = [NSMutableDictionary new];
            [_moduleBeanArray addObject:categoryDic];
            [categoryDic setValue:moduleBeanArrayInTheCategory forKey:moduleBean.category];//把数组赋值给字典
        }else{//如果已经存在，取出数组
            moduleBeanArrayInTheCategory = categoryDic[moduleBean.category];
        }
        [moduleBeanArrayInTheCategory addObject:moduleBean];//则把该bean追加进数组
        
        /*
            把我关注的另外存起来
         */
        if (moduleBean.followId > 0) {
            [followedModuleArray addObject:moduleBean];
        }
    }
    
    //把我关注的插入第一个
    [_moduleBeanArray insertObject:_followedModuleDic atIndex:0];
}

#pragma mark 显示模块的collectionView
- (void)initCollectionView{
    _moduleCollectionView = [[FTBoxingBarModuleCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 35 - 15)];
    _moduleCollectionView.delegate = self;//设置代理
    [_mainContentView addSubview:_moduleCollectionView];
    _moduleCollectionView.hidden = YES;
}

- (void)initTableView{
//    _postListTableView = [[FTPostListTableView alloc]initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 6 * 2, SCREEN_HEIGHT - 64 - 44 - 35 - 15)];//6为边距
//    
//    [_mainContentView addSubview:_postListTableView];
//    _postListTableView.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    NSDictionary *categoryDic = _moduleBeanArray[indexPath.section];
    FTModuleBean *moduleBean = [categoryDic.allValues firstObject][indexPath.row];
    
    FTPostListViewController *postListViewController = [FTPostListViewController new];
    postListViewController.moduleBean = moduleBean;
    [self.navigationController pushViewController:postListViewController animated:YES];
}
- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}
@end
