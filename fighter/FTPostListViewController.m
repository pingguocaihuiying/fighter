//
//  FTPostListViewController.m
//  fighter
//
//  Created by 李懿哲 on 28/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTPostListViewController.h"

#import "FTNewPostViewController.h"//导入发新帖
#import "FTPostListTableView.h"//导入自定义的tableView
#import "FTArenaViewController.h"// 测试
#import "UIViewController+FTLoginCheck.h"
#import "FTTableViewController.h"
#import "JHRefresh.h"
#import "DBManager.h"
#import "FTArenaPostsDetailViewController.h"

@interface FTPostListViewController ()<FTTableViewdelegate, FTArenaDetailDelegate>

@property (nonatomic, strong) FTPostListTableView *postListTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionDescLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, assign) BOOL isFollowed;//是否关注当前版块
@property (nonatomic, copy) NSString *followId;//如果关注的话，这个id会有值，仅用于给服务器传参

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, copy)NSString *currentIndexString;
@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;

@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;


@end

@implementation FTPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self setSubViews];
    
    //如果已经登录，再去获取关注状态
    if ([FTUserTools getLocalUser]) {
        [self getFollowStatus];//获取关注状态
    }
    
    [self initPageController];//初始化tableview
    
    [self getDataFromDB];//加载缓存
    [self getDataFromWeb];//初次加载数据
}

/**
 *  初始化一些默认数据
 */
- (void)initBaseConfig{
    NSLog(@"%@", NSHomeDirectory());
    _currentIndexString = @"all";
    _query = @"list-dam-blog-2";
    _pageNum = @"1";
    _pageSize = @"10";
    _labels = _moduleBean.name;
    _labels = [_labels stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _labels = @"";
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
    
//    self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    
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
        
        
        [self.navigationController pushViewController:postsDetailVC animated:YES];
    }
}

- (void)setSubViews{
    //设置导航栏
    [self setNaviViews];
    
    //根据moduleBean设置上方的显示
    [self setTopModuleDescView];
    
    //设置“关注”按钮
    [self setFollowButton];
}

#pragma mark - 设置导航栏
- (void)setNaviViews{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *newPostButton = [[UIBarButtonItem alloc]initWithTitle:@"发新帖" style:UIBarButtonItemStylePlain target:self action:@selector(newPostButtonClicked)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationItem.rightBarButtonItem = newPostButton;
    
    //设置默认标题
    self.navigationItem.title = _moduleBean.name;
}

/**
 返回上一个navi item
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newPostButtonClicked {
    //测试
//    FTArenaViewController *arenaViewController = [FTArenaViewController new];
//    [self.navigationController pushViewController:arenaViewController animated:YES];
//    return;
    
    NSLog(@"发新帖");
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [FTTools loginwithVC:self];
    }else{
        FTNewPostViewController *newPostViewController = [FTNewPostViewController new];
        newPostViewController.title = @"发新帖";
        newPostViewController.moduleBean = _moduleBean;
        [self.navigationController pushViewController:newPostViewController animated:YES];
    }
}

#pragma mark - 设置上方模块描述view
- (void)setTopModuleDescView{
    _sectionNameLabel.text = _moduleBean.name;
    _sectionDescLabel.text = _moduleBean.desc;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_moduleBean.pict] placeholderImage:[UIImage imageNamed:@"小占位图"]];
}

- (void)setFollowButton{
    //根据bean设置是否关注
    _followButton.selected = _moduleBean.followId > 0 ? YES : NO;
    if (_moduleBean.followId > 0) {
        _followButton.selected = YES;
        _isFollowed = YES;
    } else {
        _followButton.selected = NO;
        _isFollowed = NO;
    }
}
- (IBAction)followButtonClicked:(id)sender {
    if (self.isLogin) {
        NSLog(@"处理关注、取消关注");
        [NetWorking changeModuleFollowStatusWithModuleBean:_moduleBean andBlock:^(NSDictionary *dic) {
            NSString *status = dic[@"status"];
            
            if ([status isEqualToString:@"success"]) {
                _isFollowed = !_isFollowed;
                _followButton.selected = _isFollowed;
                [self.view showMessage:[NSString stringWithFormat:@"%@", dic[@"message"]]];
                if (_isFollowed) {//如果关注成功，保存followId
                    _followId = [NSString stringWithFormat:@"%@", dic[@"data"]];
                }
            } else if ([status isEqualToString:@"error"]) {
                _isFollowed = NO;
                _followButton.selected = NO;
                [self.view showMessage:[NSString stringWithFormat:@"%@", dic[@"message"]]];
            }
        } andIsFollow:!_isFollowed andFollowId:_followId];
    }
}

#pragma mark - 设置tableView
- (void)setMainView{
    _postListTableView = [[FTPostListTableView alloc]initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 6 * 2, SCREEN_HEIGHT - 64 - 144)];// 6为边距
    [_mainView addSubview:_postListTableView];
}

#pragma mark - 获取关注状态

//获取关注状态
- (void)getFollowStatus{
    [NetWorking userWhetherFollowModule:_moduleBean withBlock:^(NSDictionary *dic) {
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"]) {
            if (dic[@"data"][@"id"]) {//若id不为空表示已关注
                _isFollowed = YES;
                _followId = [NSString stringWithFormat:@"%@", dic[@"data"][@"id"]];
            } else {
                _isFollowed = NO;
            }
            _followButton.selected = _isFollowed;
        } else {
            _isFollowed = NO;
            _followButton.selected = NO;
        }
    }];
}
- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}
@end
