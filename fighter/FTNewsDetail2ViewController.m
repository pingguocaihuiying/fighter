//
//  TestViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewsDetail2ViewController.h"
#import "FTCommentViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "WXApi.h"
#import "Mobclick.h"

@interface FTNewsDetail2ViewController ()<UIWebViewDelegate, UMSocialUIDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}
@end

@implementation FTNewsDetail2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setWebView];
    [self getVoteInfo];
    [self setLoadingImageView];
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
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-news";
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

- (void)setSubViews{
    //给“我要评论”label增加监听事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commenButtonClicked:)];
    [self.commentLabel addGestureRecognizer:tap];
    self.commentLabel.userInteractionEnabled = YES;
    
    //扩大点赞的可点范围
    UITapGestureRecognizer *tapOfVoteView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbButtonClicked:)];
    [self.voteView addGestureRecognizer:tapOfVoteView];
    self.voteView.userInteractionEnabled = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
//    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
//        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
    self.navigationItem.rightBarButtonItem = shareButton;        
    }

    
    //设置默认标题
    self.navigationItem.title = @"拳讯";
}

- (void)setWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _webView.delegate = self;
    
    //设置webview的背景色
//    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    NSString *url = _newsBean.url;
    url = [self encodeToPercentEscapeString:url];
    NSString *title = _newsBean.title;
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _webViewUrlString = [NSString stringWithFormat:@"http://www.loufang.studio/page/news_page.html?objId=%@&title=%@&author=%@&newsTime=%@&commentCount=%@&voteCount=%@&url=%@&tableName=%@&type=%@", _newsBean.newsId, title, [_newsBean.author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _newsBean.newsTime, _newsBean.commentCount, _newsBean.voteCount,url , @"c-news", _newsBean.newsType];
    
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
    [self.delegate updateCountWithNewsBean:_newsBean indexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commenButtonClicked:(id)sender {
    [MobClick event:@"videoPage_DetailPage_Comment"];
        [MobClick event:@"newsPage_DetailPage_Comment"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        NSLog(@"微信登录");
        if ([WXApi isWXAppInstalled] ) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"fighter";
            [WXApi sendReq:req];
            
        }else{
            NSLog(@"目前只支持微信登录，请安装微信");
            [self showHUDWithMessage:@"目前只支持微信登录，请安装微信"];
        }
    }else{
        [self pushToCommentVC];
    }

}


- (void)shareButtonClicked{
    //友盟分享事件统计
    [MobClick event:@"newsPage_DetailPage_share"];
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
//    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
//        NSString *shareText = [NSString stringWithFormat:@"%@ %@", _newsBean.title, self.webViewUrlString];
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"570739d767e58edb5300057b"
//                                      shareText:shareText
//                                     shareImage:[UIImage imageNamed:@"AppIcon"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,nil]
//                                       delegate:self];
    /*
     *暂时采用微信的分享
     */
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _newsBean.title;
    message.description = _newsBean.summary;
    [message setThumbImage:[UIImage imageNamed:@"微信用@200"]];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = self.webViewUrlString;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
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
    _loadingBgImageView.center = self.view.center;
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
    [MobClick event:@"newsPage_DetailPage_Zambia"];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        NSLog(@"微信登录");
        if ([WXApi isWXAppInstalled] ) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"fighter";
            [WXApi sendReq:req];
            
        }else{
            NSLog(@"目前只支持微信登录，请安装微信");
            [self showHUDWithMessage:@"目前只支持微信登录点赞，请安装微信"];
        }
    }else{
        self.hasVote = !self.hasVote;
        [self updateVoteImageView];
        self.voteView.userInteractionEnabled = NO;
        [self uploadVoteStatusToServer];
    }
}

- (void)updateVoteImageView{
    if (self.hasVote) {
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
        
    }else{
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
}

//把点赞信息更新至服务器

- (void)uploadVoteStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _newsBean.newsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-news";
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
            int voteCount = [_newsBean.voteCount intValue];
            if (self.hasVote) {
                voteCount++;
            }else{
                if (voteCount > 0) {
                    voteCount--;
                }
            }
            _newsBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
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
    commentVC.newsBean = self.newsBean;
    [self.navigationController pushViewController:commentVC animated:YES];
}



- (void)commentSuccess{
    int commentCount = [_newsBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", commentCount];
    NSLog(@"js method : %@", jsMethodString);
    _newsBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
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
