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

@interface FTMatchLiveViewController ()<UITableViewDelegate, UITableViewDataSource, FTBetViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *blueProgressBarImageView;

@property (nonatomic, strong)NSArray *commentsDataArray;//评论数据源

@end

@implementation FTMatchLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self initSubViews];
    [self updateProgress];
    [self getCommentListData];//获取评论列表
    [self initCommentTableView];    //设置评论tableview
}

- (void)initBaseData{
    _betsNum1 = 178;
    _betsNum2 = 57;
}

- (void)initSubViews{
    [self setTopNaviViews];
    [self setLiveWebView];
    [self setProgressView];
}

- (void)setTopNaviViews{
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
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
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    //设置默认标题
    self.navigationItem.title = @"直播";
}

- (void)setProgressView{
    _betsNumLabel1.text = [NSString stringWithFormat:@"%d", _betsNum1];
    _betsNumLabel2.text = [NSString stringWithFormat:@"%d", _betsNum2];
}

- (void)updateProgress{
    CGFloat progressWidthTotal = SCREEN_WIDTH - 32 - 191;
    
    float denominator = _betsNum1 + _betsNum2;
    
    _progressWidth1.constant = progressWidthTotal * (_betsNum1 / denominator);
    _progressWidth2.constant = progressWidthTotal * (_betsNum2 / denominator);

    _betsNumLabel1.text = [NSString stringWithFormat:@"%d", _betsNum1];
    _betsNumLabel2.text = [NSString stringWithFormat:@"%d", _betsNum2];
}

- (void)setLiveWebView{
    _liveWebView.scrollView.scrollEnabled = NO;//禁止滚动
    
    //适配
    _webViewTopHeight.constant *= SCREEN_HEIGHT / 568;
    _webViewHeight.constant *= SCREEN_HEIGHT / 568;
    /**
     *  企鹅直播  http://live.qq.com/10002905
     *  斗鱼直播  http://www.douyu.com/611813
     */
    NSString *webURL = @"http://www.douyu.com/611813";
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
    [NetWorking getCommentsWithObjId:@"1" andTableName:@"" andOption:^(NSArray *array) {
        _commentsDataArray = array;
        
        [_commentTableView reloadData];
    }];
}
- (void)initCommentTableView{
    //设置tableview的代理
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    //从xib加载cell用于复用
    [_commentTableView registerNib:[UINib nibWithNibName:@"FTHomepageCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    _commentTableViewHeight.constant = (55 + 29 + 2 + 9) * 10;
    [_commentTableView reloadData];
    
}
//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_commentsDataArray) {
//        return _commentsDataArray.count;
//    }else{
//        return 0;
//    }
    return 10;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTHomepageCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
//    NSDictionary *commentDic = _commentsDataArray[indexPath.row];
//    [cell setWithDic:commentDic];
    
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
- (IBAction)betButton1Clicked:(id)sender {
    FTBetView *betView = [[[NSBundle mainBundle] loadNibNamed:@"FTBetView" owner:nil options:nil]lastObject];
    betView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    betView.delegate = self;
    betView.player1Name = @"安度因";
    betView.player2Name = @"游学者 周卓";
    [betView updateDisplay];
    [self.view addSubview:betView];
    
//    _betsNum1 += 5;
//    [self updateProgress];
}

//点击赞助后的回掉
- (void)betWithBetValues:(int)betValue{
    NSLog(@"betValue : %d", betValue);
}

- (IBAction)betButton2Clicked:(id)sender {
    _betsNum2 += 5;
    [self updateProgress];
}
@end
