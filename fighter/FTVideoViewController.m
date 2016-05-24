//
//  FTInformationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoViewController.h"
#import "FTTableViewController.h"
#import "SDCycleScrollView.h"
#import "RBRequestOperationManager.h"
#import "FTNetConfig.h"
#import "ZJModelTool.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "FTVideoDetailViewController.h"
#import "FTFilterTableViewController.h"
#import "FTVideoBean.h"
#import "UIButton+LYZTitle.h"
#import "UIButton+WebCache.h"
#import "Mobclick.h"
#import "FTVideoCollectionViewCell.h"
#import "MJRefresh.h"
#import "FTCache.h"
#import "FTCacheBean.h"

@interface FTVideoViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,SDCycleScrollViewDelegate, FTFilterDelegate, FTVideoDetailDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSArray *typeArray;
@property (nonatomic, copy)NSString *videosTag;
@property (nonatomic, copy)NSString *currentVideoType;


@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation FTVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置videotag的默认值为0；
    self.videosTag = @"0";
    [self initTypeArray];
    [self initSubViews];
//    [self getCycleData];//第一次加载轮播图数据
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//第一次加载数据
}

- (void)viewWillAppear:(BOOL)animated{
    [MobClick event:@"mainPage_Video"];
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
    [self.leftBtn.layer setMasksToBounds:YES];
    self.leftBtn.layer.cornerRadius = 17.0;
    [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftBtn];
    }
    //设置最热or最新
    [self setNewOrHot];
    [self setOtherViews];

}

- (IBAction)leftBtnAction:(id)sender {
    
//    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }

}

- (void)setNewOrHot{
    self.containerOfNewOrHotView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"二标签-左选中"]];
    self.hotButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 50);
    self.hotButton.imageEdgeInsets = UIEdgeInsetsMake(0, 85, 4, 0);
    self.newestButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 55);
    self.newestButton.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 4, 0);
}

#pragma -mark 最新最热按钮被点击
- (IBAction)hotButtonClicked:(id)sender {
    //服务器：0是最热，1是最新
    self.videosTag = @"0";
    [MobClick event:@"videoPage_Hot"];
    //设置背景
    self.containerOfNewOrHotView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"二标签-左选中"]];
    
    //改变左边按钮的标题颜色、图片
    [self.hotButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.hotButton setImage:[UIImage imageNamed:@"标签图标-最热-pre"] forState:UIControlStateNormal];
    //改变右边按钮的标题颜色、图片
    [self.newestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.newestButton setImage:[UIImage imageNamed:@"标签图标-最新"] forState:UIControlStateNormal];
    
    //重新加载数据
    [self getDataWithGetType:@"new" andCurrId:@"-1"];
}
- (IBAction)newestButtonClicked:(id)sender {
    self.videosTag = @"1";
    [MobClick event:@"videoPage_New"];
    
    self.containerOfNewOrHotView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"二标签-右选中"]];
    
    //改变右边按钮的标题颜色、图片
        [self.newestButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.newestButton setImage:[UIImage imageNamed:@"标签图标-最新-pre"] forState:UIControlStateNormal];
    
    //改变左边按钮的标题颜色、图片
    [self.hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hotButton setImage:[UIImage imageNamed:@"标签图标-最热"] forState:UIControlStateNormal];
    
    //重新加载数据
    [self getDataWithGetType:@"new" andCurrId:@"-1"];
}


- (void)getCycleData{
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoURL];
    NSString *videoType = @"Hot";
    NSString *videoCurrId = @"-1";
    NSString *getType = @"new";
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",videoType, videoCurrId, self.videosTag, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@", urlString, videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], self.videosTag];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSLog(@"轮播图url : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            self.cycleDataSourceArray = responseDic[@"data"];
            
//            [self setCycleScrollView];
            [self initPageController];
            
            //隐藏infoLabel
            if (self.infoLabel.isHidden == NO) {
                self.infoLabel.hidden = YES;
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
}

- (NSString *)getVideoType{
    NSString *videoType = @"";
    //根据当前button的下标来转换type
    if (self.currentSelectIndex == 0) {
        videoType = @"All";
    }else if (self.currentSelectIndex == 1) {
        videoType = @"MMA";
    }else if (self.currentSelectIndex == 2) {
        videoType = @"Boxing";
    }else if (self.currentSelectIndex == 3) {
        videoType = @"Wrestling";
    }else if (self.currentSelectIndex == 4) {
        videoType = @"FemaleWrestling";
    }else if (self.currentSelectIndex == 5) {
        videoType = @"ThaiBoxing";
    }else if (self.currentSelectIndex == 6) {
        videoType = @"Taekwondo";
    }else if (self.currentSelectIndex == 7) {
        videoType = @"Judo";
    }else if (self.currentSelectIndex == 8) {
        videoType = @"Sumo";
    }else if (self.currentSelectIndex == 9) {
        //暂无
        videoType = @"Wrestling";
    }else if (self.currentSelectIndex == 10) {
        //暂无
        videoType = @"Sumo";
    }
    self.currentVideoType = videoType;
    return videoType;
}

- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)videoCurrId{
    //判断是否时当前标签刷新，如果不是，则晴空数据源，刷新列表，如果时当前列表，则暂不清空数据和刷新列表
    NSString *oldVideoType = self.currentVideoType;
    NSString *newVideotype = [self getVideoType];
    if (![oldVideoType isEqualToString:newVideotype]) {
        [self.tableViewDataSourceArray removeAllObjects];
        [self.collectionView reloadData];
    }
    
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoURL];
    NSString *videoType = [self getVideoType];
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",videoType, videoCurrId, self.videosTag, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@", urlString, videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], self.videosTag];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"get video list url: %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"status : %@", status);
        if ([status isEqualToString:@"success"]) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
            
            if ([videoType isEqualToString:@"All"]) {
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
            if ([videoType isEqualToString:@"All"]) {
                self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
            }else{
                //                [self.tableViewController.tableView.tableHeaderView removeFromSuperview];
                self.tableViewController.tableView.tableHeaderView = nil;
                
            }
            
            //将最新的数据“self.tableViewDataSourceArray”写入缓存列表
            [self saveCache];
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            
            //隐藏infoLabel
            if (self.infoLabel.isHidden == NO) {
                self.infoLabel.hidden = YES;
            }
        }else if([status isEqualToString:@"error"]){
            NSLog(@"message : %@", responseDic[@"message"]);
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        NSLog(@"error : %@", error);
    }];
}

- (void)saveCache{
    FTCache *cache = [FTCache sharedInstance];
    NSArray *dataArray = [[NSArray alloc]initWithArray:self.tableViewDataSourceArray];
    FTCacheBean *cacheBean = [[FTCacheBean alloc] initWithTimeStamp:[[NSDate date] timeIntervalSince1970]  andDataArray:dataArray andVideoTag:self.videosTag];

    [cache.videoDataDic setObject:cacheBean forKey:[NSString stringWithFormat:@"%ld", self.currentSelectIndex]];
    
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

//- (void)setCycleScrollView{
//    NSMutableArray *imagesURLStrings = [NSMutableArray new];
//    NSMutableArray *titlesArray = [NSMutableArray new];
//    if (self.cycleDataSourceArray) {
//        for(NSDictionary *dic in self.cycleDataSourceArray){
//            [imagesURLStrings addObject:dic[@"img_big"]];
//            [titlesArray addObject:dic[@"title"]];
//            
//        }
//    }
//    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375) delegate:self placeholderImage:[UIImage imageNamed:@"空图标大"]];
//    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    
//#pragma -mark -暂时隐藏轮播图的标题（没有给轮播图传title的值）
//    _cycleScrollView.titlesGroup = titlesArray;
//    
//    _cycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
//    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
//    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
//    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//    //    [_cycleScrollView.mainView reloadData];
//}

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
//    if(!self.tableViewController){
//        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
//        
//        self.tableViewController.newsOrVideo = @"video";
//        self.tableViewController.FTdelegate = self;
//        self.tableViewController.order = 0;
//        //设置上拉、下拉刷新
//        [self setJHRefresh];
//    }
    if (self.collectionView == nil) {
        [self initCollectionView];
    }
    
    self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
    
    if (self.tableViewDataSourceArray) {
        [self.collectionView footerEndRefreshing];
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        //    self.tableViewController.sourceArray = _sourceArry[0];
//        NSLog(@"没有数据源。");
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
}

#pragma -mark -初始化collectionView
- (void)initCollectionView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
//    flow.minimumLineSpacing = 15 * SCALE;
    //列间距
    flow.minimumInteritemSpacing = 16 * SCALE;
    
    //cell大小设置
//    NSLog(@"scale : %f", SCALE);
//    NSLog(@"screen width  : %.0f", SCREEN_WIDTH);
    
//    CGRect r = self.view.frame;
//    r.size.width = SCREEN_WIDTH;
//    self.view.frame = r;
    
//    float width = 164 * SCALE;
    float width = 164 * SCALE;
    float height = 143 * SCALE;
    flow.itemSize = CGSizeMake(width, height);
//    NSLog(@"cell宽：%f, 高：%f。屏幕宽度：%f,self.view的宽度：%f", width, height, SCREEN_WIDTH, self.view.frame.size.width);
//    NSLog(@"child view的宽度：%f,高度：%f",self.view.frame.size.width, self.view.frame.size.height);
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
    
    
//    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.currentView.frame.size.width, self.currentView.frame.size.height + 500) collectionViewLayout:flow];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.currentView.frame.size.width, SCREEN_HEIGHT - 150 - 49) collectionViewLayout:flow];
    _collectionView.backgroundColor = [UIColor clearColor];
        CGRect r = _collectionView.frame;
        r.size.width = SCREEN_WIDTH;
        _collectionView.frame = r;
    
//    NSLog(@"current view的y:%f", self.currentView.frame.origin.y);
//    NSLog(@"collectionView的y:%f", _collectionView.frame.origin.y);
//    
//    NSLog(@"current view的高度:%f", self.currentView.frame.size.height);
//    NSLog(@"collectionView的高度:%f", _collectionView.frame.size.height);
    [self.currentView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"asdf"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self setJHRefresh];
    
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
        //获取对应的bean，传递给下个vc
        NSDictionary *newsDic = self.tableViewDataSourceArray[indexPath.row];
        FTVideoBean *bean = [FTVideoBean new];
        [bean setValuesWithDic:newsDic];
        
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
    return self.tableViewDataSourceArray.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FTVideoCollectionViewCell" owner:self options:nil]firstObject];
        }
        FTVideoBean *videoBean = [FTVideoBean new];
        [videoBean setValuesWithDic:self.tableViewDataSourceArray[indexPath.row]];
        [cell setWithBean:videoBean];
    return cell;
}


- (void)setJHRefresh{
    __unsafe_unretained __typeof(self) weakSelf = self;

    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithGetType:@"new" andCurrId:@"-1"];
    }];

    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                NSString *currId;
                if (weakSelf.tableViewDataSourceArray && weakSelf.tableViewDataSourceArray.count > 0) {
                    currId = [weakSelf.tableViewDataSourceArray lastObject][@"videosId"];
                    //如果当前是按“最热”来，需要找到最小的id座位current id
                    if ([self.videosTag isEqualToString:@"0"]) {
                        int minId = [currId intValue];
                        for (NSDictionary *videoInfo in weakSelf.tableViewDataSourceArray) {
                            int videoId = [videoInfo[@""] intValue];
                            if (videoId < minId) {
                                minId = videoId;
                            }
                        }
                        currId = [NSString stringWithFormat:@"%d", minId];
                    }
                    
                }else{
                    return;
                }
        
                [weakSelf getDataWithGetType:@"old" andCurrId:currId];
    }];
    // 显示footer
    self.collectionView.mj_footer.hidden = NO;
    
}

#pragma mark - 按钮事件
//
- (void)clickAction:(UIButton *)sender
{
    if(self.currentSelectIndex != sender.tag - 1){
        //修改点击标签的逻辑为：不是每次都加载。
        
        //        self.currentSelectIndex = sender.tag-1;
        //        FTTableViewController *tableVC = [self controllerWithSourceIndex:sender.tag-1];
        //        [self.pageViewController setViewControllers:@[tableVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        //            NSLog(@" 设置完成 ");
        //        }];
        
        
//        if (self.currentSelectIndex == 0) {
//            self.tableViewController.tableView.tableHeaderView = self.cycleScrollView;
//        }else{
//            self.tableViewController.tableView.tableHeaderView = nil;
//        }
//        self.tableViewController.sourceArray = nil;
//        [self.tableViewController.tableView reloadData];
        
        self.currentSelectIndex = sender.tag-1;//根据点击的按钮，设置当前的选中下标
        
        //根据当前下标，先去缓存中查找是否有数据
        FTCache *cache = [FTCache sharedInstance];
        FTCacheBean *cacheBean = [cache.videoDataDic objectForKey:[NSString stringWithFormat:@"%ld", self.currentSelectIndex]];
        
        if (cacheBean) {//如果有当前标签的缓存，则接着对比时间
            
            NSTimeInterval currentTS = [[NSDate date]timeIntervalSince1970];
            NSTimeInterval timeGap = currentTS - cacheBean.timeStamp;
            NSString *videoTag = cacheBean.videoTag;
            if (timeGap < 5 * 60 && [videoTag isEqualToString:self.videosTag]) {//如果在5分钟内，而且videoTag一样，则用缓存
                    //如果有可用缓存，则用缓存作为数据源，刷新collectionView
                self.tableViewDataSourceArray = [[NSMutableArray alloc]initWithArray:cacheBean.dataArray];
                [self.collectionView reloadData];
                return;
            }
        }
        //如果没有可用缓存，则置空数据源，再去刷新
        self.tableViewDataSourceArray = nil;
        [self.collectionView reloadData];
        
        [self getDataWithGetType:@"new" andCurrId:@"-1"];
    }
}


#pragma mark - PrivateAPI
//
- (FTTableViewController *)controllerWithSourceIndex:(NSInteger)index
{
    if (self.sourceArry.count < index) {
        return nil;
    }
//    NSLog(@"%ld", index);
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
    
//    NSLog(@"scroll");
    
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
    
    FTVideoDetailViewController *videoDetailViewController = [FTVideoDetailViewController new];
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = self.cycleDataSourceArray[index];
    FTVideoBean *bean = [FTVideoBean new];
    [bean setValuesWithDic:newsDic];
    
    videoDetailViewController.bean = bean;
    
    [self.navigationController pushViewController:videoDetailViewController animated:YES];
}

- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
    //    NSLog(@"第%ld个cell被点击了。", indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
        //获取对应的bean，传递给下个vc
        NSDictionary *newsDic = tableView.sourceArray[indexPath.row];
        FTVideoBean *bean = [FTVideoBean new];
        [bean setValuesWithDic:newsDic];
        
        videoDetailVC.videoBean = bean;
        
        videoDetailVC.indexPath = indexPath;
        videoDetailVC.delegate = self;
        
        [self.navigationController pushViewController:videoDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}

- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.tableViewDataSourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.viewCount] forKey:@"viewCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.commentCount] forKey:@"commentCount"];
//    NSLog(@"indexPath.row : %ld", indexPath.row);
    self.tableViewDataSourceArray[indexPath.row] = dic;
//    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
