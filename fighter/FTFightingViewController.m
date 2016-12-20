//
//  FTInformationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTFightingViewController.h"
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
#import "FTRankViewController.h"
#import "NetWorking.h"
#import "FTLYZButton.h"
#import "FTLaunchNewMatchViewController.h"
#import "FTFightingTableViewCell.h"
#import "FTMatchBean.h"
#import "FTMatchDetailBean.h"
#import "WXApi.h"
#import "FTMatchLiveViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTVideoDetailViewController.h"
#import "FTVideoBean.h"
#import "FTMatchPreViewController.h"
#import "FTBetView0.h"
#import "FTBetView.h"
#import "FTPayViewController.h"
#import "FTHomepageMainViewController.h"
#import "FTPaySingleton.h"
#import "FTView.h"

/**
 *  数据结构思路22：
 源数据用字典存，key值为比赛日期，对应的value为数组，数组中存放一个个比赛信息
 再用array顺序存放字典的key值（即日期），校正数据的顺序
 */

@interface FTFightingViewController ()<UITableViewDelegate, UITableViewDataSource, FTFightingTableViewCellButtonsClickedDelegate, FTBetViewDelegate0, FTBetViewDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong)NSMutableArray *dateArray;//
@property (nonatomic, strong) NSMutableDictionary *matchesDic;//
@property (nonatomic, copy) NSString *pageSize;//每一页多少条数据
@property (nonatomic, assign) int pageNum;//当前页,1表示第一页
@property (weak, nonatomic) IBOutlet UITableView *tableView;//显示比赛列表的

//上方的条件筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *allMatchesButton;
@property (weak, nonatomic) IBOutlet UIButton *abountToStartButton;
@property (weak, nonatomic) IBOutlet UIButton *matchedButton;

//当前选中的筛选条件：0、1、2，默认为0
@property (nonatomic, assign)int conditionOffset;

//今日时间，明日时间的日期字符串，用于header文本显示，格式：“2016-12-23”
@property (nonatomic, copy) NSString *todayDateString;
@property (nonatomic, copy) NSString *tomorrowDateString;

@end

@implementation FTFightingViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self setNavigationbar];
    [self initBaseData];
    [self initSubViews];
    [self getMatchList];//初次加载数据
}


- (void)viewWillAppear:(BOOL)animated{
    [MobClick event:@"mainPage_BoxingNews"];
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - set

- (void) setNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchDetailAction:) name:SwitchFightingDetailNoti object:nil];
}

- (void)initBaseData{
    _pageNum = 1;
    _pageSize = @"10";
    
    _dateArray = [NSMutableArray new];
    _matchesDic = [NSMutableDictionary new];
    
    _todayDateString = [FTTools getDateStringWith:[[NSDate date] timeIntervalSince1970]];//根据当前时间戳获取当天日期,格式“2017-7-26"
    _tomorrowDateString = [FTTools getDateStringWith:[[NSDate date] timeIntervalSince1970] + 24 * 60 * 60];//根据(当前时间戳+1天的秒数)获取明天日期,格式“2017-7-26"
}


- (void)initSubViews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableView];//设置tableview
}


#pragma mark - 筛选按钮的点击事件
- (IBAction)allButtonClicked:(id)sender {
    _allMatchesButton.selected = YES;
    _abountToStartButton.selected = NO;
    _matchedButton.selected = NO;
    _conditionOffset = 0;//用于表示当前筛选条件，0为全部，1为即将开始，2为匹配我的
    
    //点击筛选按钮后，重置为第一页，刷新数据
    _pageNum = 1;
    [self getMatchList];
}
- (IBAction)abountToStartButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = YES;
    _matchedButton.selected = NO;
    _conditionOffset = 1;
    
    _pageNum = 1;
    [self getMatchList];
}

- (IBAction)matchedButtonClicked:(id)sender {
    _allMatchesButton.selected = NO;
    _abountToStartButton.selected = NO;
    _matchedButton.selected = YES;
    _conditionOffset = 2;
    
    _pageNum = 1;
    [self getMatchList];
}


- (void)getMatchList{
    //显示加载hud
    NSString *status = @"";
    NSString *payStatus = @"";
    NSString *label = @"";
    NSString *againstId = @"";
    NSString *weight = @"";
    if (_conditionOffset == 0) {
        
    } else if (_conditionOffset == 1){
        status = @"1";
        payStatus = @"1";
    }else if (_conditionOffset == 2){
        
#pragma mark -    warn    下面三个参数根据用户自己的信息去完善
        label = @"泰拳";
        label = [label stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        againstId = @"";
        weight = @"70";
    }
    
    FTUserBean *loginUserBean = [FTUserTools getLocalUser];
    NSString *userId = @"";
    if (loginUserBean) {
        userId = loginUserBean.olduserid;
    }
    
    [NetWorking getMatchListWithPageNum:_pageNum andPageSize:_pageSize andStatus:status andPayStatus:payStatus andLabel:label andAgainstId:againstId andWeight:weight andUserId:userId andOption:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];//隐藏hud
                if (array) {
                    if (_pageNum == 1) {//如果是第一页，清除历史数据
                        [_dateArray removeAllObjects];
                        [_matchesDic removeAllObjects];
                        /**
                         处理获取的数据，把array组装成一个array和一个字典
                         字典的key值为转换后的日期,value为一个可变数组，存放某天的所有比赛
                         array按次序存放日期，用于矫正字典的顺序
                         */
                        for (int  i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            NSTimeInterval matchDateTimeStamp = [dic[@"theDate"] doubleValue ] / 1000;
                            NSLog(@"theDate : %f", matchDateTimeStamp);
                            NSString *matchDateString = [FTTools getDateStringWith:matchDateTimeStamp];
                            NSLog(@"theDate : %@", matchDateString);
                            [FTTools saveDateStr:matchDateString ToMutableArray:_dateArray];//处理
                            
                            FTMatchBean *matchBean = [FTMatchBean new];
                            [matchBean setValuesForKeysWithDictionary:dic];
                            
                            NSMutableArray *matchBeansArray = _matchesDic[matchDateString];//存放某天所有比赛的数组
                            if (!matchBeansArray) {
                                matchBeansArray = [NSMutableArray new];
                            }
                            [matchBeansArray addObject:matchBean];
                            [_matchesDic setValue:matchBeansArray forKey:matchDateString];
                        }
                        
                    }else if(_pageNum > 1){//如果不是第一页，追加
                        //处理获取的数据，把array组装成一个array和一个字典，字典的key值为转换后的日期，array按次序存放日期，用于矫正字典的顺序
                        for (int  i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            NSTimeInterval matchDateTimeStamp = [dic[@"theDate"] doubleValue]/ 1000;
                            NSString *matchDateString = [FTTools getDateStringWith:matchDateTimeStamp] ;
                            [FTTools saveDateStr:matchDateString ToMutableArray:_dateArray];//处理
                            
                            FTMatchBean *matchBean = [FTMatchBean new];
                            [matchBean setValuesForKeysWithDictionary:dic];
                            NSMutableArray *matchBeansArray = _matchesDic[matchDateString];//存放某天所有比赛的数组
                            if (!matchBeansArray) {
                                matchBeansArray = [NSMutableArray new];
                            }
                            [matchBeansArray addObject:matchBean];
                            [_matchesDic setObject:matchBeansArray forKey:matchDateString];
                        }
                        
                    }
                    
                    //刷新成功
                    if (_pageNum == 1) {
                        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                    }else if (_pageNum > 1) {
                        [self.tableView footerEndRefreshing];
                    }

                    
                    [self.tableView reloadData];
                    
                }else {
                    if (_pageNum == 1){
                        if (array == nil) {
                            [self.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
                        }else{
                            [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
                        }
                        
                    }else if (_pageNum > 1){
                        [self.tableView footerEndRefreshing];
                    }
                }
    }];
}

/**
 *  将字符串存入可变数组，如果存在，则不存
 *
 *  @param str 传入的字符串
 */
- (void)saveDateStrToArray:(NSString *)str{
    BOOL containStr = false;
    for (NSString *string in _dateArray) {
        if ([string isEqualToString:str]){
            containStr = true;
            break;
        }
    }
    if (!containStr) {
        [_dateArray addObject:str];
    }
}

#pragma mark - 视图加载
//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, 100, 14)];
    NSString *dateString = _dateArray[section];
    if ([dateString isEqualToString:_todayDateString]) {
        dateString = @"今日赛事";
    } else if ([dateString isEqualToString:_tomorrowDateString]){
        dateString = @"明日赛事";
    }
    label.text = dateString;
    label.textColor = [UIColor colorWithHex:0xb4b4b4];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}
//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

- (void)setTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FTFightingTableViewCell" bundle:nil] forCellReuseIdentifier:@"matchCell"];
        [self setJHRefresh];
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dateArray.count;
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *dateString = _dateArray[section];
    NSArray *beansArray = _matchesDic[dateString];
    return beansArray.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 173;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTFightingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];
    cell.buttonsClickedDelegate = self;
    NSString *dateString = _dateArray[indexPath.section];
    NSArray *beansArray = _matchesDic[dateString];
    FTMatchBean *matchBean = beansArray[indexPath.row];
    cell.matchBean = matchBean;
    [cell setWithBean:matchBean];
    return cell;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = _dateArray[indexPath.section];
    NSArray *matchArray = _matchesDic[key];
    FTMatchBean *matchBean = matchArray[indexPath.row];
    NSLog(@"match id : %@", matchBean.matchId);
    //比赛状态：①未开始②进行中③已结束 status = 2 比赛进行中； = 3 比赛结束； 其他未开赛
    if ([matchBean.statu isEqualToString:@"2"]) {
        NSLog(@"比赛进行中");
        FTMatchLiveViewController* matchLiveVC = [FTMatchLiveViewController new];
        matchLiveVC.matchBean = matchBean;
        [self.navigationController pushViewController:matchLiveVC animated:YES];
    } else if ([matchBean.statu isEqualToString:@"3"]){
        NSLog(@"比赛结束");
        NSLog(@"url : %@", matchBean.urlRes);
        NSString *url = matchBean.urlRes;
        NSLog(@"url : %@", url);
        
        NSArray *strArray = [url componentsSeparatedByString:@"id="];
        NSString *idAndOtherStr = [strArray lastObject];
        NSString *objId = [[idAndOtherStr componentsSeparatedByString:@"&"] firstObject];//资讯或视频ID
        
        FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
        
        //判断是咨询还是视频
        NSArray *typeStrArray= [url componentsSeparatedByString:@"&type="];
        NSString *typeStr = [typeStrArray lastObject];
        if ([typeStr isEqualToString:@"1"]) {//资讯
            videoDetailVC.detailType = FTDetailTypeNews;
        } else if ([typeStr isEqualToString:@"2"]) {//视频
            videoDetailVC.detailType = FTDetailTypeVideo;
        }
        
        if (matchBean.urlRes) {
            FTNewsBean *newsBean = [FTNewsBean new];
            newsBean.newsId = objId;
            videoDetailVC.urlId = objId;
//            videoDetailVC.videoBean = videoBean; // *  没有视频了 2016-11-21 by lyz */
            videoDetailVC.newsBean = newsBean;
        }
        
        [self.navigationController pushViewController:videoDetailVC animated:YES];
        
    }else{
        NSLog(@"尚未开赛");
        NSLog(@"url : %@", matchBean.urlPre);
        
        NSString *webViewURL;
        if (matchBean.urlPre) {
            webViewURL = matchBean.urlPre;
        } else {
            webViewURL = @"http://www.gogogofight.com";
        }
        FTMatchPreViewController *matchPreVC = [FTMatchPreViewController new];
        matchPreVC.webViewURL = webViewURL;
        matchPreVC.title = @"赛前宣传";
        [self.navigationController pushViewController:matchPreVC animated:YES];
    }
}

- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.pageNum = 1;
        [sself getMatchList];

    }];
    //设置上拉刷新
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.pageNum ++;
        [sself getMatchList];
    }];
}



#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic {
    /**
     *  type为比赛状态，赛前、赛中、赛后分别对应0、1、2
     */
    NSString *type = [NSString stringWithFormat:@"%@", dic[@"type"]];
    FTMatchBean *matchBean = [FTMatchBean new];
    matchBean.matchId = [NSString stringWithFormat:@"%@", dic[@"objId"]];
    if ([type isEqualToString:@"1"]) {
        matchBean.url = dic[@"url"];
        NSLog(@"比赛进行中");
        FTMatchLiveViewController* matchLiveVC = [FTMatchLiveViewController new];
        matchLiveVC.matchBean = matchBean;
        [self.navigationController pushViewController:matchLiveVC animated:YES];
    } else if ([type isEqualToString:@"0"]){
        NSLog(@"尚未开赛");
        matchBean.urlPre = dic[@"url"];
        NSLog(@"url : %@", matchBean.urlPre);
        
        NSString *webViewURL;
        if (matchBean.urlPre) {
            webViewURL = matchBean.urlPre;
        } else {
            webViewURL = @"http://www.gogogofight.com";
        }
        FTMatchPreViewController *matchPreVC = [FTMatchPreViewController new];
        matchPreVC.webViewURL = webViewURL;
        matchPreVC.title = @"赛前宣传";
        [self.navigationController pushViewController:matchPreVC animated:YES];
    }else if ([type isEqualToString:@"2"]){//更新余额
        FTPaySingleton *paySingleton = [FTPaySingleton shareInstance];
        [paySingleton fetchBalanceFromWeb:^{
            NSLog(@"更新余额成功");
        }];
    }
}

- (void)updateCountWithNewsBean:(FTNewsBean *)newsBean indexPath:(NSIndexPath *)indexPath{
    
    //    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    //    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.voteCount] forKey:@"voteCount"];
    //    [dic setValue:[NSString stringWithFormat:@"%@", newsBean.commentCount] forKey:@"commentCount"];
    
    
//    self.tableViewController.sourceArray[indexPath.row] = newsBean;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}


#pragma mark - cell中购票、观战、赞助、下注等按钮的点击回掉代理方法
//购票、赞助等按钮的点击事件
- (void)buttonClickedWithActionType:(FTMatchListButtonActionType)actionType andMatchBean:(FTMatchBean *)matchBean andButton:(UIButton *)button{
    NSLog(@"identifycation : %d, raceId : %@", actionType, matchBean.matchId);
    
    //获取当前登录用户的信息
//    FTUserBean *userBean = [FTUserTools getLocalUser];
    
    if (actionType == FTButtonActionWatch) {// status 2、比赛进行中 3、比赛结束
//        FTMatchLiveViewController* matchLiveVC = [FTMatchLiveViewController new];
//        matchLiveVC.matchBean = matchBean;
//        [self.navigationController pushViewController:matchLiveVC animated:YES];
        if ([matchBean.statu isEqualToString:@"2"]) {
            NSLog(@"比赛进行中");
            FTMatchLiveViewController* matchLiveVC = [FTMatchLiveViewController new];
            matchLiveVC.matchBean = matchBean;
            [self.navigationController pushViewController:matchLiveVC animated:YES];
        } else if ([matchBean.statu isEqualToString:@"3"]){
            NSLog(@"比赛结束");
            NSString *url = matchBean.urlRes;
            NSLog(@"url : %@", url);
            
            NSArray *strArray = [url componentsSeparatedByString:@"id="];
            NSString *idAndOtherStr = [strArray lastObject];
            NSString *objId = [[idAndOtherStr componentsSeparatedByString:@"&"] firstObject];
            
            FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
            
            if (matchBean.urlRes) {
                FTNewsBean *newsBean = [FTNewsBean new];
                newsBean.newsId = objId;
                videoDetailVC.urlId = objId;
                videoDetailVC.newsBean = newsBean;
            }
            
            
            
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
    } else if (actionType == FTButtonActionBuyTicket){
        
    }else if (actionType == FTButtonActionSupport){
        

    }else if (actionType == FTButtonActionFollow){
        NSLog(@"关注");
        //在本次关注、取消关注未完成前，把按钮置为不可选状态
        button.enabled = NO;
        FTUserBean *loginUserBean = [FTUserTools getLocalUser];
        if (loginUserBean) {
            [NetWorking followObjWithObjId:matchBean.matchId anIsFollow:!button.isSelected andTableName:@"f-mat" andOption:^(BOOL result) {
                button.enabled = YES;
                if (result) {
                    NSLog(@"成功");
                    button.selected = !button.isSelected;
                } else {
                    NSLog(@"失败");
                }
            }];
        }else{
            [FTTools loginwithVC:self];
            button.enabled = YES;
        }
#pragma mark - 下注
    }else if (actionType == FTButtonActionBet){
        NSLog(@"下注");
        
        if ([self validateLoginInfo]) {//先判断是否登录
            FTBetView0 *betView0 = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView0" owner:nil options:nil]lastObject];
            betView0.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            betView0.delegate = self;
            betView0.matchBean = matchBean;
            [betView0 updateDisplay];
            [self.view addSubview:betView0];
        }else{
            [self login];
        }
    }
    else if (actionType == FTButtonActionPay){
        /**
         *  点击支付后，先根据比赛id查到比赛需要支付的费用
         */
        
        [NetWorking getGymDetailWithGymId:matchBean.matchId andOption:^(NSArray *array) {
            if (array && array.count > 0) {
                NSLog(@"获取比赛详情成功");
                
                NSDictionary *dic = (NSDictionary *)array;
//                [ZJModelTool createModelWithDictionary:dic modelName:nil];
                FTMatchDetailBean *matchDetailBean = [FTMatchDetailBean new];
                
                /**
                 *  从服务器生成订单信息
                 */
                
                //参数
                    //获取当前登录用户的信息
                FTUserBean *userBean = [FTUserTools getLocalUser];
                
                NSString *userId = matchBean.userId;//发起人id
                NSString *objType = @"match";//类型
                NSString *objId = matchBean.matchId;//比赛id
                NSString *tableName = @"pl-mat";//表名：1. 下注为：pl-bet； 2. 购票为：pl-tic 3. 赛事成本支付相关：pl-mat
                NSString *type = matchBean.payType;//3. 赛事成本支付相关为支付类型，0-我支付，1-对方支付，2-赢家支付，3-AA支付，4-输家支付，5-赞助支付
                NSString *isDelated = @"3";//0-无效记录；1-s支付；2-p支付;3-RMB元支付(默认为元)
                NSString *money = @"1";//交易人民币
                NSString *payWay = @"1";//默认为0-积分支付； 值为1-微信支付
                NSString *body = @"支付比赛场地费用";//商品描述，需传入应用市场上的APP名字-实际商品名称，天天爱消除-游戏充值，示例：腾讯充值中心-QQ会员充值
                NSString *detail = @"";//商品详情，商品名称明细列表，示例：Ipad mini 16G 白色
                NSString *loginToken = userBean.token;//当前用户的login token
                NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
                
                //md5前的checkSign字典
                NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                                     @"userId":userId,
                                                                                                     @"objType":objType,
                                                                                                     @"objId":objId,
                                                                                                     @"tableName":tableName,
                                                                                                     @"type":type,
                                                                                                     @"money":money,
                                                                                                     @"payWay":payWay,
                                                                                                     @"body":body,
                                                                                                     @"detail":detail,
                                                                                                     @"loginToken":loginToken,
                                                                                                     @"ts":ts}];
                NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahdggrdearyhreayt251grd"];
                [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
                
                //把中文参数转码
                [dicBeforeMD5 setValue:[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"body"];
                [dicBeforeMD5 setValue:[detail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"detail"];
                
                NSDictionary *parmamDic = dicBeforeMD5;
                
                [NetWorking WXpayWithParamDic:parmamDic andOption:^(NSDictionary* dic) {
                    if (dic && dic.count > 0) {
                        NSLog(@"成功");
                        PayReq *request = [[PayReq alloc] init];
                        request.partnerId = dic[@"partnerid"];
                        request.prepayId= dic[@"prepayid"];
//                        request.package = @"Sign=WXPay";
                        request.package = dic[@"package"];
                        request.nonceStr= dic[@"noncestr"];
                        request.timeStamp= [dic[@"timestamp"] intValue];
                        request.sign= dic[@"sign"];
                        [WXApi sendReq:request];
                    } else {
                        NSLog(@"失败");
                    }
                    
                }];
                
            } else {
                NSLog(@"获取比赛详情失败");
            }
        }];
        
    }else if (actionType == FTButtonActionPlayer1){
        NSLog(@"player1");
        FTHomepageMainViewController *homepageMainViewController = [FTHomepageMainViewController new];
        homepageMainViewController.olduserid = matchBean.userId;
        [self.navigationController pushViewController:homepageMainViewController animated:YES];
    }else if (actionType == FTButtonActionPlayer2){
        NSLog(@"player2");
        FTHomepageMainViewController *homepageMainViewController = [FTHomepageMainViewController new];
        homepageMainViewController.olduserid = matchBean.againstId;
        [self.navigationController pushViewController:homepageMainViewController animated:YES];
    }else{
        //其他
        NSLog(@"其他");
    }
}

- (BOOL)validateLoginInfo{
    BOOL result = false;
    //判断是否登录
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        result = false;
    }else{
        result = true;
    }
    return result;
}
- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 迎战
- (void)responsToMatch:(FTMatchBean *)matchBean{
    //迎战
    FTUserBean *userBean = [FTUserTools getLocalUser];
    NSLog(@"迎战");
    NSString *userID = matchBean.userId;//发起人id，比赛列表的接口没有返回这个字段，无处获取，暂空
    NSString *userName = matchBean.userName;//发起人名字
    NSString *matchId = matchBean.matchId;//比赛id
    NSString *isAccept = @"1";//接受：1；拒绝：2
    NSString *againstId = userBean.olduserid;//迎战人的id
    NSString *againstName = userBean.username;//迎战人的名字
    NSString *loginToken = userBean.token;
    NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":userID,
                                                                                         @"userName":userName,
                                                                                         @"matchId":matchId,
                                                                                         @"isDelated":isAccept,
                                                                                         @"againstId":againstId,
                                                                                         @"against":againstName,
                                                                                         @"loginToken":loginToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahdgrfdytreytresy44"];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    
    //把中文参数转码
    [dicBeforeMD5 setValue:[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userName"];
    [dicBeforeMD5 setValue:[againstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"against"];
    
    NSDictionary *dic = dicBeforeMD5;
    
    [NetWorking responseToMatchWithParamDic:dic andOption:^(BOOL result) {
        if (result) {
            NSLog(@"成功");
        } else {
            NSLog(@"失败");
        }
        
    }];
}



#pragma mark - 参赛

/**
 *  参赛按钮被点击
 */
- (IBAction)entryButtonClicked:(id)sender {
    NSLog(@"参赛");
    FTLaunchNewMatchViewController *launchNewMatchViewController = [FTLaunchNewMatchViewController new];
    [self.navigationController pushViewController:launchNewMatchViewController animated:YES];
}

//跳转到充值界面
- (void)pushToRechargeVC{
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
}
//第一步中点击确认参与的回掉方法
- (void)betStep1WithBetValues:(int)betValue andIsPlayer1Win:(BOOL)isPlayer1Win  andMatchBean:(FTMatchBean *)matchBean{
    FTBetView *betView = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView" owner:nil options:nil]lastObject];
    betView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    betView.delegate = self;
//    betView.matchDetailBean = _matchDetailBean;
    betView.isbetPlayer1Win = isPlayer1Win;
    betView.betValue = betValue;
    betView.matchBean = matchBean;
    [betView updateDisplay];
    [self.view addSubview:betView];
}

//点击赞助后的回掉
- (void)betWithBetValues:(int)betValue andIsPlayer1Win:(BOOL)isPlayer1Win{
    NSLog(@"betValue : %d", betValue);
    NSLog(@"isPlayer1Win : %d", isPlayer1Win);
    //刷新下注数
//    [self getMatchDetailFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - 导航栏按钮
/**
 设置导航栏
 */
- (void) setNavigationbar {
    
    self.navigationController.delegate = self;
    [self.navigationController.navigationBar addSubview:self.rankBtn];
    [self.view addSubview:[self buttonFrameView]];
//    [self.view insertSubview:self.rankBtn aboveSubview:self.navigationController.navigationBar];
    
}

/**
 显示排行榜按钮
 */
- (void) showRankButton {
    [self.rankBtn setHidden:NO];
}


- (void) hideRankButton {
    [self.rankBtn setHidden:YES];
}

- (FTView *) buttonFrameView {
    
    FTView *buttonFrameView = [[FTView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 94 - 15, -3, 94, 30)];
    buttonFrameView.backgroundColor = [UIColor clearColor];
    [buttonFrameView  setRankButton:self.rankBtn];
    
    return buttonFrameView;
}


/**
 设置排行榜按钮
 
 @return 排行榜按钮
 */
- (UIButton *) rankBtn {
    
    if (!_rankBtn) {
        _rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rankBtn.frame = CGRectMake(SCREEN_WIDTH - 94 - 15, 41, 94, 30);
        [_rankBtn addTarget:self action:@selector(rankListBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rankBtn setImage:[UIImage imageNamed:@"右上排行榜"] forState:UIControlStateNormal];
        if (self.ranckButtonBlock) {
            _ranckButtonBlock(_rankBtn);
        }
    }
    
    return _rankBtn;
}

/**
 排行榜按钮点击事件,跳转排行榜页面
 
 @param sender 排行榜按钮
 */

- (void)rankListBtnAction:(id)sender {
    
    FTRankViewController *rankHomeVC = [FTRankViewController new];
    rankHomeVC.title = @"排行榜";
    [self.navigationController pushViewController:rankHomeVC animated:YES];
}


//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    // 当前坐标系上的点转换到按钮上的点
//    CGRect rect = [self.view convertRect:self.rankBtn.frame toView:self.view];
//    CGRectContainsPoint(rect, point);
//    // 判断点在不在按钮上
//    if (CGRectContainsPoint(rect, point)) {
//        // 点在按钮上
//        return self.rankBtn;
//    }else{
//        return [self.view.superview hitTest:point withEvent:event];
//    }
//}

#pragma mark - Navigation delegate

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (viewController == self.tabBarController && self.tabBarController.selectedIndex == 1 && animated) {
        _rankBtn.alpha = 0.2;
        _rankBtn.frame = CGRectMake(SCREEN_WIDTH - 94 - 15 - 94, 41, 94, 30);
        
        [UIView animateWithDuration:0.18 animations:^{
            _rankBtn.alpha = 1.0;
            _rankBtn.frame = CGRectMake(SCREEN_WIDTH - 94 - 15, 41, 94, 30);
        }];
    }
}


#pragma mark - 通知
- (void) switchDetailAction:(NSNotification *) noti {

    
}


@end
