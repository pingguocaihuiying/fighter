//
//  TestViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaPostsDetailViewController.h"
#import "FTCommentViewController.h"

#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "WXApi.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTPhotoPickerView.h"
#import "FTShareView.h"
#import "FTHomepageMainViewController.h"
#import "FTWebViewRequestURLManager.h"//webView请求处理
#import "FTWebViewDetailBottomView.h"//底部view

@interface FTArenaPostsDetailViewController ()<UIWebViewDelegate, CommentSuccessDelegate, FTWebViewDetailBottomViewDelegate>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
}

@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;
@property (strong, nonatomic) IBOutlet UIView *bottomViewContainer;
@property (nonatomic, strong) FTWebViewDetailBottomView *bottomView;//底部的view
@end

@implementation FTArenaPostsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    [self getVoteInfo];
//    [self getStarInfo];//暂时没有收藏的需求
    [self setLoadingImageView];
    [self addViewCount];
    [self checkBean];
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

- (void)checkBean{
    if (_arenaBean) {//如果bean存在，则赋值给_objId
        _objId = _arenaBean.postsId;
        //更新评论数
        [self updateCommentCount];
        [self setWebView];
    }else{        //如果bean不存在，从服务器获取
        NSLog(@"没有newsbean或newsbean没有标题，正在从服务器获取...");
        [self getBeanFromServerById];
    }
}

- (void)getBeanFromServerById{
    [NetWorking getBoxingBarPostById:[NSString stringWithFormat:@"%@", _objId] andOption:^(NSDictionary *dic) {
        FTArenaBean *bean = [FTArenaBean new];
        [bean setValuesWithDic:dic];
        _arenaBean = bean;
        
        //更新评论数
        [self updateCommentCount];
        [self setWebView];
    }];
}

- (void)updateCommentCount{
    [_bottomView updateCommentCountWith:[_arenaBean.commentCount integerValue]];
}

- (void)getVoteInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _arenaBean.postsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-damageblog";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasVote = YES;
        }else{
            self.hasVote = NO;
        }
        
        [self updateVoteImageView];
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
    }];
}

- (void)getStarInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = _arenaBean.postsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"col-damageblog";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasStar = YES;
        }else{
            self.hasStar = NO;
        }
        
        [self updateStarImageView];
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
    }];
}

- (void)setSubViews{
    [self initBottomView];
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
    self.navigationItem.title = @"格斗场";
}

- (void)initBottomView{
    _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"FTWebViewDetailBottomView" owner:nil options:nil] firstObject];
    _bottomView.frame = _bottomViewContainer.bounds;
    [_bottomViewContainer addSubview:_bottomView];
    _bottomView.delegate = self;
}

- (void)setWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];//高度：屏幕高度 - 上方导航栏高度 - 底部view的高度
    _webView.delegate = self;
    
    //设置webview的背景色
    //    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    
    NSString *webViewUrlString;
        NSString *url = _arenaBean.videoUrlNames;
        NSLog(@"视频url：%@", url);
        url = [self encodeToPercentEscapeString:url];
        //    _videoBean.viewCount = @"100";
        
        webViewUrlString = [NSString stringWithFormat:@"%@?id=%@&type=%@&tableName=damageblog", BoxingBarWebViewURLString, _arenaBean.postsId, [_arenaBean.labels stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"webview url：%@", webViewUrlString);

    
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webViewUrlString]]];
    [self.view sendSubviewToBack:_webView];
}

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popVC{
    if ([_delegate respondsToSelector:@selector(updateCountWithArenaBean:indexPath:)]) {
        [self.delegate updateCountWithArenaBean:_arenaBean indexPath:self.indexPath];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentButtonClicked {
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        [self pushToCommentVCWithUserId:nil andUserName:nil];
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
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=%@",_arenaBean.postsId,@"damageblog"];
    NSString *webUrlString = [NSString stringWithFormat:@"%@?%@", BoxingBarWebViewURLString, str];
    FTShareView *shareView = [FTShareView new];
    
    [shareView setUrl:webUrlString];
    [shareView setTitle:_arenaBean.title];
    [shareView setImage:@"G格斗家logo改进@200"];
    
    if (_arenaBean.videoUrlNames && ![_arenaBean.videoUrlNames isEqualToString:@""]) {//如果有视频图片，优先显示视频图片
        NSLog(@"显示视频");
        NSString *firstVideoUrlString = [[_arenaBean.videoUrlNames componentsSeparatedByString:@","]firstObject];
        
        firstVideoUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstVideoUrlString];
        NSString *videoUrlString = [NSString stringWithFormat:@"%@/%@", _arenaBean.urlPrefix, firstVideoUrlString];
        if (![videoUrlString hasPrefix:@"http://"]) {
            videoUrlString = [NSString stringWithFormat:@"http://%@", videoUrlString];
        }
        
         [shareView setImageUrl:videoUrlString];
        NSLog(@"videoUrlString : %@", videoUrlString);
    }else if(_arenaBean.pictureUrlNames && ![_arenaBean.pictureUrlNames isEqualToString:@""]){//如果没有视频，再去找图片的缩略图
        NSLog(@"显示图片缩略图");
        NSString *firstImageUrlString = [[_arenaBean.pictureUrlNames componentsSeparatedByString:@","]firstObject];
        //        firstImageUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstImageUrlString];
        firstImageUrlString = [NSString stringWithFormat:@"%@?imageView2/2/w/200", firstImageUrlString];
        NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", _arenaBean.urlPrefix, firstImageUrlString];
        if (![imageUrlString hasPrefix:@"http://"]) {
            imageUrlString = [NSString stringWithFormat:@"http://%@", imageUrlString];
        }
        
        [shareView setImageUrl:imageUrlString];
    }else {
    
        [shareView setSummary:_arenaBean.content];
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
- (void)likeButtonClicked{
    [MobClick event:@"videoPage_DetailPage_Zambia"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasVote = !self.hasVote;
        [self updateVoteImageView];
//        self.voteView.userInteractionEnabled = NO;
        [self uploadVoteStatusToServer];
    }
}
#pragma -mark 收藏按钮被点击
    //功能已经完成，暂无需求
- (IBAction)favourateButtonClicked:(id)sender {
    [MobClick event:@"videoPage_DetailPage_Collection"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasStar = !self.hasStar;
        [self updateStarImageView];
//        self.favourateView.userInteractionEnabled = NO;
        [self uploadStarStatusToServer];
    }
}

- (void)updateVoteImageView{
    [_bottomView isLike:_hasVote];
}

- (void)updateStarImageView{
    if (self.hasStar) {
        NSLog(@"已经收藏");
    }else{
        NSLog(@"没有收藏");
    }
}

//把点赞信息更新至服务器

- (void)uploadVoteStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasVote ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = _arenaBean.postsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-damageblog";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasVote ? AddVoteCheckKey: DeleteVoteCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    NSLog(@"点赞url：%@", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            int voteCount = [_arenaBean.voteCount intValue];
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
            _arenaBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
            NSString *jsMethodString = [NSString stringWithFormat:@"updateLike(%@)", changeVoteCount];
            NSLog(@"js method : %@", jsMethodString);
            [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
        _bottomView.likeButton.enabled = YES;
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
    NSString *objId = _arenaBean.postsId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"col-damageblog";
    NSString *isDelated = @"0";
    NSString *query = @"delete-col";
    //    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", loginToken, objId, self.hasStar ?  @"" : query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", isDelated, loginToken, objId, query, tableName, ts, userId, self.hasStar ? AddStarCheckKey: DeleteStarCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@&isDelated=%@&query=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName, isDelated, query];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"收藏url：%@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收藏状态 status : %@, message : %@", responseDic[@"status"], responseDic[@"message"]);
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
        _bottomView.likeButton.enabled = YES;
        NSLog(@"收藏 failure ：%@", error);
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [FTWebViewRequestURLManager managerURLRequest:request withViewController:self];
    return YES;
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

- (void) loginCallBack:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self.view showMessage:@"微信登录成功，可以评论或点赞了"];
    }else if ([userInfo[@"result"]  isEqualToString:@"ERROR"]){
        [self.view showMessage:@"微信登录失败"];
    }
}

- (void)pushToCommentVCWithUserId:(NSString *)userId andUserName:(NSString *)userName{
    
    FTCommentViewController *commentVC = [ FTCommentViewController new];
    commentVC.delegate = self;
    commentVC.arenaBean = self.arenaBean;
    commentVC.userName = userName;
    commentVC.userId = userId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)commentSuccess{
    int commentCount = [_arenaBean.commentCount intValue];
    commentCount++;
    //评论成功后，参数传1
    NSString *jsMethodString = [NSString stringWithFormat:@"updateComment(1)"];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
    NSLog(@"js method : %@", jsMethodString);
    _arenaBean.commentCount = [NSString stringWithFormat:@"%d", commentCount];
    [self updateCommentCount];
    
}
/**
 *  增加视频的播放数
 */
- (void)addViewCount{
    //获取网络请求地址url
    NSString *addViewCountUrlString = [FTNetConfig host:Domain path:AddArenaViewCountCountURL];
    NSString *objId = _arenaBean.postsId;
    NSString *tableName = @"ve-damageblog";
    addViewCountUrlString = [NSString stringWithFormat:@"%@?&objId=%@&tableName=%@", addViewCountUrlString, objId, tableName];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    [manager GET:addViewCountUrlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
        //        NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        //
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
            int viewCount = [_arenaBean.viewCount intValue];
            viewCount++;
            _arenaBean.viewCount = [NSString stringWithFormat:@"%d", viewCount];
        }else{
            NSLog(@"%@, %@", responseDic[@"status"], responseDic[@"message"]);
        }
        
        [self updateVoteImageView];
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
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
