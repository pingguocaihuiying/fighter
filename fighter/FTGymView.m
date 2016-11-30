//
//  FTGymView.m
//  fighter
//
//  Created by kang on 16/6/30.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymView.h"
#import "FTGymCell.h"
#import "FTButton.h"
#import "FTCycleScrollView.h"
#import "FTCycleScrollViewCell2.h"
#import "FTRankTableView.h"
#import "JHRefresh.h"
#import "FTGymDetailWebViewController.h"
#import "FTGymBean.h"
#import "FTGymVIPCellTableViewCell.h"
#import "FTGymDetailBean.h"
#import "FTGymSourceViewController2.h"
#import "NSString+Tool.h"

@interface FTGymView () <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, FTCycleScrollViewDelegate,FTSelectCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FTCycleScrollView *gymCycleScrollView;
//@property (nonatomic, strong)TestCycleView *coachCycleScrollView;

@property (nonatomic, strong)NSMutableArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *dataSourceArray;

@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *gymTag;    //排序
@property (nonatomic, copy) NSString *gymType;     //格斗项目
@property (nonatomic, copy) NSString *gymType_ZH;     //格斗项目

@property (assign) NSInteger currentPage;

@property (nonatomic, copy) NSString * gymCurrId;
@property (nonatomic, copy) NSString * getType;


@end

@implementation FTGymView


- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialization];
        [self setNotification];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark - 初始化
- (void) setNotification {

    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTableViewDataFromWeb) name:USER_SIGN_OUT object:nil];
}

- (void) initialization {
    
    _currentPage = 1;
    _gymTag = @"1";
    _gymType = @"ALL";
    _gymType_ZH = @"全部";
    _gymCurrId = @"-1";
    _getType = @"new";
    
    [self getCycleScrollViewDataFromWeb];
    [self getTableViewDataFromWeb];
    
}

- (void) initSubviews {
    
    [self initCycleScrollView];
    [self initTableView];
    
}

- (void)initCycleScrollView{
    
    _gymCycleScrollView = [FTCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375)
                                                               delegate:self
                                                       placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
    _gymCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    _gymCycleScrollView.backgroundColor = [UIColor clearColor];
    _gymCycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _gymCycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _gymCycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
//    _gymCycleScrollView.dataArray = _cycleDataSourceArray;
    _gymCycleScrollView.cycleCount = _cycleDataSourceArray.count;
    [_gymCycleScrollView.mainView registerNib:[UINib nibWithNibName:@"FTCycleScrollViewCell2" bundle:nil] forCellWithReuseIdentifier:@"gymScrollCell"];
    _gymCycleScrollView.mainView.dataSource = self;
    _gymCycleScrollView.mainView.delegate = self;
    
}

- (void) initTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, self.frame.size.width-12, self.frame.size.height)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FTGymCell" bundle:nil]  forCellReuseIdentifier:@"gymCell"];
//    [_tableView registerNib:[UINib nibWithNibName:@"FTGymVIPCellTableViewCell" bundle:nil]  forCellReuseIdentifier:@"gymVIPCell"];
    
    //    _tableView.tableHeaderView = _cycleScrollView;
    _tableView.tableHeaderView = _gymCycleScrollView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    [self setJHRefresh];
}

#pragma mark - get data from web

// 获取轮播图数据
- (void) getCycleScrollViewDataFromWeb {

    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"Hot" forKey:@"gymType"];
    [dic setObject:@"-1" forKey:@"gymCurrId"];
    [dic setObject:@"1" forKey:@"gymTag"];
    [dic setObject:@"new" forKey:@"getType"];
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",@"Hot",@"-1",@"1", @"new", ts, @"quanjijia222222"]];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
//    NSString *urlString = [NSString stringWithFormat:@"gymType=%@&gymCurrId=%@&gymTag=%@&getType=%@&ts=%@&checkSign=%@", @"All",@"-1", @"1", @"new", ts,checkSign];
//    NSLog(@"urlstring:%@",urlString);
    
    [NetWorking getGymsByDic:dic option:^(NSDictionary *dict) {
        
//        NSLog(@"cycle dict:%@",dict);
        if (dict != nil) {
            
            if ([dict[@"status"] isEqualToString:@"success"] ) {
                
                NSMutableArray *tempArray = dict[@"data"];
                if (tempArray.count > 0) {
                    _cycleDataSourceArray = tempArray;
                }
                
                [self initCycleScrollView];
                
            }
            
        }
        
        [self initTableView];
        
    }];
}

// 获取tableView 数据
- (void) getTableViewDataFromWeb {
    
    NSString *showType  = [FTNetConfig showType];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:_gymType forKey:@"gymType"];
    [dic setObject:_gymCurrId forKey:@"gymCurrId"];
    [dic setObject:_gymTag forKey:@"gymTag"];
    [dic setObject:_getType forKey:@"getType"];
    [dic setObject:showType forKey:@"showType"];
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    // 判断用户登录
    if (userId && userId.length >0) {
        [dic setObject:userId forKey:@"userId"];
    }
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",_gymType,_gymCurrId,_gymTag, _getType, ts, @"quanjijia222222"]];
    
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSString *urlString = [NSString stringWithFormat:@"gymType=%@&gymCurrId=%@&gymTag=%@&getType=%@&ts=%@&checkSign=%@",_gymType,_gymCurrId,_gymTag,_getType, ts,checkSign];
    NSLog(@"urlstring:%@",urlString);
    [NetWorking getGymsByDic:dic option:^(NSDictionary *dict) {
        
        [self.tableView footerEndRefreshing];
        
//        NSLog(@"table dict:%@",dict);
        SLog(@"table dic:%@",dict);
        
//        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (dict != nil) {
            
            NSArray *tempArray = dict[@"data"];
            SLog(@"gymType：%@",[tempArray[0][@"gymType"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if ([_getType isEqualToString:@"new"]) {
                _dataSourceArray = [NSMutableArray arrayWithArray:tempArray];
                
            }else {
                
                [_dataSourceArray addObjectsFromArray:tempArray];
            }
            
            [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
//            [self sortArray];
            [_tableView reloadData];
            
        }else {
             [self.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        }
        
    }];
}



/**
 拳馆列表数据排重
 */
- (void) sortArray {
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    for (NSDictionary *dic in _dataSourceArray) {
//        [dict setObject:dic forKey:dic];
//        
//        SLog(@"table dic:%@",dic);
//        SLog(@"拳馆名称：%@",[dic[@"gymName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//    }
//
//    [_dataSourceArray removeAllObjects];
//    for (int i =0; i< [dict allValues].count; i++) {
//        [_dataSourceArray addObject:[[dict allValues] objectAtIndex:i]];
//    }
    
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [_dataSourceArray count]; i++){
        
        if ([categoryArray containsObject:[_dataSourceArray objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[_dataSourceArray objectAtIndex:i]];
        }
    }
    
    [_dataSourceArray removeAllObjects];
    [_dataSourceArray addObjectsFromArray:categoryArray];
}
#pragma mark - 上下拉刷新
- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.currentPage = 1;
        sself.getType = @"new";
        sself.gymCurrId = @"-1";
//        if (sself.dataSourceArray && sself.dataSourceArray.count > 0) {
//           NSDictionary *dic = [sself.dataSourceArray firstObject];
//            _gymCurrId = dic[@"gymId"];
//        }
        
        [sself getTableViewDataFromWeb];
//        [sself.tableView reloadData];
        
    }];
    //设置上拉刷新
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.currentPage ++;
        sself.getType = @"old";
        
        if (sself.dataSourceArray && sself.dataSourceArray.count > 0) {
            NSDictionary *dic = [sself.dataSourceArray lastObject];
            sself.gymCurrId = dic[@"gymId"];
        }
        
        [sself getTableViewDataFromWeb];
        [sself sortArray];
//        [sself.tableView reloadData];
    }];
}


#pragma mark - delegates

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cycleDataSourceArray.count *100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [_cycleDataSourceArray objectAtIndex:indexPath.row%_cycleDataSourceArray.count];
    
    FTCycleScrollViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gymScrollCell" forIndexPath:indexPath];
    
    [cell.title setText:dic[@"gymName"]];
    [cell.subtitle setText:dic[@"gymLocation"]];

    NSString *imgStr = dic[@"gymShowImg"];
    if (imgStr && imgStr.length > 0) {
        NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@",dic[@"urlPrefix"],[tempArray objectAtIndex:0]];
        
        [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        FTGymDetailWebViewController *gymDetailWebViewController = [FTGymDetailWebViewController new];
        //获取对应的bean，传递给下个vc
        NSDictionary *newsDic = [self.cycleDataSourceArray objectAtIndex:indexPath.row%_cycleDataSourceArray.count];
        FTGymBean *bean = [FTGymBean new];
        [bean setValuesWithDic:newsDic];
        gymDetailWebViewController.gymBean = bean;
        
        if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
            [self.delegate pushToController:gymDetailWebViewController];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @try {
        
        if (scrollView == _gymCycleScrollView.mainView) {
            
            [_gymCycleScrollView mainViewDidScroll:scrollView];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _gymCycleScrollView.mainView) {
        
        [_gymCycleScrollView mainViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _gymCycleScrollView.mainView) {
        
        [_gymCycleScrollView mainViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //    if (scrollView == _coachCycleScrollView.mainView) {
    //
    //        [_coachCycleScrollView mainViewDidEndScrollingAnimation:scrollView];
    //    }
}


#pragma mark SDCycleScrollViewDelegate

/** 图片滚动回调 */
- (void)cycleScrollView:(FTCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [_dataSourceArray objectAtIndex:indexPath.row];
    
        
    static FTGymCell * cell =nil;
    static dispatch_once_t tonceToken;
    dispatch_once(&tonceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:@"gymCell"];
    });
    
    CGFloat labelView_H = [cell caculateHeight:dic[@"gymType"]];

    if (labelView_H == 0) {
        return 88;
    }
    return 88 + labelView_H;
    
}

//headerView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    
    return 50;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor colorWithHex:0x131313];
    
    UIView *sepataterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sepataterView.backgroundColor = [UIColor colorWithHex:0x282828];
    [headerView addSubview:sepataterView];
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    
    // 教练地址筛选按钮
    FTButton *addressBtn = [FTButton buttonWithtitle:@"北京"];
    addressBtn.frame = CGRectMake((buttonW+12)* 0, 0, buttonW, 40);
    [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addressBtn];
    
    // 教练排序按钮
    FTButton *orderBtn = [FTButton buttonWithtitle:@"按人气"];
    orderBtn .frame = CGRectMake((buttonW+12)* 1, 0, buttonW, 40);
    [orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:orderBtn];
    
    // 教练项目按钮
    FTButton *kindBtn = [FTButton buttonWithtitle:_gymType_ZH];
    kindBtn .frame = CGRectMake((buttonW+12)* 2, 0, buttonW, 40);
    [kindBtn addTarget:self action:@selector(kindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:kindBtn ];
    
    
    for (int i = 1; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"斜线分割"];
        imageView.frame = CGRectMake((buttonW+12)*i -12 , 8, 12, 24);
        [headerView addSubview:imageView];
        
    }
    
    [sectionHeader addSubview:headerView];
    return sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [_dataSourceArray objectAtIndex:indexPath.row];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:dic];
    
    
    FTGymCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gymCell"];
    [cell clearLabelView];
    cell.backgroundColor = [UIColor clearColor];
    
    
    
    [cell.title setText:dic[@"gymName"]];
    [cell.subtitle setText:dic[@"gymLocation"]];
    
    NSString *imgStr = dic[@"gymShowImg"];
    if (imgStr && imgStr.length > 0) {
        NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@",dic[@"urlPrefix"],[tempArray objectAtIndex:0]];
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"拳馆占位图"]];
    }else {
        
        [cell.avatarImageView setImage:[UIImage imageNamed:@"拳馆占位图"]];
    }
    
    
    [cell labelsViewAdapter:dic[@"gymType"]];
    
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = [self.dataSourceArray objectAtIndex:indexPath.row];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:newsDic];
    
    

    FTGymDetailBean *detailBean = [FTGymDetailBean new];
    detailBean.gym_name = bean.gymName;
    detailBean.corporationid = bean.corporationid;
    
    FTGymDetailWebViewController *gymDetailWebViewController = [FTGymDetailWebViewController new];
    gymDetailWebViewController.gymBean = bean;
    gymDetailWebViewController.gymDetailBean = detailBean;
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:gymDetailWebViewController];
    }

}


#pragma mark -FTSelectCellDelegate

- (void) selectedValue:(NSDictionary *)dic {

    _gymType = dic[@"itemValueEn"];
    _gymType_ZH = dic[@"itemValue"];
    _gymCurrId = @"-1";
    _getType = @"new";
    [self getTableViewDataFromWeb];
//    [self.tableView reloadData];
}
- (void) selectedValue:(NSString *)value style:(FTRankTableViewStyle)style {
    
    
}


#pragma mark - response

- (void) addressBtnAction:(id) sender {
    
    
}

- (void) orderBtnAction:(id) sender {
    
    
}


- (void) kindBtnAction:(id) sender {
    UIButton *button = sender;
    CGRect frame = [self convertRect:button.frame fromView:button.superview];
    
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleRight option:^(FTRankTableView *searchTableView) {
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@"ALL" forKey:@"itemValueEn"];
        [dic setObject:@"全部" forKey:@"itemValue"];
        [array insertObject:dic atIndex:0];
        
        searchTableView.dataArray = array;
        searchTableView.dataType = FTDataTypeDicArray;
        searchTableView.Btnframe = frame;
        searchTableView.tableW =frame.size.width;
        
        searchTableView.offsetY = 40;
        searchTableView.offsetX = -5;
        
        searchTableView.cellH = 40;
        if (array.count * 40 > self.frame.size.height-40-frame.origin.y) {
            
            searchTableView.tableH = self.frame.size.height-40-frame.origin.y;
        }else {
            searchTableView.tableH = array.count * 40;
        }
        
        //        [searchTableView caculateTableHeight];
        
    }];
    kindTableView.selectDelegate = self;
    [self addSubview:kindTableView];
}

- (FTButton *) selectButton:(NSString *)title {
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    FTButton *selectBtn = [FTButton buttonWithType:UIButtonTypeCustom option:^(FTButton *button) {
        
        button.imageH = 10;
        button.imageW = 13;
        button.buttonModel = FTButtonModelRightImage;
        button.space = 10.0;
        button.bounds = CGRectMake(0, 0, buttonW, 40);
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:Main_Text_Color forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头pre"] forState:UIControlStateHighlighted];
        
        CGSize size =  [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        
        if (size.width > buttonW - 30-10-13) {
            size = CGSizeMake(buttonW - 30-10-13, size.height);
        }
        
        button.textH = size.height;
        button.textW = size.width;
        
    }];
    
    return selectBtn;
}


- (void) enterGymBUttonAction:(UIButton *) sender {

    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = [self.dataSourceArray objectAtIndex:sender.tag];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:newsDic];
    
    FTGymSourceViewController2 *gymSourceViewController = [FTGymSourceViewController2 new];
    FTGymDetailBean *detailBean = [FTGymDetailBean new];
    detailBean.gym_name = bean.gymName;
    detailBean.corporationid = bean.corporationid;
    gymSourceViewController.gymDetailBean = detailBean;
    
    
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:gymSourceViewController];
    }
}


#pragma mark - 通知事件

// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    
    // 退出登录
    if ([userInfo[@"type"] isEqualToString:@"Logout"]) {
        self.currentPage = 1;
        self.getType = @"new";
        self.gymCurrId = @"-1";
        
        [self getTableViewDataFromWeb];
        
        return;
    }
    
    // 登录
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self getTableViewDataFromWeb];
    }
    
}


#pragma mark  - private



@end
