//
//  FTGymDetailWebViewController.m
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymDetailWebViewController.h"
#import "FTCommentViewController.h"
#import "MBProgressHUD.h"
#import "FTBaseNavigationViewController.h"
#import "FTLoginViewController.h"
#import "FTShareView.h"
#import "FTEncoderAndDecoder.h"
#import "NetWorking.h"

@interface FTGymDetailWebViewController ()<UIWebViewDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}

@property (nonatomic, copy)NSString *webUrlString;
@end

@implementation FTGymDetailWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationSytle];
    
    [self setSubViews];
    
    // 获取收藏信息
    [self getAttentionInfo];
    
}

- (void) dealloc {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化

// 设置导航栏
- (void) setNavigationSytle {
    
    //设置默认标题
    self.navigationItem.title = self.gymBean.gymName;
    
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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    
}

- (void)setSubViews{
    
    [self setWebView];
    
    [self setLoadingImageView];
}

// 设置webView
- (void)setWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    
    _webUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/m/hall.html?gymId=%@",self.gymBean.gymId];
    
    NSLog(@"webview url：%@", _webUrlString);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlString]]];
    [self.view sendSubviewToBack:_webView];
    
    [self startLoadingAnimation];
    
}


#pragma mark - bottom button response
// 关注按钮点击事件
- (IBAction)focusButtonAction:(id)sender {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasAttention = !self.hasAttention;
        [self updateAttentionButtonImg];
        self.focusView.userInteractionEnabled = NO;
        [self uploadStarStatusToServer];
    }
}

// 分享按钮点击事件
- (IBAction)shareButtonAction:(id)sender {
    [MobClick event:@"videoPage_DetailPage_shareUp"];
    
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-videos",_gymBean.gymId];
    _webUrlString = [@"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?" stringByAppendingString:str];
    
    NSString *imgStr = _gymBean.gymShowImg;
    NSString *urlStr = nil;
    if (imgStr && imgStr.length > 0) {
        NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
        urlStr = [NSString stringWithFormat:@"http://%@/%@",_gymBean.urlPrefix,[tempArray objectAtIndex:0]];
    }
    
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:_webUrlString];
    [shareView setTitle:_gymBean.gymName];
    [shareView setSummary:_gymBean.gymLocation];
    [shareView setImage:urlStr];
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
- (IBAction)dialButtonAction:(id)sender {
    
    
    NSString *urlStr = self.gymBean.gymTel;
    if (urlStr.length > 0) {
        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@""
                                                            message:urlStr
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打",nil];
        alertView.tag = 1000;
        [alertView show];
    }else {
    
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"当前拳馆没有预留号码~"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alerView show];
    }
    
}

- (void)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    commentVC.gymBean = self.gymBean;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - 服务器交互
//  获取用户是否关注
- (void)getAttentionInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _gymBean.gymId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"f-gym";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        if ([dict[@"message"] isEqualToString:@"true"]) {
            self.hasAttention = YES;
        }else{
            self.hasAttention = NO;
        }
        
        [self updateAttentionButtonImg];
    }];
}

//把点赞信息更新至服务器
- (void)uploadVoteStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = self.gymBean.gymId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-gym";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasVote ? AddVoteCheckKey: DeleteVoteCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        self.voteView.userInteractionEnabled = YES;
        if (dict) {
            NSLog(@"点赞状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
                if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
                    int voteCount = [self.gymBean.voteCount intValue];
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
                    self.gymBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
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
    NSString *urlString = [FTNetConfig host:Domain path:self.hasAttention ? AddFollowURL : DeleteFollowURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = self.gymBean.gymId;;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"f-gym";

    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@",loginToken, objId, tableName, ts, userId,self.hasAttention ? AddFollowCheckKey: CancelFollowCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    NSLog(@"收藏url：%@", urlString);
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        self.focusView.userInteractionEnabled = YES;
        if (dict) {
            NSLog(@"关注状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            }
        }
    }];
    
}

#pragma mark - webView response

- (void)updateAttentionButtonImg{
    
    if (self.hasAttention) {
        [self.focusButton setBackgroundImage:[UIImage imageNamed:@"关注pre"] forState:UIControlStateNormal];
        
    }else{
        [self.focusButton setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
    }
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
    
    if ([requestURL isEqualToString:@"js-call:onload"]) {
        
        [self disableLoadingAnimation];
    }
    return YES;
}

#pragma mark  CommentSuccessDelegate
- (void)commentSuccess{
    int commentCount = [self.gymBean.commentCount intValue];
    commentCount++;
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(%d)", 1];
    NSLog(@"js method : %@", jsMethodString);
    self.gymBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
}


#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000) {
        
        if (buttonIndex == 1) {
            
            NSString *urlStr = self.gymBean.gymTel;
            //获取目标号码字符串
            urlStr = [NSString stringWithFormat:@"tel://%@",urlStr];
            //转换成URL
            NSURL *url = [NSURL URLWithString:urlStr];
            //调用系统方法拨号
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark - loading动画

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



#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle


@end
