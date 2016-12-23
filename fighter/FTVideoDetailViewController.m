//
//  TestViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoDetailViewController.h"
#import "FTCommentViewController.h"
//#import "UMSocial.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "WXApi.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTPhotoPickerView.h"
#import "FTShareView.h"
#import "FTHomepageMainViewController.h"

@interface FTVideoDetailViewController ()<UIWebViewDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}

@property (nonatomic, strong) UIBarButtonItem *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *bottomCommentLabel;

@end

@implementation FTVideoDetailViewController


#pragma mark - life cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self checkNewsBean];//1.检查是否有传bean过来，如果没有，则根据objId去获取 2.如果bean存在，则把bean的id赋值给属性_objId，类中所有用到objId的，都用_objId
    
    [self setWebView];
    [self getVoteInfo];
    [self setLoadingImageView];
    
    //如果是视频，再增加观看数
    if (_detailType == FTDetailTypeVideo) {
        [self addViewCount];    
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -  abount server

- (void)checkNewsBean{
    if (_newsBean) {//如果bean存在，则赋值给_objId
        _objId = _newsBean.newsId;
        
        //更新评论数
        [self updateCommentCount];
    }else{        //如果bean不存在，从服务器获取
        NSLog(@"没有newsbean或newsbean没有标题，正在从服务器获取...");
        [self getNewsBeanFromServerById];
    }
    
}

- (void)getNewsBeanFromServerById{
    [NetWorking getNewsById:[NSString stringWithFormat:@"%@", _objId] andOption:^(NSArray *array) {
        FTNewsBean *newsBean = [FTNewsBean new];
        [newsBean setValuesWithDic:[array firstObject]];
        _newsBean = newsBean;
        
        //更新评论数
        [self updateCommentCount];
    }];
}


/**
 更新评论数，包括右上角和底部
 */
- (void)updateCommentCount{
    [self setRightButtonItemWithText:_newsBean.commentCount];
    [self updateBottomCommentCount];
}

- (void)getVoteInfo{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _objId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-news";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *_Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasVote = YES;
        }else{
            self.hasVote = NO;
        }
        
        [self updateVoteImageView];
    } failure:^(NSURLSessionTask *_Nonnull task, NSError * _Nonnull error) {
        //failure
    }];
    
    
}

- (void)getStarInfo{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _objId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"col-news";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *_Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasStar = YES;
        }else{
            self.hasStar = NO;
        }
        
        [self updateStarImageView];
    } failure:^(NSURLSessionTask *_Nonnull task, NSError * _Nonnull error) {
        //failure
    }];
}



/**
 把点赞信息更新至服务器
 */
- (void)uploadVoteStatusToServer{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _objId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-news";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasVote ? AddVoteCheckKey: DeleteVoteCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *_Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        self.voteView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            int voteCount = [_newsBean.voteCount intValue];
            NSString *changeVoteCount = @"0";
            if (self.hasVote) {
                voteCount++;
                changeVoteCount = @"1";
            }else{
                if (voteCount > 0) {
                    voteCount--;
                    changeVoteCount = @"-1";
                }
            }
            _newsBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
            NSString *jsMethodString = [NSString stringWithFormat:@"updateLike(%@)", changeVoteCount];
            NSLog(@"js method : %@", jsMethodString);
            [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
        self.voteView.userInteractionEnabled = YES;
        NSLog(@"vote failure ：%@", error);
    }];
    
}


/**
 更新收藏信息至服务器
 */
- (void)uploadStarStatusToServer{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:self.hasStar ? AddStarURL : DeleteStarURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _objId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName =  @"col-news";
    NSString *query = @"delete-col";
    //    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, self.hasStar ?  @"" : query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@&query=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName, query];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *_Nonnull task, id  _Nonnull responseObject)  {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收藏状态 status : %@, message : %@", responseDic[@"status"], responseDic[@"message"]);
        self.favourateView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
        self.voteView.userInteractionEnabled = YES;
        NSLog(@"收藏 failure ：%@", error);
    }];
    
}

/**
 *  增加视频的播放数
 */
- (void)addViewCount{
    //获取网络请求地址url
    NSString *addViewCountUrlString = [FTNetConfig host:Domain path:AddViewCountURL];
    
    NSString *newsId = _objId;
    NSString *ts = [NSString stringWithFormat:@"%.3f", [[NSDate date] timeIntervalSince1970]];
    ts = [ts stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", newsId, ts, UpVideoViewNCheckKey]];
    addViewCountUrlString = [NSString stringWithFormat:@"%@?&newsId=%@&ts=%@&checkSign=%@", addViewCountUrlString, newsId, ts, checkSign];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    [manager GET:addViewCountUrlString parameters:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        //
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
            int viewCount = [_newsBean.viewCount intValue];
            viewCount++;
            _newsBean.viewCount = [NSString stringWithFormat:@"%d", viewCount];
        }else{
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
        }
        
        [self updateVoteImageView];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"向服务器增加视频数失败，error：%@", error);
    }];
}

#pragma mark -  init view 

- (void)initSubViews{
    
    [self setEvnetListenerOfBottomViews];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];//把左边的返回按钮左移
    self.navigationItem.leftBarButtonItem = leftButton;
    

    
    //标题
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    //设置默认标题
    self.navigationItem.title = _detailType == FTDetailTypeNews ? @"拳讯" : @"视频";
    
    //底部评论数的颜色
    _bottomCommentLabel.textColor = [UIColor whiteColor];
}

- (void)setRightButtonItemWithText:(NSString *)text{
    //右上角按钮
    _commentButton = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@ 评论", text] style:UIBarButtonItemStylePlain target:self action:@selector(commentButtonClicked:)];
    _commentButton.tintColor = [UIColor colorWithHex:0xb4b4b4];
    self.navigationItem.rightBarButtonItem = _commentButton;
}
- (void)updateBottomCommentCount{
    NSString *commentCount = [NSString stringWithFormat:@"%@", _newsBean.commentCount];
    if([commentCount integerValue] > 999){//如果评论数大于999，只显示999+
        commentCount = @"999+";
    }
    _bottomCommentLabel.text = commentCount;
}
- (void)setEvnetListenerOfBottomViews{
    //设置点赞view的事件监听
    
    //收藏
    UITapGestureRecognizer *tapOfFavourateView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favourateButtonClicked:)];
    [self.favourateView addGestureRecognizer:tapOfFavourateView];
    self.favourateView.userInteractionEnabled = YES;
    
    //分享
    UITapGestureRecognizer *tapOfShareView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomShareButtonClicked)];
    [self.shareView addGestureRecognizer:tapOfShareView];
    
    //评论
    UITapGestureRecognizer *tapOfCommentView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentButtonClicked:)];
    [self.commentView addGestureRecognizer:tapOfCommentView];
}

- (void)setWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
    _webView.delegate = self;
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    NSString  *webViewUrlString = [NSString stringWithFormat:@"%@?objId=%@", WebViewURL, _objId];//12月31日 lyz修改 把webView地址统一了，不管是咨询还是视频
    NSLog(@"webViewUrlString : %@", webViewUrlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];
}

#pragma mark - action

- (void)popVC{
    
    [self.delegate updateCountWithVideoBean:_newsBean indexPath:self.indexPath];

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loginCallBack:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        
        [self.view showMessage:@"微信登录成功，可以评论或点赞了"];
    }else {
        [self.view showMessage:@"微信登录失败"];
    }
}

- (void)pushToCommentVC{
    
    FTCommentViewController *commentVC = [ FTCommentViewController new];
    commentVC.delegate = self;
    FTNewsBean *newsBean = [FTNewsBean new];
    newsBean.newsId = _objId;
    commentVC.newsBean = newsBean;
    
    
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)commentSuccess{
    int commentCount = [_newsBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", 1];
    NSLog(@"js method : %@", jsMethodString);
    _newsBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
    
    //评论成功后，从服务器获取最新的数据（包括评论数）
    [self getNewsBeanFromServerById];
}




- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 分享事件

- (IBAction)bottomShareButtonClicked:(id)sender {
    [self bottomShareButtonClicked];
}

/**
 *  上方的分享按钮被点击
 */
- (void)topShareButtonClicked{
    [MobClick event:@"videoPage_DetailPage_shareUp"];
    [self shareButtonClicked];
}

/**
 *  下方的分享按钮被点击
 */
- (void)bottomShareButtonClicked{
    [MobClick event:@"videoPage_DetailPage_shareDown"];
    [self shareButtonClicked];
}

- (void)shareButtonClicked{
    NSString  *webUrlString = [NSString stringWithFormat:@"%@?objId=%@", WebViewURL, _objId];
    
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:webUrlString];
    [shareView setTitle:_newsBean.title];
    [shareView setSummary:_newsBean.summary];
    [shareView setImage:@"G格斗家logo改进@200"];
    
    if ([_newsBean.layout isEqualToString:@"1"]) {//大图
        [shareView setImageUrl:_newsBean.img_big];
    }else if ([_newsBean.layout isEqualToString:@"2"]) {//图
        [shareView setImageUrl:_newsBean.img_small_one];
    }else if ([_newsBean.layout isEqualToString:@"3"]) {//3图
        [shareView setImageUrl:_newsBean.img_small_one];
    }
    
    [self.view addSubview:shareView];
    
}





/**
 取消分享按钮 事件

 @param sender
 */
- (IBAction)cancelShareButtonClicked:(id)sender {
    self.bgView.hidden = YES;
}

#pragma mark -

/**
 评论按钮response action

 @param sender
 */
- (IBAction)commentButtonClicked:(id)sender {
    [MobClick event:@"videoPage_DetailPage_Comment"];
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    if (!localUser) {
        [self login];
    }else{
        [self pushToCommentVC];
    }
    
}



/**
 点赞按钮response action

 @param sender
 */
- (IBAction)thumbButtonClicked:(id)sender {
    [MobClick event:@"videoPage_DetailPage_Zambia"];
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    if (!localUser) {
        [self login];
    }else{
        self.hasVote = !self.hasVote;
        [self updateVoteImageView];
        self.voteView.userInteractionEnabled = NO;
        [self uploadVoteStatusToServer];
    }
}


/**
 收藏按钮response action

 @param sender
 */
- (IBAction)favourateButtonClicked:(id)sender {
    [MobClick event:@"videoPage_DetailPage_Collection"];
    //从本地读取存储的用户信息
   FTUserBean *localUser = [FTUserBean loginUser];
    if (!localUser) {
        [self login];
    }else{
        self.hasStar = !self.hasStar;
        [self updateStarImageView];
        self.favourateView.userInteractionEnabled = NO;
        [self uploadStarStatusToServer];
    }
}

- (void)updateVoteImageView{
    if (self.hasVote) {
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"列表页-赞二态"] forState:UIControlStateNormal];
        
    }else{
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"列表页-赞"] forState:UIControlStateNormal];
    }
}

- (void)updateStarImageView{
    if (self.hasStar) {
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-收藏pre"] forState:UIControlStateNormal];
        
    }else{
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-收藏"] forState:UIControlStateNormal];
    }
}





#pragma mark - webView delegate

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidFinishLoad ****************");
    
    [self disableLoadingAnimation];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@", request.URL];
        NSLog(@"requestURL : %@", requestURL);
    
   if ([requestURL isEqualToString:@"js-call:onload"]) {
        
        [self disableLoadingAnimation];
    }else if ([requestURL hasPrefix:@"js-call:userId="]) {
        
        NSString *userId = [requestURL stringByReplacingOccurrencesOfString:@"js-call:userId=" withString:@""];
        //        NSLog(@"userId : %@", userId);
        FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
        homepageMainVC.olduserid = userId;
        [self.navigationController pushViewController:homepageMainVC animated:YES];
        
    }else  if ([requestURL hasPrefix:@"js-call:goGym?id="]) {
        
        NSString *gymId = [requestURL stringByReplacingOccurrencesOfString:@"s-call:goGym?id=" withString:@""];
        NSDictionary *dic = @{@"type":@"gym",
                              @"gymId":gymId
                              };
//        [self.navigationController popToRootViewControllerAnimated:NO];
        [FTNotificationTools postTabBarIndex:2 dic:dic];
    }else  if ([requestURL hasPrefix:@"js-call:goCoach?gymId="]) {
        
        NSArray *array = [requestURL componentsSeparatedByString:@"&"];
        NSString *gymId = [array[0] stringByReplacingOccurrencesOfString:@"js-call:goCoach?gymId=" withString:@""];
        NSString *coachId = [array[1] stringByReplacingOccurrencesOfString:@"coachId=" withString:@""];
        
        NSDictionary *dic = @{@"type":@"coach",
                              @"gymId":gymId,
                              @"coachId":coachId
                              };
//        [self.navigationController popToRootViewControllerAnimated:NO];
        [FTNotificationTools postTabBarIndex:2 dic:dic];
    }else  if ([requestURL isEqualToString:@"js-call:goShop"]) {
        
//        [self.navigationController popToRootViewControllerAnimated:NO];
        [FTNotificationTools postSwitchShopHomeNoti];
    }
    
    return YES;
}



#pragma  mark - 设置loading图
-(void)setLoadingImageView{
    //背景框imageview
    _loadingBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading背景"]];
    //    _loadingBgImageView.frame = CGRectMake(20, 100, 100, 100);
    _loadingBgImageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 64);
    [self.view addSubview:_loadingBgImageView];
    //声明数组，用来存储所有动画图片
    _loadingImageView = [UIImageView new];
    _loadingImageView.frame = CGRectMake(10, 10, 80, 80);
    
    [_loadingBgImageView addSubview:_loadingImageView];//把用于显示动画的imageview放入背景框中
    //初始化数组
    NSMutableArray *photoArray = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        //获取图片名称
        NSString *photoName = [NSString stringWithFormat:@"格斗家-loading2000%d", i];
        //获取UIImage
        UIImage *image = [UIImage imageNamed:photoName];
        //把图片加载到数组中
        [photoArray addObject:image];
    }
    //给动画数组赋值
    _loadingImageView.animationImages = photoArray;
    
    //一组动画使用的总时间长度
    _loadingImageView.animationDuration = 1;
    
    //设置循环次数。0表示不限制
    _loadingImageView.animationRepeatCount = 0;
    [_loadingImageView startAnimating];
}

- (void)startLoadingAnimation{
    //启动动画
    [_loadingImageView startAnimating];
    
}
- (void)disableLoadingAnimation {
    //停止动画，移除动画imageview
    [_loadingImageView stopAnimating];
    [_loadingImageView removeFromSuperview];
    _loadingImageView = nil;
    [_loadingBgImageView removeFromSuperview];
    _loadingBgImageView = nil;
}

@end
