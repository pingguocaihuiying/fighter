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


#import "FTVideoDetailViewController.h"
#import "FTVideoCollectionViewCell.h"


@interface FTHomepageMainViewController ()<FTArenaDetailDelegate, FTSelectCellDelegate,FTTableViewdelegate, UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FTVideoDetailDelegate>
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, copy)NSString *currentIndexString;

@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, strong)NSMutableArray *collectionViewDataSourceArray;//视频collectionView的数据源
@end

@implementation FTHomepageMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil]) {
//        NSLog(@"briefIntroductionTextField : %@", _briefIntroductionTextField.text); //null
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
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
    
    //设置个人资料的背景图片
    [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.geedew.com/wp-content/uploads/2012/10/NodeJS-1038x576.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _userBgImageView.image = [UIImage boxblurImage:[UIImage imageNamed:@"BingWallpaper-2016-04-25.jpg"] withBlurNumber:0.5];

    }];
    //设置主scrollView的滚动逻辑
    [self setMainScrollView];
    //设置格斗场的tableview cell
    [self initInfoTableView];
}
#pragma -mark 设置mainScrollView
- (void)setMainScrollView{
    _mainScrollView.delegate = self;
    NSLog(@"buttonsView.y : %f", _buttonsContainerView.frame.origin.y);
}
#pragma -mark scrollView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _mainScrollView){//如果是mainScrollView
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"scrollView offset : %f", offsetY);
        NSLog(@"buttonsView.y : %f", _buttonsContainerView.frame.origin.y);
    if (offsetY >= 204 - 24 + 8) {
        _buttonsContainerView.top = 224 + (offsetY - (204 - 24 + 8));
        [[_buttonsContainerView superview] bringSubviewToFront:_buttonsContainerView];
    }else{
        _buttonsContainerView.top = 224;
    }
    }
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
            //显示格斗场列表，并隐藏其他
            _videoCollectionView.hidden = YES;
            _infoTableView.hidden = NO;
            
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
            
            
            
            //隐藏其余tableView，显示collectionView，并设置
            _infoTableView.hidden = YES;
            _videoCollectionView.hidden = NO;
            [self initCollectionView];
            [self getDataWithGetType:@"new" andCurrId:@"-1"];//加载视频数据
            break;
        default:
            break;
    }
}
#pragma -mark 格斗场帖子列表
- (void)initInfoTableView
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeArena;
        
        self.tableViewController.FTdelegate = self;
    }
    
    if (self.tableViewDataSourceArray) {
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        NSLog(@"没有数据源。");
    }
    self.tableViewController.tableView = _infoTableView;
    //注册cell用于重用
    [_infoTableView registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
    [_infoTableView registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
}

-(void) getDataFromWeb {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    NetWorking *net = [[NetWorking alloc]init];
    
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {

        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
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

}
#pragma -mark 动态tableview的cell点击事件
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
        
        
        [self.navigationController pushViewController:postsDetailVC animated:YES];    }
}

#pragma -mark 回调更新格斗场的点赞、评论信息
- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark  视频列表collectionView

//加载视频数据
- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)videoCurrId{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoURL];
    NSString *videoType = @"";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",videoType, videoCurrId, @"1", getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@", urlString, videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], @"1"];
    
    NetWorking *net = [[NetWorking alloc]init];
    [net getVideos:urlString option:^(NSDictionary *responseDic) {
        
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                
                //缓存数据到DB
                if (mutableArray.count > 0) {
                    DBManager *dbManager = [DBManager shareDBManager];
                    [dbManager connect];
                    [dbManager cleanVideosTable];
                    
                    for (NSDictionary *dic in mutableArray)  {
                        [dbManager insertDataIntoVideos:dic];
                    }
                }
                
                [self getDataFromDBWithVideoType:videoType getType:getType];
                
                [_videoCollectionView reloadData];
                
            }else {
                [self getDataFromDBWithVideoType:videoType getType:getType];
                [_videoCollectionView reloadData];
                
            }
            
        }else {
            [self getDataFromDBWithVideoType:videoType getType:getType];

            [_videoCollectionView reloadData];
            
            
        }
    }];
    
    
}
- (void) getDataFromDBWithVideoType:(NSString *)videosType  getType:(NSString *) getType {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchVideosWithType:videosType];
    [dbManager close];
    
    if ([getType isEqualToString:@"new"]) {
        self.collectionViewDataSourceArray = mutableArray;
    }else if([getType isEqualToString:@"old"]){
        [self.collectionViewDataSourceArray addObjectsFromArray:mutableArray];
    }
}
- (void)initCollectionView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
    //    flow.minimumLineSpacing = 15 * SCALE;
    //列间距
    flow.minimumInteritemSpacing = 16 * SCALE;
    
    
    float width = 164 * SCALE;
    float height = 143 * SCALE;
    flow.itemSize = CGSizeMake(width, height);
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
    
    _videoCollectionView.collectionViewLayout = flow;
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
    [_videoCollectionView registerNib:[UINib nibWithNibName:@"FTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    if (self.collectionViewDataSourceArray) {
        
        FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
        //获取对应的bean，传递给下个vc
        //        NSDictionary *newsDic = self.collectionViewDataSourceArray[indexPath.row];
        //        FTVideoBean *bean = [FTVideoBean new];
        //        [bean setValuesWithDic:newsDic];
        
        FTVideoBean *bean = self.self.collectionViewDataSourceArray[indexPath.row];
        //标记已读
        if (![bean.isReader isEqualToString:@"YES"]) {
            bean.isReader = @"YES";
            //从数据库取数据
            DBManager *dbManager = [DBManager shareDBManager];
            [dbManager connect];
            [dbManager updateVideosById:bean.videosId isReader:YES];
            [dbManager close];
        }
        
        
        videoDetailVC.videoBean = bean;
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
        videoDetailVC.indexPath = theIndexPath;
        
        videoDetailVC.delegate = self;
        
        [self.navigationController pushViewController:videoDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewDataSourceArray.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTVideoCollectionViewCell" owner:self options:nil]firstObject];
    }
    FTVideoBean *videoBean = self.collectionViewDataSourceArray[indexPath.row];
    [cell setWithBean:videoBean];
    return cell;
}
- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.collectionViewDataSourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.viewCount] forKey:@"viewCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.commentCount] forKey:@"commentCount"];
    //    NSLog(@"indexPath.row : %ld", indexPath.row);
    self.collectionViewDataSourceArray[indexPath.row] = dic;
    //    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    [_videoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
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
