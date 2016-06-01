//
//  FTHomepageMainViewController.m
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTHomepageMainViewController.h"
#import "WXApi.h"
#import "UIImage+FTLYZImage.h"
#import "FTTableViewController.h"
#import "FTArenaViewController.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "FTNWGetCategory.h"
#import "FTLabelBean.h"
#import "FTRankTableView.h"
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


@interface FTHomepageMainViewController ()
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, copy)NSString *currentIndexString;

@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@end

@implementation FTHomepageMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil]) {
        NSLog(@"briefIntroductionTextField : %@", _briefIntroductionTextField.text);
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    NSLog(@"briefIntroductionTextField : %@", _briefIntroductionTextField.text);
    [self initSubviews];
    [self getDataFromWeb];//初次加载数据
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
/**
 *  初始化一些默认配置
 */
- (void)initBaseData{
    _selectedType = FTHomepageDynamicInformation;
    _currentIndexString = @"all";
    _query = @"list-dam-blog-1";
    _pageNum = @"1";
    _pageSize = @"10";
    _labels = @"";
}

- (void)initSubviews{
    //调整行高
    [UILabel setRowGapOfLabel:self.briefIntroductionTextField withValue:6];

    //设置左上角的返回按钮
    UIButton *leftBackButton = [[UIButton alloc]init];
    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [leftBackButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    leftBackButton.frame = CGRectMake(10, 30, 22, 22);
    [self.view addSubview:leftBackButton];
    [self.view bringSubviewToFront:leftBackButton];
    
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
        
    }
    //设置背景图片

    [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.geedew.com/wp-content/uploads/2012/10/NodeJS-1038x576.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        UIImage *imageL = [UIImage image]
//        _userBgImageView.image = [UIImage boxblurImage:_userBgImageView.image withBlurNumber:0.5];
        _userBgImageView.image = [UIImage boxblurImage:[UIImage imageNamed:@"BingWallpaper-2016-04-25.jpg"] withBlurNumber:0.5];
//        _userBgImageView.image = [UIImage imageNamed:@"BingWallpaper-2016-04-25.jpg"];
//        [UIImage blurImage:_userBgImageView];
        
//        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        
//        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        
//        visualEffectView.frame = _userBgImageView.bounds;
//        
//        [_userBgImageView addSubview:visualEffectView];
    }];
}

- (void)setScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    [self.view addSubview:_scrollView];
    
    //头像
    
}

#pragma -mark -切换按钮的点击事件
- (IBAction)dynamicInfomationButtonClicked:(id)sender {
    _selectedType = FTHomepageDynamicInformation;
    [self refreshButtonsIndex];
}
- (IBAction)recordButtonClicked:(id)sender {
    _selectedType = FTHomepageRecord;
    [self refreshButtonsIndex];
}
- (IBAction)videoButtonClicked:(id)sender {
    _selectedType = FTHomepageVideo;
    [self refreshButtonsIndex];
}

-(void)refreshButtonsIndex{
    switch (_selectedType) {
        case FTHomepageDynamicInformation:
            _dynamicInfomationButtonIndexView.hidden = NO;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = YES;
            break;
        case FTHomepageRecord:
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = NO;
            _videoButtonIndexView.hidden = YES;
            break;
        case FTHomepageVideo:
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = NO;
            break;
        default:
            break;
    }
}
#pragma -mark 动态列表（类似格斗场列表）
- (void)initPageController
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.tableView = _infoTableView;
        self.tableViewController.listType = FTCellTypeArena;
        
        self.tableViewController.FTdelegate = self;
        //设置上拉、下拉刷新
        [self setJHRefresh];
    }
    
    
    if (self.tableViewDataSourceArray) {
        [self.tableViewController.tableView footerEndRefreshing];
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        //    self.tableViewController.sourceArray = _sourceArry[0];
        NSLog(@"没有数据源。");
    }
//    self.tableViewController.tableView.frame = self.mainView.bounds;
//    [self.mainView addSubview:self.tableViewController.tableView];
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
-(void) getDataFromWeb {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    
    //    NSLog(@"urlString:%@",urlString);
    NetWorking *net = [[NetWorking alloc]init];
    
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        NSLog(@"responseDic:  %@", responseDic);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
