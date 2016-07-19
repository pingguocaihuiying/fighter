//
//  FTTeachVideoController.m
//  fighter
//
//  Created by kang on 16/6/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTeachVideoController.h"
#import "FTVideoCollectionViewCell.h"
//#import "FTVideoDetailViewController.h"
#import "FTTeachVideoDetailController.h"
#import "FTLoginViewController.h"

#import "RBRequestOperationManager.h"
#import "FTNetConfig.h"
#import "ZJModelTool.h"

#import "JHRefresh.h"
#import "FTVideoBean.h"
#import "UIButton+LYZTitle.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTLYZButton.h"
#import "DBManager.h"
#import "NetWorking.h"
#import "FTButton.h"
#import "FTRankTableView.h"
#import "FTTeachVideoCell.h"
#import "Base64-umbrella.h"
#import "FTPayViewController.h"
#import "FTBaseNavigationViewController.h"
#import "AESCrypt.h"
#import "FTEncoderAndDecoder.h"
#import "FTRechargeView.h"


#import "UMSocial.h"
#import "WXApi.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/sdkdef.h>

@interface FTTeachVideoController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FTVideoDetailDelegate,FTSelectCellDelegate, UIAlertViewDelegate> {

    NSIndexPath *currentIndexPath;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark 充值弹出框
@property (weak, nonatomic) IBOutlet UIView *dialogView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareWXBtn;

@property (weak, nonatomic) IBOutlet UIButton *shareQQBtn;

@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic)  NSMutableArray *array;
@property (nonatomic, copy)NSString *videosTag;
@property (nonatomic, copy)NSString *buyToken;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, strong)FTVideoBean *currentBean;
@property (nonatomic, assign)NSInteger balance;


@end

@implementation FTTeachVideoController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    self.videosTag = @"1";//默认按时间排序
    [self initSubviews];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//第一次加载数据
    
    [self setNai];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
// 监听通知
- (void) setNai {
    
    // 注册通知，分享到微信成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callbackShareToWeiXin:) name:WXShareResultNoti object:nil];
    
    // 注册通知，分享到qq成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callbackShareToQQ:) name:QQShareResultNoti object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBalance:) name:@"RechargeOrCharge" object:nil];
    
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAction:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAction:) name:@"loginAction" object:nil];
    
}


//设置导航栏
- (void) setNavi {
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
//    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    // 教练地址筛选按钮
    FTButton *rightBtn = [FTButton buttonWithtitle:@"按时间"];
    rightBtn.frame = CGRectMake(20, 0, 95, 40);
    [rightBtn addTarget:self action:@selector(rightBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //把左边的返回按钮左移
    [ self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
}

- (void) initSubviews {
    
    
    [self initCollectionView];
    
    [self initDialogView];
}


- (void) initDialogView {

    [self.dialogView setBackgroundColor:[UIColor colorWithHex:0x191919 alpha:0.5]];
    self.dialogView.opaque = NO;
    
    
    // 获取余额
    [self fetchBalanceFromWeb];
    
    _currentBean = [FTVideoBean new];
    
}

#pragma -mark - 初始化collectionView
- (void)initCollectionView{
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FTTeachVideoCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    
    [self setJHRefresh];
}


- (void)setJHRefresh{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header setHidden:NO];
        [weakSelf getDataWithGetType:@"new" andCurrId:@"-1"];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 显示footer
        weakSelf.collectionView.mj_footer.hidden = NO;
        
        NSString *currId;
        if (weakSelf.array && weakSelf.array.count > 0) {
            currId = [weakSelf.array lastObject][@"videosId"];
            //如果当前是按“最热”来，需要找到最小的id座位current id
            if ([self.videosTag isEqualToString:@"0"]) {
                
                int minId = [currId intValue];
                for (NSDictionary *dic in weakSelf.array) {
                    
                    int videoId = [dic[@"videosId"] intValue];
                    if (videoId < minId) {
                        minId = videoId;
                    }
                }
                
                currId = [NSString stringWithFormat:@"%d", minId];
            }
            
        }else{
            return;
        }
        [weakSelf getDataWithGetType:@"old" andCurrId:currId];
    }];
    // 显示footer
//    self.collectionView.mj_footer.hidden = NO;
    
}


- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)videoCurrId{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoURL];
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",_videoType, videoCurrId, self.videosTag, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@&otherkey=teach", urlString, _videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], self.videosTag];

    NSLog(@"urlString:%@",urlString);
    NetWorking *net = [[NetWorking alloc]init];
    [net getVideos:urlString option:^(NSDictionary *responseDic) {
        
        NSLog(@"responseDic:%@",responseDic);
        NSLog(@"message:%@",[responseDic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                //                NSLog(@"data:%@",responseDic[@"data"]);
                
                if ([getType isEqualToString:@"new"]) {
                    self.array = mutableArray;
                }else if([getType isEqualToString:@"old"]){
                    [self.array addObjectsFromArray:mutableArray];
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];

                
            }else {
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];

            }
            
        }else {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
        }
    }];

    
}



#pragma mark - delegates 

#pragma mark alert 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1002) {
        
        if (buttonIndex == 0) {
            
            
            NSDictionary *newsDic = self.array[currentIndexPath.row];
            FTVideoBean *bean = [FTVideoBean new];
            [bean setValuesWithDic:newsDic];
            
            // 3.购买视频
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NetWorking buyVideoById:bean.videosId option:^(NSDictionary *dict) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (dict == nil) {
                    
                    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"网络故障，请稍后再试~"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alerView show];
                    
                    return;
                }
                
                NSLog(@"dict:%@",dict);
                NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                
                if ([dict[@"status"] isEqualToString:@"success"]) {
                    
                    _buyToken = dict[@"data"][@"buyToken"];
                    
                    if (_buyToken.length <= 0) {
                        return;
                    }
                    
                    // 发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeOrCharge" object:@"CHARGE"];
                    
                    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"购买成功，现在可以去学习啦~"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alerView show];
                    
                    // 2. 获取视频url
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [NetWorking getVideoUrlById:bean.videosId
                                       buyToken:_buyToken
                                         option:^(NSDictionary *urlDict) {
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             NSLog(@"urlDict:%@",urlDict);
                                             NSLog(@"message:%@",[urlDict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                                            
                                             
                                             if ([urlDict[@"status"] isEqualToString:@"success"]){
                                                 
                                                 // 解密url
                                                 NSString *base64String = urlDict[@"data"][@"url"];
                                                 NSData *data = [NSData dataWithBase64String:base64String];
                                                 _videoUrl = [FTEncoderAndDecoder decryptAESData:data app_key:@"gedoudongxi12345"];
                                                 bean.url = _videoUrl;
                                                 
                                                 if (_videoUrl.length > 0) {
                                                     // 跳转到播放页
                                                     [self pushToDetailVC:bean indexPath:currentIndexPath];
                                                 }
                                             }
                                         }];
                    
                }else {
                    
                    NSLog(@"message:%@",[dict[@"message"]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                    
                    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"购买视频失败，请稍后再试~"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil];
                    [alerView show];
                    
//                    // 积分不足，充值
//                    if ([dict[@"message"] isEqualToString:@"积分不足"]) {
//                       
//                        [self.dialogView setHidden:NO];
//                        
//                        
//                        
//                    }else {
//                        
//                        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
//                                                                            message:@"购买视频失败，请稍后再试~"
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"知道了"
//                                                                  otherButtonTitles:nil];
//                        [alerView show];
//                        
//                    }
                    
                }
            }];
        }
    
    }else if(alertView.tag == 1000+3) {
        
        if (buttonIndex == 1) {
            // 跳转到登录页面
            [self login];
        }
    }
}

#pragma mark collection
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *newsDic = self.array[indexPath.row];
    [_currentBean clear];
    [_currentBean setValuesWithDic:newsDic];
    
    /****   test   *****/
//    [self.dialogView setHidden:NO];
    
    
    currentIndexPath = indexPath;
    
    // 首先检查是否是免费视频
    if ([_currentBean.price isEqualToString:@"0"]) {
    
        if (_currentBean.url.length > 0) {
            // 跳转到播放页
            [self pushToDetailVC:_currentBean indexPath:indexPath];
            
        }
        return;
    }
    
    // 检查登录
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    
    if (localUserData == nil ) {
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"还没有登录哟，付费视频只有登录之后才能观看，赶紧去登录吧~"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录",nil];
        
        alerView.tag = 1000+3;
        [alerView show];
        
        return;
    }

    
    // 1. 检查是否购买了视频
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking checkBuyVideoById:_currentBean.videosId option:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (dict == nil) {
            
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"网络故障，请稍后再试~"
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alerView show];
            
            return;
        }
        
        NSLog(@"dict:%@",dict);
        NSLog(@"massage:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if ([dict[@"status"] isEqualToString:@"success"]) {
            _buyToken = dict[@"data"][@"buyToken"];
            if (_buyToken.length > 0) {
                
                
                // 2. 如果视频已经购买，直接获取视频url
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [NetWorking getVideoUrlById:_currentBean.videosId
                                   buyToken:_buyToken
                                     option:^(NSDictionary *urlDict) {
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         if (urlDict == nil) {
                                             
                                             UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                                                 message:@"网络故障，请稍后再试~"
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:@"知道了"
                                                                                       otherButtonTitles:nil];
                                             [alerView show];
                                             
                                             return;
                                         }
                                         
                                         NSLog(@"urlDict:%@",urlDict);
                                         NSLog(@"massage:%@",[urlDict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                
                                         if ([urlDict[@"status"] isEqualToString:@"success"]){
                                             
                                             // 解密url
                                             NSString *base64String = urlDict[@"data"][@"url"];
                                             NSData *data = [NSData dataWithBase64String:base64String];
                                             _videoUrl = [FTEncoderAndDecoder decryptAESData:data app_key:@"gedoudongxi12345"];
                                             _currentBean.url = _videoUrl;
                                             
                                             if (_videoUrl.length > 0) {
                                                 // 跳转到播放页
                                                 [self pushToDetailVC:_currentBean indexPath:indexPath];
                                                 
                                             }
                                         }
                }];
            }
        }else {
            // 检查余额是否足够购买视频
            if (_balance < [_currentBean.price integerValue]) {
                
                [self.dialogView setHidden:NO];
            
                return;
            }
            
            //3. 如果视频没有购买，则先购买视频在获取url观看
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"购买视频"
                                                                message:[NSString stringWithFormat:@"播放当前视频需要支付%@P，确定播放视频么？",_currentBean.price]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:@"取消",nil];
            alerView.tag = 1000 + 2;
            [alerView show];
        }
    }];
    
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTTeachVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTeachVideoCell" owner:self options:nil]firstObject];
    }
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = self.array[indexPath.row];
    FTVideoBean *bean = [FTVideoBean new];
    [bean setValuesWithDic:newsDic];
    
//    FTVideoBean *bean = self.array[indexPath.row];
    [cell setWithBean:bean];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = 164 * SCALE;
    float height = 143 * SCALE;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15* SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16 * SCALE;;
}

#pragma mark FTVideoDetailDelegate
- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.array[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.viewCount] forKey:@"viewCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.commentCount] forKey:@"commentCount"];
    //    NSLog(@"indexPath.row : %ld", indexPath.row);
    self.array[indexPath.row] = dic;
    //    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

#pragma mark FTSelectCellDelegate 

- (void) selectedValue:(NSDictionary *)dic {

    self.videosTag = dic[@"itemValueEn"];
    
    [self getDataWithGetType:@"new" andCurrId:@"-1"];
}

- (void) selectedValue:(NSString *)value style:(FTRankTableViewStyle) style {

    self.videosTag = value;
    
   [self getDataWithGetType:@"new" andCurrId:@"-1"];
}

#pragma mark - 登录
// 跳转登录界面方法
- (void)login {
    
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 跳转详情页
-  (void) pushToDetailVC:(FTVideoBean *) bean indexPath:(NSIndexPath *) indexPath {
    
    FTTeachVideoDetailController *videoDetailVC = [FTTeachVideoDetailController new];
    videoDetailVC.videoBean = bean;
    videoDetailVC.indexPath = indexPath;
    videoDetailVC.delegate = self;
    videoDetailVC.labelImage = self.labelImage;
    videoDetailVC.label = self.label;
    [self.navigationController pushViewController:videoDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    
}


#pragma mark - response

- (void) backBtnAction:(id)btn {
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBtnBtnAction:(id) sender {

    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
    
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleLeft option:^(FTRankTableView *searchTableView) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray insertObject:@{@"itemValue":@"按时间", @"itemValueEn":@"1"} atIndex:0];
        [tempArray insertObject:@{@"itemValue":@"按人气", @"itemValueEn":@"0"} atIndex:1];
        searchTableView.dataArray = tempArray;
        searchTableView.dataType = FTDataTypeDicArray;
        searchTableView.Btnframe = frame;
        searchTableView.tableW =frame.size.width;
        
        searchTableView.tableH = 40*5;
        
        searchTableView.offsetY = 40;
        searchTableView.offsetX = 0;
        
        searchTableView.cellH = 40;
        [searchTableView caculateTableHeight];

    }];
    kindTableView.selectDelegate = self;
    kindTableView.dataType = FTDataTypeDicArray;
//    [self.view addSubview:kindTableView];
    [[UIApplication sharedApplication].keyWindow addSubview:kindTableView];
//    [kindTableView  setAnimation];
//
//    [kindTableView setDirection:FTAnimationDirectionToTop];
}


#pragma mark  分享微信
- (IBAction)shareToWeiXin:(id)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"我在“格斗东西”学习%@，fighting！",self.label];
    message.description = @"格斗技术知识为强身健体自卫防身，格斗东西团队不支持不赞成任何暴力行为。";
    
    NSData *data = [self getImageDataForSDWebImageCachedKey];
    [message setThumbData:data];
    
    
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-videos",_currentBean.videosId];
    NSString *webUrlString = [@"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?" stringByAppendingString:str];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webUrlString;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    
    [self.dialogView setHidden:YES];
}

#pragma mark  分享QQ
- (IBAction)shareToQQ:(id)sender {
    
    QQApiNewsObject* imgObj = [self setTencentReq];
    
    // 设置分享到 QZone 的标志位
    [imgObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
    [self.dialogView setHidden:YES];
}

#pragma mark  充值
- (IBAction)rechargeBtnAction:(id)sender {
    
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    [self.navigationController presentViewController:baseNav animated:YES completion:nil];
    
    [self.dialogView setHidden:YES];
}

#pragma mark  取消
- (IBAction)cancelBtnAction:(id)sender {
    
    [self.dialogView setHidden:YES];
}


#pragma mark - 分享

- (QQApiNewsObject *) setTencentReq {
    
    [MobClick event:@"videoPage_DetailPage_shareUp"];
    
    NSString *str = [NSString stringWithFormat:@"objId=%@&tableName=c-videos",_currentBean.videosId];
    NSString *webUrlString = [@"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?" stringByAppendingString:str];
    
    //设置分享链接
    NSURL* url = [NSURL URLWithString: webUrlString];
    
    QQApiNewsObject* imgObj = [[QQApiNewsObject alloc]initWithURL:url
                                                            title:[NSString stringWithFormat:@"我在“格斗东西”学习%@，fighting！",self.label]
                                                      description: @"格斗技术知识为强身健体自卫防身，格斗东西团队不支持不赞成任何暴力行为。"
                                                 previewImageData:[self getImageDataForSDWebImageCachedKey]
                                                targetContentType:QQApiURLTargetTypeNews];
    
    return imgObj;
}



// 获取SDWebImage缓存图片
- (NSData *) getImageDataForSDWebImageCachedKey {
    
    UIImage *image = [UIImage imageNamed:self.labelImage];
    NSData *data = UIImageJPEGRepresentation(image, 1);

    if (data == nil || data.length == 0) {
        UIImage *iconImg = [UIImage imageNamed:@"微信用@200"];
        data = UIImageJPEGRepresentation(iconImg, 1);
        
        int i = 1;
        while (data.length > 32*1000) {
            data = UIImageJPEGRepresentation(iconImg, 1-i/10);
            i++;
        }
        return data;
    }
    
    int i = 9;
    
    // 第一次压缩
    while (data.length > 32*1000 && i > 0) {
        data = UIImageJPEGRepresentation(image, 0.1*i);
        i--;
    }
    
    // 第一次压缩
    int j = 9;
    while (data.length > 32*1000 && j > 0) {
        data = UIImageJPEGRepresentation(image, 0.01*j);
        j--;
    }
    
    // 如果压缩之后还是太大，裁剪图片
    CGSize size = CGSizeMake(400, 400);
    if (data.length > 32*1000) {
        
        image = [UIImage imageWithData:data];
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    data = UIImageJPEGRepresentation(image, 0.5);
    
    return  data;
}

// qq 分享回调
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDSUCESS:
        {
            //            [self getPointByShareToPlatform:@"kongjian"];
            
            NSLog(@"微信分享回调成功");
            //发送通知，告诉评论页面微信登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];
        }
            break;
        default:
        {
            break;
        }
    }
}

#pragma mark - 通知响应
// 登录刷新
- (void) loginAction:(NSNotification *) noti {

    [self fetchBalanceFromWeb];
    
}

// 充值回调
-  (void) refreshBalance:(NSNotification *)noti {
    
    [self fetchBalanceFromWeb];
}

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
            
            [self fetchBalanceFromWeb];
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeOrCharge" object:@"RECHARGE"];
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"积分+1P"];
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}

#pragma mark - 查询余额
- (void) fetchBalanceFromWeb {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    if (!localUserData) {
        
        return;
    }

    // 获取余额
    [NetWorking queryMoneyWithOption:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        if ([dict[@"status"] isEqualToString:@"success"] && dict[@"data"]) {
            
            NSDictionary *dic = dict[@"data"];
            
            NSInteger taskTotal = [dic[@"taskTotal"] integerValue];
            NSInteger otherTotal = [dic[@"otherTotal"] integerValue];
            NSInteger cost = [dic[@"cost"] integerValue];
            _balance = taskTotal+otherTotal-cost;
            
            [self setBalanceText:[NSString stringWithFormat:@"%ld",taskTotal+otherTotal-cost]];
            
        }else {
            
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

#pragma mark - 显示余额
- (void) setBalanceText:(NSString *) balanceString {
    
    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: balanceString attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"P" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    
    [_balanceLabel setAttributedText:text];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
