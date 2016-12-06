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
@end

@implementation FTVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self setSubViews];
    [self setWebView];
    [self getVoteInfo];
    [self getStarInfo];
    [self setLoadingImageView];
    
    //如果是视频，再增加观看数
    if (_detailType == FTDetailTypeVideo) {
        [self addViewCount];    
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)initBaseData{
    if (!_newsBean.title) {
        NSLog(@"没有标题");
//        [NetWorking getVideoById:[NSString stringWithFormat:@"%@", _newsBean.newsId] andOption:^(NSArray *array) {
                [NetWorking getNewsById:[NSString stringWithFormat:@"%@", _newsBean.newsId] andOption:^(NSArray *array) {
            FTNewsBean *newsBean = [FTNewsBean new];
            [newsBean setValuesWithDic:[array firstObject]];
            NSLog(@"加载完成");
            _newsBean = newsBean;
        }];
    }
}

- (void)getVoteInfo{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _detailType == FTDetailTypeNews ? @"v-news" : @"v-video";
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
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _detailType == FTDetailTypeNews ? @"col-news" : @"col-video";//@"v-video";
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

- (void)setSubViews{
    
    [self setEvnetListenerOfBottomViews];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
    //        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(topShareButtonClicked)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    
    //设置默认标题
    self.navigationItem.title = _detailType == FTDetailTypeNews ? @"拳讯" : @"视频";
}

- (void)setEvnetListenerOfBottomViews{
    //设置点赞view的事件监听
    UITapGestureRecognizer *tapOfVoteView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbButtonClicked:)];
    [self.voteView addGestureRecognizer:tapOfVoteView];
    self.voteView.userInteractionEnabled = YES;
    
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
    
    //设置webview的背景色
    //    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    
    if(self.webUrlString == nil || self.webUrlString.length <= 0) {
        NSString *url = @"";
        if (_newsBean) {
                url = _newsBean.url;
        }else{
            
        }
        
        NSLog(@"视频url：%@", url);
        url = [self encodeToPercentEscapeString:url];
    //    _newsBean.viewCount = @"100";
        
        NSString *objId = @"";
        if (_urlId) {
            objId = _urlId;
        }else if(_newsBean){
            objId = _newsBean.newsId;
        }
        
        NSString *urlPrefix = _detailType == FTDetailTypeNews ? @"http://www.gogogofight.com/page/v2/news_page.html?objId=" : @"http://www.gogogofight.com/page/v2/video_page.html?objId=";
        _webViewUrlString = [NSString stringWithFormat:@"%@%@", urlPrefix, objId];
        NSLog(@"webview url：%@", _webViewUrlString);
        
    }else {
        
        _webViewUrlString = _webUrlString;
        NSLog(@"webview url：%@", _webViewUrlString);

    }
   
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popVC{
    
    [self.delegate updateCountWithVideoBean:_newsBean indexPath:self.indexPath];

    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma -mark 分享事件

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
    
    NSString *str = [NSString stringWithFormat:@"objId=%@",_newsBean.newsId];
    _webUrlString = [@"http://www.gogogofight.com/page/v2/news_page.html?" stringByAppendingString:str];
    
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:_webUrlString];
    [shareView setTitle:_newsBean.title];
    [shareView setSummary:_newsBean.summary];
    [shareView setImage:@"微信用@200"];
//    [shareView setImageUrl:@"http://www.gogogofight.com/page/images/wechat_share.jpg"];
    
    if ([_newsBean.layout isEqualToString:@"1"]) {//大图
        [shareView setImageUrl:_newsBean.img_big];
    }else if ([_newsBean.layout isEqualToString:@"2"]) {//图
        [shareView setImageUrl:_newsBean.img_small_one];
    }else if ([_newsBean.layout isEqualToString:@"3"]) {//3图
        [shareView setImageUrl:_newsBean.img_small_one];
    }
    
    [self.view addSubview:shareView];
    
}

#pragma -mark 设置loading图
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

#pragma -mark 点赞按钮被点击

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

#pragma -mark 收藏按钮被点击
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
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-赞pre"] forState:UIControlStateNormal];
        
    }else{
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-赞"] forState:UIControlStateNormal];
    }
}

- (void)updateStarImageView{
    if (self.hasStar) {
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-收藏pre"] forState:UIControlStateNormal];
        
    }else{
        [self.starButton setBackgroundImage:[UIImage imageNamed:@"详情页底部按钮一堆-收藏"] forState:UIControlStateNormal];
    }
}


//把点赞信息更新至服务器
- (void)uploadVoteStatusToServer{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _detailType == FTDetailTypeNews ? @"v-news" : @"v-video";
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

//把收藏信息更新至服务器
#pragma -mark 更新收藏信息至服务器
- (void)uploadStarStatusToServer{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:self.hasStar ? AddStarURL : DeleteStarURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _detailType == FTDetailTypeNews ? @"col-news" : @"col-video";
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
    }
    return YES;
}


#pragma mark -

- (IBAction)cancelShareButtonClicked:(id)sender {
    self.bgView.hidden = YES;
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
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
    if (_detailType == FTDetailTypeNews) {//拳讯
        FTNewsBean *newsBean = [FTNewsBean new];
        newsBean.newsId = _newsBean.newsId;
        commentVC.newsBean = newsBean;
    } else if (_detailType == FTDetailTypeVideo){//视频
        commentVC.newsBean = _newsBean;
    }
    
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)commentSuccess{
    int commentCount = [_newsBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", 1];
    NSLog(@"js method : %@", jsMethodString);
    _newsBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
}


/**
 *  增加视频的播放数
 */
- (void)addViewCount{
    //获取网络请求地址url
    NSString *addViewCountUrlString = [FTNetConfig host:Domain path:AddViewCountURL];

    NSString *newsId = _newsBean.newsId;
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

- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)showHUDWithMessage:(NSString *)message{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //        HUD = nil;
    }];
}



@end
