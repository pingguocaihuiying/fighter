//
//  FTTeachVideoDetailController.m
//  fighter
//
//  Created by kang on 16/7/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTeachVideoDetailController.h"
#import "FTCommentViewController.h"
#import "MBProgressHUD.h"
#import "FTBaseNavigationViewController.h"
#import "FTLoginViewController.h"
#import "FTShareView2.h"
#import "FTHomepageMainViewController.h"
#import "FTEncoderAndDecoder.h"
#import "NetWorking.h"

@interface FTTeachVideoDetailController ()<UIWebViewDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}
@end

@implementation FTTeachVideoDetailController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationSytle];
    
    [self setSubViews];
    
    // 更新播放次数
    [self addViewCount];
    // 获取点赞信息
    [self getVoteInfo];
    // 获取收藏信息
    [self getStarInfo];
    
    [self setNai];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - set subViews 

// 监听通知
- (void) setNai {

    // 注册通知，分享到微信成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callbackShareToWeiXin:) name:WXShareResultNoti object:nil];
    
    // 注册通知，分享到qq成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callbackShareToQQ:) name:QQShareResultNoti object:nil];
}

// 设置导航栏
- (void) setNavigationSytle {
    
    //设置默认标题
    self.navigationItem.title = @"视频";
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // 导航栏转发按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    
}

- (void)setSubViews{
    
    [self setWebView];
    
}

// 设置webView
- (void)setWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    
    
    if(self.webUrlString == nil || self.webUrlString.length <= 0) {
        NSString *url = @"";
        if (_videoBean) {
            url = _videoBean.url;
        }else{
            
        }
        
        NSLog(@"视频url：%@", url);
        
        // url encode
        url = [FTEncoderAndDecoder encodeToPercentEscapeString:url];
        NSString *title = _videoBean.title;
        NSString *objId = @"";
        
        if (_urlId) {
            objId = _urlId;
        }else if(_videoBean){
            objId = _videoBean.videosId;
        }
        title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        _webViewUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/v2/video_paid_page.html?objId=%@", objId];
    }else {
        _webViewUrlString = _webUrlString;
    }
    NSLog(@"webview url：%@", _webViewUrlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];

}

#pragma mark - bottom button response
// 收藏按钮点击事件
- (IBAction)startButtonAction:(id)sender {
    
    [MobClick event:@"videoPage_DetailPage_Collection"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasStar = !self.hasStar;
        [self updateStarImageView];
        self.favourateView.userInteractionEnabled = NO;
        [self uploadStarStatusToServer];
    }
}

// 分享按钮点击事件
- (IBAction)shareButtonAction:(id)sender {
    [MobClick event:@"videoPage_DetailPage_shareUp"];

    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-videos",_videoBean.videosId];
    _webUrlString = [@"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?" stringByAppendingString:str];
    
    FTShareView2 *shareView = [FTShareView2 new];
    [shareView setUrl:_webUrlString];
    [shareView setTitle:_videoBean.title];
    [shareView setSummary:_videoBean.summary];
    [shareView setImage:@"微信用@200"];
    [shareView setImageUrl:_videoBean.img];
    [self.view addSubview:shareView];
}


// 评论按钮点击事件
- (IBAction)commentButtonAction:(id)sender {
    
    [MobClick event:@"videoPage_DetailPage_Comment"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (!localUser) {
        [self login];
    }else{
        [self pushToCommentVC];
    }
    
}

// 点赞按钮点击事件
- (IBAction)thumbsUpButtonAction:(id)sender {
    
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

- (void)backBtnAction:(id)sender {
    
    [self.delegate updateCountWithVideoBean:_videoBean indexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - delegate
#pragma mark  webView delegate

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self disableLoadingAnimation];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@", request.URL];
    NSLog(@"requestURL : %@", requestURL);
    
    if ([requestURL isEqualToString:@"js-call:setVideoUrl"]) {//付费视频传url
        [self setWebViewUrl];
        
    }else if ([requestURL isEqualToString:@"js-call:onload"]) {
        
        [self disableLoadingAnimation];
    }else if ([requestURL hasPrefix:@"js-call:userId="]) {
        
        NSString *userId = [requestURL stringByReplacingOccurrencesOfString:@"js-call:userId=" withString:@""];
        FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
        homepageMainVC.olduserid = userId;
        [self.navigationController pushViewController:homepageMainVC animated:YES];
    }
    return YES;
}


#pragma mark  CommentSuccessDelegate
- (void)commentSuccess{
    int commentCount = [_videoBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", 1];
    NSLog(@"js method : %@", jsMethodString);
    _videoBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
}


#pragma mark - webView 交互

// 把付费视频url地址传给webView
- (void) setWebViewUrl {
    
//    NSString *url = [FTEncoderAndDecoder encodeToPercentEscapeString:_videoBean.url];
    NSString *url = _videoBean.url;
    NSString *jsMethodString = [NSString stringWithFormat:@"setVideoUrl('%@')",url];
    NSLog(@"js method : %@", jsMethodString);
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
}


#pragma mark - webView response
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


#pragma - mark loading动画

-(void)setLoadingImageView{
    
    //背景框imageview
    _loadingBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading背景"]];
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



#pragma mark - private method

// 跳转登录界面方法
- (void)login{
    
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 跳转评论页面
- (void)pushToCommentVC{
    
    FTCommentViewController *commentVC = [ FTCommentViewController new];
    commentVC.delegate = self;
    commentVC.videoBean = self.videoBean;
    [self.navigationController pushViewController:commentVC animated:YES];
}


#pragma mark - 服务器交互
//  获取用户是否点赞该视频
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
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
    
        if ([dict[@"message"] isEqualToString:@"true"]) {
            self.hasVote = YES;
        }else{
            self.hasVote = NO;
        }
        
        [self updateVoteImageView];
    }];
    
}


//  获取用户是否收藏该视频
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
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        if ([dict[@"message"] isEqualToString:@"true"]) {
            self.hasStar = YES;
        }else{
            self.hasStar = NO;
        }
        
        [self updateStarImageView];
    }];
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
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        self.voteView.userInteractionEnabled = YES;
        if (dict) {
            NSLog(@"点赞状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
                if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
                    int voteCount = [_videoBean.voteCount intValue];
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
                    _videoBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
                    NSString *jsMethodString = [NSString stringWithFormat:@"updateLike(%@)", changeVoteCount];
                    NSLog(@"js method : %@", jsMethodString);
                    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
                }

            }
        }
    }];
}

//把收藏信息更新至服务器
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
    
    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@&query=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName, query];
    
    NSLog(@"收藏url：%@", urlString);
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
       
        self.favourateView.userInteractionEnabled = YES;
        if (dict) {
            NSLog(@"收藏状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            }
        }
    }];
    
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
    
    [NetWorking getRequestWithUrl:addViewCountUrlString parameters:nil option:^(NSDictionary *dict) {
        
        if (dict) {
            
            if ([dict[@"status"] isEqualToString:@"success"]) {
                
                int viewCount = [_videoBean.viewCount intValue];
                viewCount++;
                _videoBean.viewCount = [NSString stringWithFormat:@"%d", viewCount];
            }else{
                NSLog(@"%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            }
            [self updateVoteImageView];
        }
    }];
    
}

#pragma mark - 分享回调
// qq 分享回调
- (void) callbackShareToQQ:(NSNotification *)noti {
    
    [self getPointByShareToPlatform:@"kongjian"];
}

// weixin 分享回调
- (void) callbackShareToWeiXin:(NSNotification *)noti {
    
    [self getPointByShareToPlatform:@"weixin"];
}

// 获取分享积分
- (void) getPointByShareToPlatform:(NSString *)platform {
    
    NSLog(@"%@分享赠送积分成功调用",platform);
    [NetWorking getPointByShareWithPlatform:platform option:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if ([dict[@"status"] isEqualToString:@"success"]) {
            
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"成功获得1P积分"];
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}


@end
