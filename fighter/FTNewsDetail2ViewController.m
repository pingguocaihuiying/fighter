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


@interface FTNewsDetail2ViewController ()<UIWebViewDelegate, UMSocialUIDelegate, CommentSuccessDelegate>
{
    UIWebView *_webView;
}
@end

@implementation FTNewsDetail2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setWebView];
    [self getVoteInfo];
    
}

- (void)viewWillAppear:(BOOL)animated{
        //
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToCommentVC) name:WXLoginResultNoti object:nil];
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
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-分享"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareButtonClicked)];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)commenButtonClicked:(id)sender {
    
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
            NSLog(@"微信没有安装");
        }
    }else{
        [self pushToCommentVC];
    }

}

- (void)shareButtonClicked{

    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
        NSString *shareText = [NSString stringWithFormat:@"%@ %@", _newsBean.title, self.webViewUrlString];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"570739d767e58edb5300057b"
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"AppIcon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
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

#pragma -mark 点赞按钮被点击

- (IBAction)thumbButtonClicked:(id)sender {
    self.hasVote = !self.hasVote;
    [self updateVoteImageView];
    if (self.hasVote) {
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
    }else{
        [self.thumbsUpButton setBackgroundImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
    self.voteView.userInteractionEnabled = NO;
    [self uploadVoteStatusToServer];
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
                voteCount--;
            }
            _newsBean.voteCount = [NSString stringWithFormat:@"%d", voteCount];
            NSString *jsMethodString = [NSString stringWithFormat:@"updateLike(%d)", voteCount];
            NSLog(@"js method : %@", jsMethodString);
            [_webView stringByEvaluatingJavaScriptFromString:jsMethodString];
            
        }
        
        //success
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //failure
        self.voteView.userInteractionEnabled = YES;
        NSLog(@"vote failure.");
    }];
    //设置请求返回的数据类型为默认类型（NSData类型)
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

@end
