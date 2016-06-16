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
#import "FTNewsBean.h"


#import "FTVideoDetailViewController.h"
#import "FTVideoCollectionViewCell.h"
#import "FTRecordRankTableViewCell.h"
#import "FTBaseTableViewCell.h"
#import "FTHomepageRecordListTableViewCell.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "FTHomepageCommentListViewController.h"
#import "FTArenaBean.h"
#import "FTArenaPostsDetailViewController.h"
#import "FTUserCenterViewController.h"
#import "FTShareView.h"

@interface FTHomepageMainViewController ()<FTArenaDetailDelegate, FTSelectCellDelegate,FTTableViewdelegate, UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FTVideoDetailDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;


@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, copy)NSString *currentIndexString;

@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (assign, nonatomic)BOOL hasInitRecordRank;
@property (assign, nonatomic)BOOL hasFollow;//是否关注
@property (nonatomic, copy)NSString *userid;//用于（取消）关注、获取评论列表
@property (nonatomic, copy)NSString *followTableName;//用于（取消）关注

@property (nonatomic, strong)NSMutableArray *collectionViewDataSourceArray;//视频collectionView的数据源
@property (nonatomic, copy)NSString *userIdentity;//用户身份  0:普通用户 1:拳手 2:教练

@property (nonatomic, strong)NSMutableArray *boxerRankDataArray;//拳手战绩数据
@property (nonatomic, strong)NSArray *boxerRaceInfoDataArray;//拳手赛事数据
@property (nonatomic, copy)NSString *standings;//拳手战况
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordRankTableViewHeightConstant;
@property (nonatomic, strong) FTUserBean *userBean;//获取的用户信息
@end

@implementation FTHomepageMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHomepageUserInfo];
    [self initBaseData];
    [self initSubviews];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 获取用户的基本信息
- (void)getHomepageUserInfo{
    [NetWorking getHomepageUserInfoWithUserOldid:_olduserid andBoxerId:_boxerId andCoachId:_coachId andCallbackOption:^(FTUserBean *userBean) {
        _userBean = userBean;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userBean.headUrl]];
        
        
        
        self.sexLabel.text = userBean.sex;
        self.nameLabel.text = userBean.name;

        self.followCountLabel.text = [NSString stringWithFormat:@"%@", userBean.followCount];
        self.fansCountLabel.text = [NSString stringWithFormat:@"%@", userBean.fansCount == nil ? @"0" : userBean.fansCount];
        self.dynamicCountLabel.text = [NSString stringWithFormat:@"%@", userBean.dynamicCount == nil ? @"0" : userBean.dynamicCount];
        if (!userBean.address) {
            userBean.address = @"";
        }
        self.addressLabel.text = [NSString stringWithFormat:@"%@", userBean.address];
        self.briefIntroductionTextField.text = userBean.brief;
        
        //设置年龄
        NSString *ageStr = userBean.birthday;
        if (ageStr == nil || [ageStr isEqualToString:@"(null)"]) {
            ageStr = @"-";
        }else{
            if ([ageStr isEqualToString:@""]) {
                ageStr = @"-";
            }else{
                NSTimeInterval birthTimeStamp = [userBean.birthday doubleValue];
                NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
                double age = (now - birthTimeStamp) / 3600 / 24 / 365 / 1000;
                ageStr = [NSString stringWithFormat:@"%.0lf", age];
            }
            if ([ageStr isEqualToString:@"-0"] || [ageStr isEqualToString:@"0"]) {
                ageStr = @"-";
            }
            
        }
        NSLog(@"ageStr : %@", ageStr);
//        NSLog(@"ageStr : %@", ageStr);
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁", ageStr];
        if (userBean.boxerId) {
            _boxerId = userBean.boxerId;
            //如果有boxerId，去查询拳手的赛事信息
            [self getBoxerRaceInfo];
        }
        if(userBean.coachId){
            _coachId = userBean.coachId;
        }
        _userid = userBean.userid;
        self.weightLabel.text = [NSString stringWithFormat:@"%@kg", userBean.weight == nil ? @"- " : userBean.weight];
        if (!userBean.height) {
            userBean.height = @"";
        }
        self.heightLabel.text = [NSString stringWithFormat:@"%@cm", [userBean.height isEqualToString:@""] ? @"- " : userBean.height];
        
        //处理三个按钮的可用状态
        if (userBean.query && ![userBean.query isEqualToString:@""]) {
            _userIdentity = userBean.query;
        }else{
            _userIdentity = @"0";
        }
        NSLog(@"_userIdentity : %@", _userIdentity);
        
//        [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:userBean.headUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            _userBgImageView.image = [UIImage boxblurImage:image withBlurNumber:0.5];
//            
//        }];
        
        if ([_userIdentity isEqualToString:@"0"]) {//普通用户
            
            _followTableName = @"f-user";
            
            
            //不显示战绩、视频项
            self.recordButton.hidden = YES;//是否显示战绩按钮
            self.videoButton.hidden = YES;//是否显示视频按钮
            
            [self.videoButton setTitle:@"视频"];//修改视频按钮的标题为“视频”
        }else if ([_userIdentity isEqualToString:@"1"]) {//拳手
            
            //设置个人资料的背景图片
            if (userBean.background != nil && ![userBean.background isEqualToString:@""]) {
                [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:userBean.background] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _userBgImageView.image = [UIImage boxblurImage:image withBlurNumber:0.5];
                    
                }];
            }

            
            //显示战绩、视频项
            self.recordButton.hidden = NO;//是否显示战绩按钮
            self.videoButton.hidden = NO;//是否显示视频按钮
            
            _followTableName = @"f-boxer";
            self.identityImageView1.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-拳"];
        }else if ([_userIdentity isEqualToString:@"2"]){//教练
            
            //显示视频，不显示战绩
            self.recordButton.hidden = YES;//是否显示战绩按钮
            self.videoButton.hidden = YES;//是否显示视频按钮
            
            _followTableName = @"f-coach";
            self.identityImageView1.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-教"];
        }else if ([_userIdentity isEqualToString:@"1,2"]){//拳手、教练
            self.identityImageView1.hidden = NO;
            self.identityImageView2.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-教"];
            self.identityImageView2.image = [UIImage imageNamed:@"身份圆形-拳"];
        }
        
        [self getFollowInfo];//获取关注信息
        //处理右上角的“转发”或“修改”：如果是自己的主页，则是“修改”，如果是别人的，则显示转发
        FTUserBean *localUserBean = [FTUserTools getLocalUser];
        
        if (localUserBean && [localUserBean.olduserid isEqualToString:self.olduserid]) {//如果是自己的主页
            _shareAndModifyProfileButton.hidden = NO;
            [_shareAndModifyProfileButton setTitle:@"修改" forState:UIControlStateNormal];
            [_shareAndModifyProfileButton addTarget:self action:@selector(modifyProfile) forControlEvents:UIControlEventTouchUpInside];
            //显示“发新动态”，隐藏关注等
            _bottomNewPostsView.hidden = NO;
            _bottomFollowView.hidden = YES;
        }else{//如果是别人的主页
            [_shareAndModifyProfileButton setTitle:@"转发" forState:UIControlStateNormal];
            [_shareAndModifyProfileButton addTarget:self action:@selector(shareUserInfo) forControlEvents:UIControlEventTouchUpInside];
            //隐藏“发新动态”，显示关注等
            _bottomNewPostsView.hidden = YES;
            _bottomFollowView.hidden = NO;
        }
        
        //拳手战绩
        _boxerRankDataArray = [[NSMutableArray alloc]initWithArray:userBean.boxerRaceInfos];
            //添加一条空数据
        [_boxerRankDataArray insertObject:[NSObject new] atIndex:0];
        
        //拳手战绩概括
        _standings = userBean.standings;
        
         [self getDataFromWeb];//初次加载帖子数据
    }];
}

- (void)getBoxerRaceInfo{
    [NetWorking getBoxerRaceInfoWithBoxerId:_boxerId andOption:^(NSArray *array) {
        _boxerRaceInfoDataArray = array;
        [_recordListTableView reloadData];
    }];
}

#pragma mark 修改个人资料
- (void)modifyProfile{
    NSLog(@"修改资料");
    FTUserCenterViewController *userCenter = [[FTUserCenterViewController alloc]init];
    userCenter.title = @"个人资料";
    [self.navigationController pushViewController:userCenter animated:YES];
}

#pragma mark 转发
- (void)shareUserInfo{
    [MobClick event:@"rankingPage_HomePage_ShareUp"];
    NSLog(@"转发");
        //友盟分享事件统计
        [MobClick event:@"newsPage_DetailPage_share"];
    
    //链接地址
        NSString *_webUrlString = @"";
        FTShareView *shareView = [FTShareView new];
        [shareView setUrl:_webUrlString];
    
    //分享标题
    NSString *title = _userBean.name;
        //如果是拳手，再加上“［格斗家］认证拳手，webview的url也改为拳手对应的
    if(_userBean.query && [_userBean.query isEqualToString:@"1"]){//1：拳手，2:教练，普通用户为空（nil）
        title = [NSString stringWithFormat:@"%@%@", title, @"[格斗家] 认证拳手"];
        _webUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/v2/user_boxer.html?userId=%@", _userBean.olduserid];
    }else {
        _webUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/v2/user_general.html?userId=%@", _userBean.olduserid];
    }
    
    //分享简述
    NSString *summaryString = @"";
    if (_tableViewDataSourceArray && _tableViewDataSourceArray.count > 0) {//如果有动态，简述显示动态标题
        FTArenaBean *firstArenaBean = [_tableViewDataSourceArray firstObject];
        summaryString = firstArenaBean.title;
    }else{//不然，显示"格斗家 xxx 的主页"
        summaryString = [NSString stringWithFormat:@"格斗家 %@ 的主页", _userBean.name];
    }
        [shareView setTitle:title];
        [shareView setSummary:summaryString];
//        [shareView setImage:@"微信用@200"];
    [shareView setImageUrl:_userBean.headUrl];
//
            [shareView setUrl:_webUrlString];
    
        [self.view addSubview:shareView];
}
/**
 *  初始化一些默认配置
 */
- (void)initBaseData{
    _selectedType = FTHomepageDynamicInformation;
    _currentIndexString = @"all";
    _query = @"list-dam-blog-1";
    _pageNum = @"1";
    _pageSize = @"100";
    _labels = @"";
    _hasInitRecordRank = false;
}

- (void)initSubviews{
    //给下方的关注、评论等控件增加点击事件监听
    [self addGesture];
    
    //调整行高
    [UILabel setRowGapOfLabel:self.briefIntroductionTextField withValue:6];

    //设置左上角的返回按钮
    UIButton *leftBackButton = [[UIButton alloc]init];
//    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [leftBackButton setImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [leftBackButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
//    leftBackButton.frame = CGRectMake(10, 30, 22, 22);
    leftBackButton.frame = CGRectMake(-2, 19, 60, 44);
    [self.view addSubview:leftBackButton];
    [self.view bringSubviewToFront:leftBackButton];
    

    //设置主scrollView的滚动逻辑
    [self setMainScrollView];
    //设置格斗场的tableview cell
    [self initInfoTableView];
}

- (void)addGesture{
    UITapGestureRecognizer *tapOfVoteView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followViewClicked:)];
    [_followView addGestureRecognizer:tapOfVoteView];
    _followView.userInteractionEnabled = YES;
}

#pragma -mark 设置mainScrollView
- (void)setMainScrollView{
    _mainScrollView.delegate = self;
//    NSLog(@"buttonsView.y : %f", _buttonsContainerView.frame.origin.y);
}
#pragma -mark scrollView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _mainScrollView){//如果是mainScrollView
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"scrollView offset : %f", offsetY);
//        NSLog(@"buttonsView.y : %f", _buttonsContainerView.frame.origin.y);
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
    [MobClick event:@"rankingPage_HomePage_Match"];
    _selectedType = FTHomepageDynamicInformation;
    [self refreshButtonsIndex];
}
- (IBAction)recordButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Match"];
    _selectedType = FTHomepageRecord;
    [self refreshButtonsIndex];
}
- (IBAction)videoButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_VideoAll"];
    _selectedType = FTHomepageVideo;
    [self refreshButtonsIndex];
}
#pragma -mark 更新对应的界面显示
-(void)refreshButtonsIndex{
    switch (_selectedType) {
        case FTHomepageDynamicInformation://格斗场列表
            //如果没有格斗场数据，则显示空图片
            if (self.tableViewDataSourceArray && self.tableViewDataSourceArray.count > 0) {
                _noDynamicImageView.hidden = YES;
            }else{
                _noDynamicImageView.hidden = NO;
            }
            //显示当前下标
            _dynamicInfomationButtonIndexView.hidden = NO;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = YES;
            
            //显示格斗场列表，并隐藏其他
            _infoTableView.hidden = NO;
            _videoCollectionView.hidden = YES;
            _recordRankTableView.hidden = YES;
            _recordListTableView.hidden = YES;
            break;
        case FTHomepageRecord://赛事
            //显示当前下标
            _noDynamicImageView.hidden = YES;
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = NO;
            _videoButtonIndexView.hidden = YES;
            
            //显示赛事相关的内容，隐藏其他
            _noDynamicImageView.hidden = YES;
            _recordRankTableView.hidden = NO;
            _recordListTableView.hidden = NO;
            _infoTableView.hidden = YES;
            _videoCollectionView.hidden = YES;
            
            //处理赛事内容显示
            [self setRecordContent];
            break;
        case FTHomepageVideo://视频
            //显示当前下标
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = NO;
            
            //隐藏其余tableView，显示collectionView，并设置
            _infoTableView.hidden = YES;
            _recordRankTableView.hidden = YES;
            _recordListTableView.hidden = YES;
            _videoCollectionView.hidden = NO;
            
            [self initCollectionView];
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
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@&userId=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName, _olduserid];
//        urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    NetWorking *net = [[NetWorking alloc]init];
    NSLog(@"个人中心获取帖子列表 url ： %@", urlString);
    
    [net getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                [self refreshButtonsIndex ];
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                //把获取的字典转换为bean，再存入数组
                NSMutableArray *tempTableViewArray = [NSMutableArray new];
                for(NSDictionary *dic in mutableArray){
                    FTArenaBean *bean = [FTArenaBean new];
                    [bean setValuesWithDic:dic];
                    [tempTableViewArray addObject:bean];
                }
                
                //从格斗场的数据中，筛选出属于“训练”类型的内容**start***
                NSMutableArray *tempCollectionViewDataArray = [NSMutableArray new];
                for(FTArenaBean *bean in tempTableViewArray){
                    if ([bean.labels isEqualToString:@"Train"]) {
                        [tempCollectionViewDataArray addObject:bean];
                    }
                }
                _collectionViewDataSourceArray = tempCollectionViewDataArray;
                //从格斗场的数据中，筛选出属于“训练”类型的内容** end ***
                
                if (self.tableViewDataSourceArray == nil) {
                    self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
                }
                if ([_pageNum isEqualToString:@"1"]) {//如果是第一页数据，直接替换，不然追加
                    self.tableViewDataSourceArray = tempTableViewArray;
                }else{
                    [self.tableViewDataSourceArray addObjectsFromArray:tempTableViewArray];
                }
                
                self.tableViewController.sourceArray = self.tableViewDataSourceArray;
                
                
                
                if (self.tableViewDataSourceArray.count > 0) {
                    _noDynamicImageView.hidden = YES;
                }
                
                [self.tableViewController.tableView reloadData];
//                //缓存数据到DB
//                if (mutableArray.count > 0) {
//                    _noDynamicImageView.hidden = YES;
//                    DBManager *dbManager = [DBManager shareDBManager];
//                    [dbManager connect];
//                    [dbManager cleanArenasTable];
//                    
//                    for (NSDictionary *dic in mutableArray)  {
//                        [dbManager insertDataIntoArenas:dic];
//                    }
//                }
                
//                [self getDataFromDB];
                
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
    NSMutableArray *mutableArray =[dbManager searchArenasWithLabel:_labels hotTag:_query];
    [dbManager close];
    
    //从格斗场的数据中，筛选出属于“训练”类型的内容**start***
    NSMutableArray *tempArray = [NSMutableArray new];
    for(FTArenaBean *bean in mutableArray){
        if ([bean.labels isEqualToString:@"Train"]) {
            [tempArray addObject:bean];
        }
    }
    _collectionViewDataSourceArray = tempArray;
    //从格斗场的数据中，筛选出属于“训练”类型的内容** end ***
    
    if (self.tableViewDataSourceArray == nil) {
        self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
    }
    if ([_pageNum isEqualToString:@"1"]) {//如果是第一页数据，直接替换，不然追加
        self.tableViewDataSourceArray = mutableArray;
    }else{
        [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
    }
    
    self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    

    
    if (self.tableViewDataSourceArray.count > 0) {
        _noDynamicImageView.hidden = YES;
    }
    
    [self.tableViewController.tableView reloadData];

}
#pragma -mark 动态tableview的cell点击事件
- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
        NSLog(@"第%ld个cell被点击了。", indexPath.row);
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

#pragma -mark ***  赛事  ***
- (void)setRecordContent{

    //设置赛事排行榜
    if (!_hasInitRecordRank) {
        //设置代理
        _recordRankTableView.delegate = self;
        _recordRankTableView.dataSource = self;
        //加载一个cell用于复用
        [_recordRankTableView registerNib:[UINib nibWithNibName:@"FTRecordRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"recordRankCell"];
        //设置高度
        _recordRankTableViewHeight.constant =36 + 22 + 32 * (_boxerRankDataArray.count - 1) + 7;
        //添加背景
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, _recordRankTableView.width - 8 * 2, _recordRankTableViewHeight.constant)];
        bgImageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
        [_recordRankTableView addSubview:bgImageView];
        _hasInitRecordRank = true;
    }
    [_recordRankTableView reloadData];
    
    //设置赛事列表
    _recordListTableView.delegate = self;
    _recordListTableView.dataSource = self;
    [_recordListTableView registerNib:[UINib nibWithNibName:@"FTHomepageRecordListTableViewCell" bundle:nil] forCellReuseIdentifier:@"recordListCell"];
    [_recordListTableView reloadData];
}
//cell多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _recordRankTableView) {
        if(_boxerRankDataArray){
            return _boxerRankDataArray.count;
        }
    }else if(tableView == _recordListTableView){
        return _boxerRaceInfoDataArray.count;
    }
    return 0;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, tableView.width, 36);
    if (tableView == _recordRankTableView) {
//        headerView.backgroundColor = [UIColor yellowColor];
        
        //固定文本“战绩”label
        UILabel *standingsTitle = [[UILabel alloc]initWithFrame:CGRectMake(14 + 10, 12, 50, 14)];
        standingsTitle.text = @"战绩";
        standingsTitle.font = [UIFont systemFontOfSize:14];
        standingsTitle.textColor = [UIColor whiteColor];
        [headerView addSubview:standingsTitle];
        
        //战绩详情label
        UILabel *standingsDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.width - 200 - 14 - 10, 12, 200, 14)];
        standingsDetailLabel.textAlignment = NSTextAlignmentRight;
        
        NSMutableAttributedString *standingStr = [[NSMutableAttributedString alloc]init];
            //胜
        NSMutableAttributedString *winCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.win == nil ? @"0" : _userBean.win]];
        [winCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, winCountStr.length)];
        NSMutableAttributedString *winStr = [[NSMutableAttributedString alloc]initWithString:@"胜 "];
        [winStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, winStr.length)];
        
            //负
        NSMutableAttributedString *failCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.fail == nil ? @"0" : _userBean.fail]];
        [failCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, failCountStr.length)];
        NSMutableAttributedString *failStr = [[NSMutableAttributedString alloc]initWithString:@"负 "];
        [failStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, failStr.length)];
            //平
        NSMutableAttributedString *drawCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.draw == nil ? @"0" : _userBean.draw]];
        NSMutableAttributedString *drawStr = [[NSMutableAttributedString alloc]initWithString:@"平 "];
        [drawCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, drawCountStr.length)];
        [drawStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, drawStr.length)];
            //击倒
        NSMutableAttributedString *knockoutCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.knockout == nil ? @"0" : _userBean.knockout]];
        [knockoutCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, knockoutCountStr.length)];
        NSMutableAttributedString *knockStr = [[NSMutableAttributedString alloc]initWithString:@"击倒"];
        [knockStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, knockStr.length)];
        
        [standingStr appendAttributedString:winCountStr];
        [standingStr appendAttributedString:winStr];
        [standingStr appendAttributedString:failCountStr];
        [standingStr appendAttributedString:failStr];
        [standingStr appendAttributedString:drawCountStr];
        [standingStr appendAttributedString:drawStr];
        [standingStr appendAttributedString:knockoutCountStr];
        [standingStr appendAttributedString:knockStr];
        
        standingsDetailLabel.attributedText = standingStr;
        standingsDetailLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:standingsDetailLabel];
        
        //底部分割线
        UIView *bottomSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(10, headerView.height - 1, headerView.width - 20, 1)];
        bottomSeparatorView.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:40 / 255.0 blue:40 / 255.0 alpha:1];
        [headerView addSubview:bottomSeparatorView];
    }
    return headerView;
}

//headerView height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _recordRankTableView) {
        return 36;
    }
    return 0;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTBaseTableViewCell *cell;
    if (tableView == _recordRankTableView) {//如果是赛事排行榜信息
        
        FTRecordRankTableViewCell *cell1 = (FTRecordRankTableViewCell *)([tableView dequeueReusableCellWithIdentifier:@"recordRankCell"]);
        if (indexPath.row == 0) {//如果是第一行，调整字体为灰色
            cell1.competitionNameLabel.textColor = [UIColor colorWithHex:0x646464];
            cell1.curRankLabel.textColor = [UIColor colorWithHex:0x646464];
            cell1.bestRankLabel.textColor = [UIColor colorWithHex:0x646464];
//            cell1.backgroundColor = [UIColor colorWithHex:0x191919];
        }else{//如果不是第一行，动态显示内容
            cell1.competitionNameLabel.textColor = [UIColor whiteColor];
            cell1.curRankLabel.textColor = [UIColor whiteColor];
            cell1.bestRankLabel.textColor = [UIColor whiteColor];
            cell1.backgroundColor = [UIColor clearColor];
            
            [cell1 setWithDic:_boxerRankDataArray[indexPath.row]];
        }
        //如果是第一个和最后一个，则不显示分割线
        if (indexPath.row == 0 || indexPath.row == 4) {
            cell1.separatorIndexView.hidden = YES;
        }
        return cell1;
    }else if(tableView == _recordListTableView){
        FTHomepageRecordListTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"recordListCell"];
        [cell2 setWithDic:_boxerRaceInfoDataArray[indexPath.row]];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _recordRankTableView) {
        if (indexPath.row == 0) {
            return 22;
        }else{
            return 32;
        }
    }else if(tableView == _recordListTableView){
        return 74 + 10;
    }
    return 0;
}
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _recordListTableView) {
        NSDictionary *dic = _boxerRaceInfoDataArray[indexPath.row];
        NSString *type = dic[@"urlType"];
        NSLog(@"type : %@", type);
        if ([type isEqualToString:@"0"]) {//不跳转
            return;
        }else if ([type isEqualToString:@"1"]){//拳讯
            NSLog(@"拳讯");
            [NetWorking getNewsById:dic[@"urlId"] andOption:^(NSArray *array) {
                if (dic[@"urlId"]) {
                    FTNewsDetail2ViewController *newsDetailVC = [FTNewsDetail2ViewController new];
                    newsDetailVC.urlId = dic[@"urlId"];
                    FTNewsBean *newsBean = [FTNewsBean new];
                    [newsBean setValuesWithDic:[array firstObject]];
                    newsDetailVC.newsBean = newsBean;
                    [self.navigationController pushViewController:newsDetailVC animated:YES];
                }
            }];


        }else if ([type isEqualToString:@"2"]){//视频
            NSLog(@"视频");
            [NetWorking getVideoById:dic[@"urlId"] andOption:^(NSArray *array) {
                FTVideoBean *videoBean = [FTVideoBean new];
                [videoBean setValuesWithDic:[array firstObject]];
                FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
                videoDetailVC.urlId = dic[@"urlId"];
                videoDetailVC.videoBean = videoBean;
                [self.navigationController pushViewController:videoDetailVC animated:YES];
            }];

        }
    }
}
- (void) getDataFromDBWithVideoType:(NSString *)videosType  getType:(NSString *) getType {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchVideosWithType:videosType hotTag:nil];
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
    [_videoCollectionView reloadData];
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    if (self.collectionViewDataSourceArray) {
        
        FTArenaPostsDetailViewController *postsDetailVC = [FTArenaPostsDetailViewController new];
        //获取对应的bean，传递给下个vc
        //        NSDictionary *newsDic = self.collectionViewDataSourceArray[indexPath.row];
        //        FTVideoBean *bean = [FTVideoBean new];
        //        [bean setValuesWithDic:newsDic];
        
        FTArenaBean *bean = self.collectionViewDataSourceArray[indexPath.row];
        //标记已读
//        if (![bean.isReader isEqualToString:@"YES"]) {
//            bean.isReader = @"YES";
//            //从数据库取数据
//            DBManager *dbManager = [DBManager shareDBManager];
//            [dbManager connect];
//            [dbManager updateVideosById:bean.videosId isReader:YES];
//            [dbManager close];
//        }
        
        
        postsDetailVC.arenaBean = bean;
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
        postsDetailVC.indexPath = theIndexPath;
        
        postsDetailVC.delegate = self;
        
        [self.navigationController pushViewController:postsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
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
//    NSDictionary *dic = _collectionViewDataSourceArray[indexPath.row];
//    [cell setWithDic:dic];
    FTArenaBean *arenaBean = _collectionViewDataSourceArray[indexPath.row];
    [cell setWithArenaBean:arenaBean];
    return cell;
}
//更新视频的点赞、评论数量
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

#pragma mark 关注
#pragma -mark 点赞按钮被点击

- (IBAction)followViewClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Follow"];
    //从本地读取存储的用户信息，判断是否登陆。登陆之后才能进行关注操作
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasFollow = !self.hasFollow;
        [self updateFollowImageView];
        _followView.userInteractionEnabled = NO;
        [self uploadVoteStatusToServer];
    }

}

- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

- (void)updateFollowImageView{
    if (self.hasFollow) {
        _followImageView.image = [UIImage imageNamed:@"关注pre"];
        
    }else{
        _followImageView.image = [UIImage imageNamed:@"关注"];
    }
}

//把点赞信息更新至服务器
- (void)uploadVoteStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasFollow ? AddFollowURL : DeleteFollowURL];
    
    NSString *userId = user.olduserid;
    NSString *objId;
    if (_boxerId) {
        objId = _boxerId;
    }else if(_coachId){
        objId = _coachId;
    }else if(_userid){
        objId = _userid;
    }
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _followTableName;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasFollow ? AddFollowCheckKey: CancelFollowCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
        NSLog(@"%@ : %@", self.hasFollow ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        NSLog(@"vote message : %@", responseDic[@"message"]);
        
        _followView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果关注信息更新成功后，处理本地的赞数，并更新webview
            int voteCount = [_fansCountLabel.text intValue];//获取旧的粉丝数，然后＋1或－1
            if (self.hasFollow) {
                voteCount++;
            }else{
                if (voteCount > 0) {
                    voteCount--;
                }
            }
            _fansCountLabel.text = [NSString stringWithFormat:@"%d", voteCount];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
        _followView.userInteractionEnabled = YES;
        NSLog(@"vote failure ：%@", error);
    }];
    
}
#pragma mark 从服务器获取是否已经关注
- (void)getFollowInfo{
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId;
    if (_boxerId) {
         objId = _boxerId;
    }else if(_coachId){
        objId = _coachId;
    }else if(_userid){
        objId = _userid;
    }
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _followTableName;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
        NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
                NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasFollow = YES;
        }else{
            self.hasFollow = NO;
        }
        
        [self updateFollowImageView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
    }];
}
- (IBAction)newPostsButtonClicked:(id)sender {
    FTNewPostViewController *newPostViewController = [FTNewPostViewController new];
    newPostViewController.isShowSyncView = YES;
    newPostViewController.title = @"发新帖";
    [self.navigationController pushViewController:newPostViewController animated:YES];
}
- (IBAction)commentButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Message"];
    FTHomepageCommentListViewController *commentListViewController = [FTHomepageCommentListViewController new];
    if (_boxerId) {
        commentListViewController.objId = _boxerId;
    }else if(_coachId){
        commentListViewController.objId = _coachId;
    }else if(_userid){
        commentListViewController.objId = _userid;
    }
    
    
    if ([_userIdentity isEqualToString:@"0"]) {
        commentListViewController.tableName = @"c-user";
    }else if([_userIdentity isEqualToString:@"1"]){
        commentListViewController.tableName = @"c-boxer";
    }
    [self.navigationController pushViewController:commentListViewController animated:YES];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
