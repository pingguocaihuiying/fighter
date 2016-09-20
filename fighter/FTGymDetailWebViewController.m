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
#import "FTPayForGymVIPViewController.h"
#import "FTGymVIPCollectionViewCell.h"
#import "FTGymPhotosViewController.h"
#import "FTGymCommentViewController.h"
#import "FTGymDetailBean.h"

@interface FTGymDetailWebViewController ()<UIWebViewDelegate, CommentSuccessDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIWebView *_webView;
    UIImageView *_loadingImageView;
    UIImageView *_loadingBgImageView;
    
}

@property (nonatomic, copy)NSString *webUrlString;
@property (strong, nonatomic) IBOutlet UILabel *gymAdressLabel;//地址label
@property (strong, nonatomic) IBOutlet UIView *addressSeperatorView;//地址view中右边的分割线

//顶部和底部的分割线
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;
@property (strong, nonatomic) IBOutlet UIView *seperatorView4;
@property (strong, nonatomic) IBOutlet UIView *seperatorView5;
@property (strong, nonatomic) IBOutlet UIView *seperatorView6;

//评分view
@property (strong, nonatomic) IBOutlet UIView *scoreView;


//展示拳手的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

//collectionView左右离父视图的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewPaddingLeft;//左
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewPaddingRight;//右
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionContainerViewHeight;

@property (strong, nonatomic) IBOutlet UIImageView *gymShowImageView;
@property (strong, nonatomic) IBOutlet UIView *haveVideoView;
@property (strong, nonatomic) IBOutlet UIButton *haveVideoButton;

@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoAndImageCountLabel;


@property (nonatomic, assign) BOOL displayAllVIP;//是否展示所有会员

@property (nonatomic, strong) NSMutableArray *vipArray;

@property (nonatomic, strong) FTGymDetailBean *gymDetailBean;//拳馆详情bean

@end

@implementation FTGymDetailWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self loadGymDataFromServer];
    [self setNavigationSytle];
//
    [self setSubViews];
//
    // 获取收藏信息
    [self getAttentionInfo];
    
}

- (void)initBaseData{
    _vipArray = [NSMutableArray new];
//    for (int i = 0; i < 13; i++) {
//        NSString *name = [NSString stringWithFormat:@"李森%d", i];
//        NSDictionary *vipDic = @{@"image": @"详情页底部按钮一堆-赞pre", @"name": name};
//        [_vipArray addObject:vipDic];
//    }
}

- (void)loadGymDataFromServer{
    //获取拳馆的一些基本信息：视频、照片、地址等
    [NetWorking getGymForGymDetailWithGymId:_gymBean.gymId andOption:^(NSDictionary *dic) {
        NSLog(@"dic : %@", dic);
        _gymDetailBean = [FTGymDetailBean new];
//        [_gymDetailBean setValuesWithDic:dic];
        [_gymDetailBean setValuesForKeysWithDictionary:dic];
        [self updateGymBaseInfo];
    }];
    
    //获取拳馆的教练列表
    [NetWorking getCoachesWithCorporationid:_gymBean.corporationid andOption:^(NSArray *array) {
        _vipArray = [NSMutableArray arrayWithArray:array];
        NSDictionary *dic = [_vipArray firstObject];
        NSLog(@"%@", dic[@"headUrl"]);
        for(NSString *key in [dic allKeys]){
            NSLog(@"key %@ : %@", key, dic[key]);
        }
        [_collectionView reloadData];
    }];
}

- (void)updateGymBaseInfo{
    //如果视频个数为0，隐藏上方视频标识
    if (_gymDetailBean.videoCount == 0) {
        _haveVideoView.hidden = YES;
        _haveVideoButton.hidden = YES;
        
    }else{
        _haveVideoView.hidden = NO;
        _haveVideoButton.hidden = NO;
    }
    
    //更新展示照片
    NSString *imageUrl = [NSString stringWithFormat:@"http://%@/%@", _gymDetailBean.urlprefix, _gymDetailBean.gym_show_img];
    [_gymShowImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    //更新照片、视频个数
    _videoAndImageCountLabel.text = [NSString stringWithFormat:@"%d个视频 %d张照片", _gymDetailBean.videoCount, _gymDetailBean.pictureCount];
    
    //更新评价星级
    [FTTools updateScoreView:_scoreView withScore:_gymDetailBean.grade];
    
    //更新地址
    _gymAdressLabel.text = _gymDetailBean.gym_location;
}

- (void) dealloc {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
//    [self setWebView];
    
//    [self setLoadingImageView];
    [self subViewFormat];//设置分割线颜色、label行间距等
    [self setCollectionView];//设置拳馆教练头像显示
    
}

- (void)subViewFormat{
    //分割线的颜色
    _addressSeperatorView.backgroundColor = Cell_Space_Color;
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
    _seperatorView4.backgroundColor = Cell_Space_Color;
    _seperatorView5.backgroundColor = Cell_Space_Color;
    _seperatorView6.backgroundColor = Cell_Space_Color;
    
    _gymAdressLabel.text = @"东直门东直门东直门东直门东直门东直门东直门东直门";
    [UILabel setRowGapOfLabel:_gymAdressLabel withValue:6];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_vipArray.count > 6 && _displayAllVIP) {
        if (indexPath.row == _vipArray.count) {
            _displayAllVIP = !_displayAllVIP;
            [self updateCollectionView];
            NSLog(@"收起");
        } else {
            NSDictionary *vipDic = _vipArray[indexPath.row];
            NSLog(@"vipName : %@", vipDic[@"name"]);
        }
    } else {
        if (_vipArray.count > 6 && indexPath.row == 5) {
            _displayAllVIP = !_displayAllVIP;
            [self updateCollectionView];
            NSLog(@"展开");
        } else {
            NSDictionary *vipDic = _vipArray[indexPath.row];
            NSLog(@"vipName : %@", vipDic[@"name"]);
        }
    }
}

- (void)setCollectionView{
    
    //创建flowLayout
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 15;//最小行间距
    flowLayout.minimumInteritemSpacing = 20;//最小列间距
    flowLayout.itemSize = CGSizeMake(40, 60);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.collectionViewLayout = flowLayout;
    
    //针对6以下进行适配
    if (SCREEN_WIDTH == 320) {
        NSLog(@"苹果6以下");
        _collectionViewPaddingLeft.constant *= SCALE;
        _collectionViewPaddingRight.constant *= SCALE;
        
        flowLayout.minimumLineSpacing = 15 * SCALE;//最小行间距
        flowLayout.minimumInteritemSpacing = 20 * SCALE;//最小列间距
        flowLayout.itemSize = CGSizeMake(40 * SCALE, 60 * SCALE);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.collectionViewLayout = flowLayout;
    }
    
    _collectionView.scrollEnabled = NO;//禁止滚动
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //加载cell用于复用

    [_collectionView registerNib:[UINib nibWithNibName:@"FTGymVIPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self updateCollectionView];
    
}

- (void)updateCollectionView{
    
    if (_vipArray.count > 6  && _displayAllVIP) {
        NSInteger line;
        if ((_vipArray.count + 1) % 6 == 0) {//如果刚好被整出
                line = (_vipArray.count + 1) / 6;//行数
        }else{//如果没有被整出
            line = (_vipArray.count + 1) / 6 + 1;//行数
        }
        
        NSLog(@"line : %ld", (long)line);
        
        
        if (SCREEN_WIDTH == 320) {
            NSLog(@"SCREEN_WIDTH == 320");
            _collectionContainerViewHeight.constant = 30 + 60 * line * SCALE + 15 * (line - 1) * SCALE;
        }else{
            _collectionContainerViewHeight.constant = 30 + 60 * line + 15 * (line - 1);
        }
        
        
    } else {
        
        if (SCREEN_WIDTH == 320) {
            NSLog(@"SCREEN_WIDTH == 320");
            _collectionContainerViewHeight.constant = 30 + 60 * SCALE;
        }else{
            _collectionContainerViewHeight.constant = 90;
        }
    }
    [_collectionView reloadData];
}

//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//某组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_vipArray) {
        if(_vipArray.count > 6){
            //如果源数据vip数量大于6，需要分行显示，则显示『更多』、『收起』项
            return _vipArray.count + 1;
        }else{
            return _vipArray.count;
        }
    }else{
        return 0;
    }
}

//返回collectionView cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTGymVIPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    if (_displayAllVIP) {
        if (_vipArray.count > 6 && indexPath.row == _vipArray.count) {//『收起』
            cell.headerImageView.image = [UIImage imageNamed:@"学员列表-收起"];
            cell.vipNameLabel.text = @"收起";
        }else{
            NSDictionary *vipDic = _vipArray[indexPath.row];
//            cell.headerImageView.image = [UIImage imageNamed:vipDic[@"image"]];
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:vipDic[@"headUrl"]]];
            cell.vipNameLabel.text = vipDic[@"name"];
        }
        
    } else {
        if (_vipArray.count > 6 && indexPath.row == 5) {
            cell.headerImageView.image = [UIImage imageNamed:@"学员列表-更多"];
            cell.vipNameLabel.text = @"更多";
        }else{
            NSDictionary *vipDic = _vipArray[indexPath.row];
            cell.headerImageView.image = [UIImage imageNamed:vipDic[@"image"]];
            cell.vipNameLabel.text = vipDic[@"name"];
        }
    }

    
    return cell;
}

// 设置webView
- (void)setWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
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

#pragma -mark - 点击头部图片
- (IBAction)topImageClicked:(id)sender {
    NSLog(@"进入图集");
    FTGymPhotosViewController *photoViewController = [FTGymPhotosViewController new];
    photoViewController.gymDetailBean = _gymDetailBean;
    [self.navigationController pushViewController:photoViewController animated:YES];
}

// 分享按钮点击事件
- (IBAction)shareButtonAction:(id)sender {
    [MobClick event:@"videoPage_DetailPage_shareUp"];
    
    NSString *str = [NSString stringWithFormat:@"gymId=%@",_gymBean.gymId];
    _webUrlString = [@"http://www.gogogofight.com/m/hall.html?" stringByAppendingString:str];
    
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
    [shareView setImageUrl:urlStr];
    
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
- (IBAction)becomeVIPButtonClicked:(id)sender {
    NSLog(@"成为会员");
    FTPayForGymVIPViewController *payForGymVIPViewController = [[FTPayForGymVIPViewController alloc]init];
    
    [self.navigationController pushViewController:payForGymVIPViewController animated:YES];
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
    
//    FTCommentViewController *commentVC = [ FTCommentViewController new];
//    commentVC.delegate = self;
//    commentVC.gymBean = self.gymBean;
//    [self.navigationController pushViewController:commentVC animated:YES];
    
    FTGymCommentViewController *commentVC = [ FTGymCommentViewController new];
//    commentVC.delegate = self;
//    commentVC.gymBean = self.gymBean;
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

- (IBAction)viewMoreCommentButtonClicked:(id)sender {
    NSLog(@"查看更多评论");
}


#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle

#pragma mark life cycle


@end
