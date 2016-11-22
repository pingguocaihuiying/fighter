//
//  FTMatchLiveViewController.m
//  fighter
//
//  Created by mapbar on 16/8/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTMatchLiveViewController.h"
#import "WXApi.h"
#import "FTShareView.h"
#import "FTHomepageCommentTableViewCell.h"
#import "FTBetView.h"
#import "FTBetView0.h"
#import "FTPayViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTCommentViewController.h"

@interface FTMatchLiveViewController ()<UITableViewDelegate, UITableViewDataSource, FTBetViewDelegate, FTBetViewDelegate0, CommentSuccessDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *blueProgressBarImageView;

@property (nonatomic, strong)NSArray *commentsDataArray;//评论数据源

@property (strong, nonatomic) IBOutlet UIImageView *header1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *header2ImageView;
@property (strong, nonatomic) IBOutlet UILabel *player1NameLabel;
@property (strong, nonatomic) IBOutlet UILabel *player2NameLabel;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;//点赞按钮
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;//评论数label
@property (strong, nonatomic) IBOutlet UILabel *viewCountLabel;//观看数
@property (strong, nonatomic) IBOutlet UILabel *voteCountLabel;//赞数
@property (nonatomic, assign) BOOL isFirstLoadData;//是否增加过观看数
@property (strong, nonatomic) IBOutlet UIView *commentCountBottomView;//评论数量下方的底边线
@property (strong, nonatomic) IBOutlet UIButton *betButton1;
@property (strong, nonatomic) IBOutlet UIButton *betButton2;

@end

@implementation FTMatchLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWebViewWidth];
    
    [self setTopNaviViews];//上方导航栏
    [self initBaseData];
    [self getMatchDetailFromServer];//获取比赛详细信息
    [self initCommentTableView];    //设置评论tableview
}

- (void)setWebViewWidth{
    _liveWebView.scrollView.scrollEnabled = NO;//禁止滚动
    CGFloat progressWidthTotal = SCREEN_WIDTH - 32 - 191;
    
    //声明两个变量，只用于计算
    int betsNum1 = 1;
    int betsNum2 = 1;
    
    if(betsNum1 <= 0 || betsNum2 <= 0){
        betsNum1 += 1;
        betsNum2 += 1;
    }
    
    float denominator = betsNum1 + betsNum2;
    
    CGFloat width1 = progressWidthTotal * (betsNum1 / denominator);
    CGFloat width2 = progressWidthTotal * (betsNum2 / denominator);
    _progressWidth1.constant = width1;
    _progressWidth2.constant = width2;
}

- (void)getVoteStatus{
    [NetWorking getVoteStatusWithObjid:[NSString stringWithFormat:@"%@", _matchDetailBean.matchId] andTableName:@"v-mat" andOption:^(BOOL result) {
        if (result) {
            _voteButton.selected = YES;
        }else{
            _voteButton.selected = NO;
        }
    }];
}

- (void)getMatchDetailFromServer{
    [NetWorking getGymDetailWithGymId:_matchBean.matchId andOption:^(NSArray *array) {
        if (array && array.count > 0) {
            NSDictionary *dic = (NSDictionary *)array;
            _matchDetailBean = [FTMatchDetailBean new];
            [_matchDetailBean setValuesForKeysWithDictionary:dic];
            
            
            //如果是第一次加载
            if (_isFirstLoadData) {
                //比赛详情加载成功后，把下注按钮置为可用
                    //业务有改，直播时不让下注
//                _betButton1.enabled = YES;
//                _betButton2.enabled = YES;
                
                //根据比赛详情设置页面展示信息
                [self initSubViews];
                [self getCommentListData];//获取评论列表
                //增加观看数
                [self addViewCount];
                _isFirstLoadData = NO;
                //获取观看数
                [self getViewCount];
                
                //显示点赞数
                _voteCountLabel.text = [NSString stringWithFormat:@"(%@)", _matchDetailBean.voteCount];
                [self getVoteStatus];//获取点赞信息
            }
            
            //每次获取最新的比赛信息后都刷新下注比例条
            [self updateBetsInfo];

        } else {
            NSLog(@"获取比赛详情失败");
        }
        
    }];
}

- (void)addViewCount{
    [NetWorking addViewCountWithObjid:[NSString stringWithFormat:@"%@", _matchDetailBean.matchId] andTableName:@"ve-mat" andOption:^(BOOL result) {
        if (result) {
            NSLog(@"更新观看数成功！");
        }else{
            NSLog(@"更新观看数成功！");
        }
    }];
}

- (void)getVoteCount{
    [NetWorking getCountWithObjid:[NSString stringWithFormat:@"%@", _matchDetailBean.matchId] andTableName:@"v-mat" andOption:^(NSString *viewCount) {
        _voteCountLabel.text = [NSString stringWithFormat:@"(%@)", viewCount];
    }];
}

- (void)getViewCount{
    [NetWorking getViewCountWithObjid: [NSString stringWithFormat:@"%@", _matchDetailBean.matchId] andTableName:@"ve-mat" andOption:^(NSString *viewCount) {
        if (viewCount) {
            NSLog(@"viewCount : %@", viewCount);
            _viewCountLabel.text = [NSString stringWithFormat:@"(%@)", viewCount];
        }
    }];
}

- (void)initBaseData{
    _isFirstLoadData = YES;
}

- (void)initSubViews{
    [self setLiveWebView];//直播页面
    [self setFighterInfo];//拳手信息.
    
//    [self updateBetsInfo];//更新下注比例图
    _voteCountLabel.text = [NSString stringWithFormat:@"(%@)", _matchDetailBean.voteCount];
}

- (void)setTopNaviViews{
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
//        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    //设置默认标题
    self.navigationItem.title = @"直播";
}





- (void)setFighterInfo{
    _player1NameLabel.text = _matchDetailBean.userName;
    _player2NameLabel.text = _matchDetailBean.against;
    
    [_header1ImageView sd_setImageWithURL:[NSURL URLWithString:_matchDetailBean.headUrl1]];
    [_header2ImageView sd_setImageWithURL:[NSURL URLWithString:_matchDetailBean.headUrl2]];
}

- (void)updateBetsInfo{
    _betsNumLabel1.text = [NSString stringWithFormat:@"%@", _matchDetailBean.bet1];
    _betsNumLabel2.text = [NSString stringWithFormat:@"%@", _matchDetailBean.bet2];
    
    CGFloat progressWidthTotal = SCREEN_WIDTH - 32 - 191;
    
    //声明两个变量，只用于计算
    int betsNum1 = [_matchDetailBean.bet1 intValue];
    int betsNum2 = [_matchDetailBean.bet2 intValue];
    
    if(betsNum1 <= 0 || betsNum2 <= 0){
        betsNum1 += 1;
        betsNum2 += 1;
    }
    
    float denominator = betsNum1 + betsNum2;
    
    CGFloat width1 = progressWidthTotal * (betsNum1 / denominator);
    CGFloat width2 = progressWidthTotal * (betsNum2 / denominator);
    _progressWidth1.constant = width1;
    _progressWidth2.constant = width2;

    _betsNumLabel1.text = [NSString stringWithFormat:@"%@", _matchDetailBean.bet1];
    _betsNumLabel2.text = [NSString stringWithFormat:@"%@", _matchDetailBean.bet2];
}

#pragma mark - 在xib文件加载时调整scrollView宽度为设备宽度

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)setLiveWebView{
    _liveWebView.scrollView.scrollEnabled = NO;//禁止滚动
    
    //适配
    _webViewTopHeight.constant *= SCREEN_HEIGHT / 568;
    _webViewHeight.constant *= SCREEN_HEIGHT / 568;
    /**
     *  企鹅直播  http://live.qq.com/10002905
     *  斗鱼直播  http://www.douyu.com/611813
     ufc  http://live.qq.com/10000202
     */
    NSString *webURL = @"http://www.douyu.com/lanxiang1]";
    webURL = _matchBean.url;
        [_liveWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    //根据不同的机型，调整遮盖view的高度，到达完美遮挡的目的
    NSLog(@"SCREEN_WIDTH : %f", SCREEN_WIDTH);
    if (SCREEN_WIDTH == 375) {//如果屏幕宽度是375，即6、6P
        NSLog(@"等于375");
        _customViewTopheight.constant = 210;
    } else if (SCREEN_WIDTH == 540){//如果是6s、6Ps
        NSLog(@"等于540");
        _customViewTopheight.constant = 180;
    }else if (SCREEN_WIDTH == 320){//如果是5、5s、se
        NSLog(@"等于320");
        _customViewTopheight.constant = 180;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCommentListData{
    [NetWorking getCommentsWithObjId:[NSString stringWithFormat:@"%@", _matchDetailBean.matchId] andTableName:@"c-mat" andOption:^(NSArray *array) {
        _commentsDataArray = array;
    _commentTableViewHeight.constant = (55 + 29 + 2 + 9) * _commentsDataArray.count;    
        [_commentTableView reloadData];
        
        //更新评论数
        _commentCountLabel.text = [NSString stringWithFormat:@"评论(%ld)", (unsigned long)_commentsDataArray.count];
        
        //如果评论数为0，则隐藏分割线；否则，显示
        if (_commentsDataArray && _commentsDataArray.count == 0) {
            _commentCountBottomView.hidden = YES;
        }else{
            _commentCountBottomView.hidden = NO;
        }
    }];
}
- (void)initCommentTableView{
    //设置tableview的代理
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    //从xib加载cell用于复用
    [_commentTableView registerNib:[UINib nibWithNibName:@"FTHomepageCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    _commentTableViewHeight.constant = (55 + 29 + 2 + 9) * _commentsDataArray.count;
    [_commentTableView reloadData];
    
}
//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_commentsDataArray) {
        return _commentsDataArray.count;
    }else{
        return 0;
    }
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTHomepageCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    NSDictionary *commentDic = _commentsDataArray[indexPath.row];
    [cell setWithDic:commentDic];
    
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**如果要设置动态行高，应该是其他固定高度+评论内容的高度，此处挖个坑，日后填
     ＊先写死为2行的高度
     */
    return 55 + 29 + 2 + 9;
}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClicked{
    //友盟分享事件统计
    NSLog(@"分享");
    [MobClick event:@"rankingPage_HomePage_ShareUp"];
    NSLog(@"转发");
    //友盟分享事件统计
    [MobClick event:@"newsPage_DetailPage_share"];
    
    //链接地址
    NSString *_webUrlString = @"";
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:_webUrlString];
    
    //分享标题
    NSString *title = @"直播";
    NSString *webUrlString = @"";
    
    
    //分享简述
    NSString *summaryString = @"国内顶尖高手直播";

    [shareView setTitle:title];
    [shareView setSummary:summaryString];
            [shareView setImage:@"微信用@200"];
    [shareView setImageUrl:@""];
    
    [shareView setUrl:webUrlString];

    [self.view addSubview:shareView];
}
#pragma mark 下注1
- (IBAction)betButton1Clicked:(id)sender {
    //判断是否登录
    if ([self validateLoginInfo]) {
        
//        FTBetView *betView = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView" owner:nil options:nil]lastObject];
//        betView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        betView.delegate = self;
//        betView.matchDetailBean = _matchDetailBean;
//        betView.isbetPlayer1Win = YES;
//        [betView updateDisplay];
//        [self.view addSubview:betView];
        
                FTBetView0 *betView0 = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView0" owner:nil options:nil]lastObject];
                betView0.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                betView0.delegate = self;
                [self.view addSubview:betView0];
    }else{
        [self login];
    }
}
#pragma mark 下注2
- (IBAction)betButton2Clicked:(id)sender {
    //判断是否登录
    if ([self validateLoginInfo]) {
        FTBetView *betView = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView" owner:nil options:nil]lastObject];
        betView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        betView.delegate = self;
        betView.matchBean = _matchBean;
        betView.isbetPlayer1Win = NO;
        [betView updateDisplay];
        [self.view addSubview:betView];
    }else{
        [self login];
    }
}

//第一步中点击确认参与的回掉方法
- (void)betStep1WithBetValues:(int)betValue andIsPlayer1Win:(BOOL)isPlayer1Win{
    FTBetView *betView = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView" owner:nil options:nil]lastObject];
    betView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    betView.delegate = self;
    betView.matchBean = _matchBean;
    betView.isbetPlayer1Win = isPlayer1Win;
    betView.betValue = betValue;
    [betView updateDisplay];
    [self.view addSubview:betView];
}

//点击赞助后的回掉
- (void)betWithBetValues:(int)betValue andIsPlayer1Win:(BOOL)isPlayer1Win{
    NSLog(@"betValue : %d", betValue);
    NSLog(@"isPlayer1Win : %d", isPlayer1Win);
    //刷新下注数
    [self getMatchDetailFromServer];
}
//跳转到充值界面
- (void)pushToRechargeVC{
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
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
- (IBAction)commentButtonClicked:(id)sender {
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        [self pushToCommentVC];
    }
}
- (IBAction)voteButtonClicked:(id)sender {
    if ([FTUserTools getLocalUser]) {
        _voteButton.selected = !_voteButton.selected;
        _voteButton.enabled = NO;
        [NetWorking addVoteWithObjid:[NSString stringWithFormat:@"%@", _matchDetailBean.matchId] isAdd:_voteButton.isSelected andTableName:@"v-mat" andOption:^(BOOL result) {
            _voteButton.enabled = YES;
            if (result) {
                NSLog(@"更新点赞成功");
                
                //更新点赞数量(根据点赞、取消点赞，点赞数+1、-1，没有从服务器获取最新赞数)
                NSString *voteCountString = _voteCountLabel.text;
                voteCountString = [voteCountString stringByReplacingOccurrencesOfString:@"(" withString:@""];
                voteCountString = [voteCountString stringByReplacingOccurrencesOfString:@")" withString:@""];
                int voteCount = [voteCountString intValue];
                voteCount = _voteButton.isSelected ? ++voteCount : --voteCount;
                _voteCountLabel.text = [NSString stringWithFormat:@"(%d)", voteCount];
            }else{
                NSLog(@"更新点赞失败");
            }
        }];
    } else {
        [FTTools loginwithVC:self];
    }

}
- (void)pushToCommentVC{
    
    FTCommentViewController *commentVC = [ FTCommentViewController new];
    commentVC.delegate = self;
    commentVC.matchDetailBean = _matchDetailBean;
    [self.navigationController pushViewController:commentVC animated:YES];
}
- (void)commentSuccess{
    [self getCommentListData];
}
@end
