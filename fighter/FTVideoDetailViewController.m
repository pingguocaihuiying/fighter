//
//  TestViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoDetailViewController.h"
#import "FTCommentViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "WXApi.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTPhotoPickerView.h"

@interface FTVideoDetailViewController ()<UIWebViewDelegate, UMSocialUIDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}
@end

@implementation FTVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    [self setWebView];
    [self getVoteInfo];
    [self getStarInfo];
    [self setLoadingImageView];
    [self addViewCount];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginResponse:) name:WXLoginResultNoti object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)getVoteInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _videoBean.videosId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-video";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasVote = YES;
        }else{
            self.hasVote = NO;
        }
        
        [self updateVoteImageView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
    }];
}

- (void)getStarInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _videoBean.videosId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"col-video";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasStar = YES;
        }else{
            self.hasStar = NO;
        }
        
        [self updateStarImageView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
    }];
}

- (void)setSubViews{
    //给“我要评论”label增加监听事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentButtonClicked:)];
    [self.commentLabel addGestureRecognizer:tap];
    self.commentLabel.userInteractionEnabled = YES;
    
    [self setEvnetListenerOfBottomViews];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
    //        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(topShareButtonClicked)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],UITextAttributeFont,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    
    //设置默认标题
    self.navigationItem.title = @"视频";
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
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _webView.delegate = self;
    
    //设置webview的背景色
    //    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    NSString *url = _videoBean.url;
    NSLog(@"视频url：%@", url);
    url = [self encodeToPercentEscapeString:url];
//    _videoBean.viewCount = @"100";
    NSString *title = _videoBean.title;
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _webViewUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/video_page.html?objId=%@&title=%@&author=%@&newsTime=%@&commentCount=%@&voteCount=%@&url=%@&tableName=%@&type=%@&videoLength=%@&viewCount=%@", _videoBean.videosId, title, [_videoBean.author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _videoBean.videosTime, _videoBean.commentCount, _videoBean.voteCount,url , @"c-video", _videoBean.videosType, _videoBean.videoLength,_videoBean.viewCount];
    NSLog(@"webview url：%@", _webViewUrlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];
}

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popVC{
    
    [self.delegate updateCountWithVideoBean:_videoBean indexPath:self.indexPath];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commentButtonClicked:(id)sender {
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
//        NSLog(@"微信登录");
//        if ([WXApi isWXAppInstalled] ) {
//            SendAuthReq *req = [[SendAuthReq alloc] init];
//            req.scope = @"snsapi_userinfo";
//            req.state = @"fighter";
//            [WXApi sendReq:req];
//            
//        }else{
//            NSLog(@"目前只支持微信登录，请安装微信");
//            [self showHUDWithMessage:@"目前只支持微信登录，请安装微信"];
//        }
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
    
    
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    //    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    //        NSString *shareText = [NSString stringWithFormat:@"%@ %@", _videoBean.title, self.webViewUrlString];
    //    [UMSocialSnsService presentSnsIconSheetView:self
    //                                         appKey:@"570739d767e58edb5300057b"
    //                                      shareText:shareText
    //                                     shareImage:[UIImage imageNamed:@"AppIcon"]
    //                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
    //                                       delegate:self];
    /*
     *暂时采用微信的分享
     */

    FTPhotoPickerView *pickerView = [FTPhotoPickerView new];
    pickerView.resultLabel.text = @"分享到";
    [pickerView.cameraBtn setImage:[UIImage imageNamed:@"分享-微信"] forState:UIControlStateNormal];
    [pickerView.cameraBtn setImage:[UIImage imageNamed:@"分享-微信pre"] forState:UIControlStateHighlighted];
    [pickerView.cameraBtn addTarget:self action:@selector(shareToWXSceneSession) forControlEvents:UIControlEventTouchUpInside];
    
    [pickerView.albumBtn setImage:[UIImage imageNamed:@"分享-朋友圈"] forState:UIControlStateNormal];
    [pickerView.albumBtn setImage:[UIImage imageNamed:@"分享-朋友圈pre"] forState:UIControlStateHighlighted];
    [pickerView.albumBtn addTarget:self action:@selector(shareToWXSceneTimeline) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pickerView];
    

}
- (void)shareToWXSceneSession{
    NSLog(@"WXSceneSession");
    [self shareToWXWithType:WXSceneSession];
}

- (void)shareToWXSceneTimeline{
    NSLog(@"WXSceneTimeline");
    [self shareToWXWithType:WXSceneTimeline];
    
}

- (void)shareToWXWithType:(int) scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _videoBean.title;
    message.description = _videoBean.summary;
    [message setThumbImage:[UIImage imageNamed:@"微信用@200"]];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = self.webViewUrlString;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma -mark 设置loading图
-(void)setLoadingImageView{
    //背景框imageview
    _loadingBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading背景"]];
    //    _loadingBgImageView.frame = CGRectMake(20, 100, 100, 100);
    _loadingBgImageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
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
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
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
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
//        NSLog(@"微信登录");
//        if ([WXApi isWXAppInstalled] ) {
//            SendAuthReq *req = [[SendAuthReq alloc] init];
//            req.scope = @"snsapi_userinfo";
//            req.state = @"fighter";
//            [WXApi sendReq:req];
//            
//        }else{
//            NSLog(@"目前只支持微信登录，请安装微信");
//            [self showHUDWithMessage:@"目前只支持微信登录点赞，请安装微信"];
//        }
    }else{
        self.hasStar = !self.hasStar;
//        [self updateVoteImageView];
        [self updateStarImageView];
        self.favourateView.userInteractionEnabled = NO;
//        [self uploadVoteStatusToServer];
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
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _videoBean.videosId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-video";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasVote ? AddVoteCheckKey: DeleteVoteCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        self.voteView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            int voteCount = [_videoBean.voteCount intValue];
            if (self.hasVote) {
                voteCount++;
            }else{
                if (voteCount > 0) {
                    voteCount--;
                }
            }
            _videoBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
            NSString *jsMethodString = [NSString stringWithFormat:@"updateLike(%d)", voteCount];
            NSLog(@"js method : %@", jsMethodString);
            [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
        self.voteView.userInteractionEnabled = YES;
        NSLog(@"vote failure ：%@", error);
    }];
    
}

//把收藏信息更新至服务器
#pragma -mark 更新收藏信息至服务器
- (void)uploadStarStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:self.hasStar ? AddStarURL : DeleteStarURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _videoBean.videosId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"col-video";
    NSString *query = @"delete-col";
//    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, self.hasStar ?  @"" : query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
        NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@&query=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName, query];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"收藏url：%@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收藏状态 status : %@, message : %@", responseDic[@"status"], responseDic[@"message"]);
        self.favourateView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
        self.voteView.userInteractionEnabled = YES;
        NSLog(@"收藏 failure ：%@", error);
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestURL = [NSString stringWithFormat:@"%@", request.URL];
    //    NSLog(@"requestURL : %@", requestURL);
    if ([requestURL isEqualToString:@"js-call:onload"]) {
        [self disableLoadingAnimation];
    }
    return YES;
}

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

- (void)wxLoginResponse:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        [self showHUDWithMessage:@"微信登录成功，可以评论或点赞了"];
    }else if ([msg isEqualToString:@"ERROR"]){
        [self showHUDWithMessage:@"微信登录失败"];
    }
}

- (void)pushToCommentVC{
    
    FTCommentViewController *commentVC = [ FTCommentViewController new];
    commentVC.delegate = self;
    commentVC.videoBean = self.videoBean;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)commentSuccess{
    int commentCount = [_videoBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", commentCount];
    NSLog(@"js method : %@", jsMethodString);
    _videoBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
}
/**
 *  增加视频的播放数
 */
- (void)addViewCount{
    //获取网络请求地址url
    NSString *addViewCountUrlString = [FTNetConfig host:Domain path:AddViewCountURL];

    NSString *videosId = _videoBean.videosId;
    NSString *ts = [NSString stringWithFormat:@"%.3f", [[NSDate date] timeIntervalSince1970]];
    ts = [ts stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", videosId, ts, UpVideoViewNCheckKey]];
    addViewCountUrlString = [NSString stringWithFormat:@"%@?&videosId=%@&ts=%@&checkSign=%@", addViewCountUrlString, videosId, ts, checkSign];
        NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    [manager GET:addViewCountUrlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        //
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
            int viewCount = [_videoBean.viewCount intValue];
            viewCount++;
            _videoBean.viewCount = [NSString stringWithFormat:@"%d", viewCount];
        }else{
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
        }
        
        [self updateVoteImageView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
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
