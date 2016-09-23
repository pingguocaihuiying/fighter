//
//  FTDrawerViewController.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerViewController.h"
#import "FTDrawerCollectionCell.h"
#import "FTTableViewCell5.h"
#import "FTDrawerCell.h"
#import "FTDrawerPayCell.h"
#import "FTLabelsCell.h"

#import "masonry.h"
#import "FTDrawerTableViewHeader.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

#import "FTInformationViewController.h"
#import "FTVideoViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTBaseTabBarViewController.h"



#import "UUID.h"
#import "FTNetConfig.h"
#import "RBRequestOperationManager.h"
#import "UIButton+WebCache.h"
#import "FTUserCenterViewController.h"

#import "FTSettingViewController.h"
#import "NetWorking.h"
#import "FTArenaViewController.h"
#import "FTHomepageMainViewController.h"
#import "FTFightingViewController.h"
#import "FTPracticeViewController.h"
#import "FTPayViewController.h"

#import "FTRankViewController.h"
#import "FTStoreViewController.h" // 之前版本用兑吧商城，现在用自定义H5页面
#import "FTShopViewController.h"  // 新版本商城

#import "FTFightingViewController.h"


@interface FTDrawerViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>
{
    // 兑吧地址
    NSInteger _duibaConfig;
}
//@property (nonatomic, strong) NSMutableArray *interestsArray;
//@property (nonatomic, strong) FTDrawerTableViewHeader *header;

@property (nonatomic, strong) FTBaseTabBarViewController *tabBarVC;
@property (nonatomic, strong) NSArray *labelArray; //标签数组


@end

static NSString *const colllectionCellId = @"colllectionCellId";
static NSString *const tableCellId = @"tableCellId";

@implementation FTDrawerViewController

- (id) init {

    self = [super init];
    
    if (self) {
        
        _duibaConfig = 1;
//        // 获取兑吧展示配置
//        [self getDuibaConfigInfo];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置用户中心展示版本号和QQ群
    [self setVersion];
    
    // 设置监听器
    [self setNoti];
    
    // 设置登录后tableView
    [self setTableView];
    
    // 设置未登录的时候显示信息
    [self setLoginView];
    
    // tableview 数据适配
    [self tableViewAdapter];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void) dealloc {
    
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark - 初始化

// 设置监听器
- (void) setNoti {
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginCallback:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneLoginedCallback:) name:LoginNoti object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeCallback:) name:RechargeResultNoti object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneLoginedCallback:) name:EditNotification object:nil];
}

// 设置显示版本号
- (void) setVersion {

    [self.qqLabel setTextColor:[UIColor colorWithHex:0x828287]];
    [self.versionLabel setTextColor:[UIColor colorWithHex:0x828287]];
    
    //iOS获取应用程序信息
    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    //版本号：
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
    [self.versionLabel setText:[@"当前版本：" stringByAppendingString:version]];
    
}


// 设置登录以后显示的用户信息 tableView
- (void) setTableView {
    
    NSLog(@"serSubviews");
    
    [self.view setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [self.headerView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [self.footerView setBackgroundColor:[UIColor colorWithHex:0x191919]];
//    //切换图层，把头像边框放到上层
//    [self.headerView sendSubviewToBack:self.avatarImageView];
    
    //设置头像圆角
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:39];
    
    //设置身高、体重label字体颜色
    self.heightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    self.weightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTDrawerCell" bundle:nil] forCellReuseIdentifier:@"tableCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTDrawerPayCell" bundle:nil] forCellReuseIdentifier:@"payCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTLabelsCell" bundle:nil] forCellReuseIdentifier:@"labelsCellId"];
//    if (SCREEN_HEIGHT > 568) {
//        self.tableView.scrollEnabled = NO;
//    }else {
//        
//        self.tableView.scrollEnabled = YES;
//    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableHeaderView = self.headerView;

//    UIView *footView = [[[UIView alloc]init]initWithFrame:self.footerView.frame];
//    footView.backgroundColor = [UIColor clearColor];dddddddddddsssas
//    [footView addSubview:self.settingBtn];
//    [footView addSubview:self.qqLabel];
//    [footView addSubview:self.versionLabel];
//    self.tableView.tableFooterView = footView;
    
    CGFloat offsetW = [UIScreen mainScreen].bounds.size.width *0.3;
    
    @try {
        //把约束添加到父视图上
        [self.loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //子view的右边缘离父view的右边缘40个像素
        NSLayoutConstraint *rightContraint = [NSLayoutConstraint constraintWithItem:self.loginView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:-offsetW];
        
        
        [self.view addConstraint:rightContraint];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
    } @finally {
        
    }
    
    [self setTouchEvent];
    
}


//设置登录视图
- (void) setLoginView {
    
    [self.loginView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //微信快捷登录按钮
    [self.weichatLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weichatLoginBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateHighlighted];
    [self.weichatLoginBtn addTarget:self action:@selector(weichatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tipLabel setTextColor:[UIColor colorWithHex:0x505050]];
    

    if (![WXApi isWXAppInstalled] ) {
        [self.weichatLoginBtn setHidden:YES];
    }
}

#pragma mark - 登录回调
// 登陆后更新用户中心数据
- (void) phoneLoginedCallback:(NSNotification *)noti {
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"LOGOUT"]) {//退出登录
        
        NSLog(@"执行退出登录");
        [self.loginView setHidden:NO];//显示登录页面
        
        
    }else {
        
        // 获取余额
        FTPaySingleton *singleton = [FTPaySingleton shareInstance];
        [singleton fetchBalanceFromWeb:^{
        
            [self refreshBalanceCell];
        }];
        
        // 更新用户信息
        [self tableViewAdapter];
    }
}


// 微信登录响应
- (void) wxLoginCallback:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"微信登录成功"];
        
        // 获取余额
        FTPaySingleton *singleton = [FTPaySingleton shareInstance];
        [singleton fetchBalanceFromWeb:^{
            
            [self refreshBalanceCell];
        }];
        
        [self tableViewAdapter];
        
    }else if ([msg isEqualToString:@"ERROR"]){
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"微信登录失败"];
    }
}

#pragma mark - 充值回调
- (void) rechargeCallback:(NSNotification *)noti {
    
    // 获取余额
    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
    [singleton fetchBalanceFromWeb:^{
        
        [self refreshBalanceCell];
    }];
}

- (void) refreshBalanceCell {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 更新用户中心

- (void) tableViewAdapter {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (localUser) {
        
        [self setTableHeader:localUser];
        _labelArray = localUser.interestList;
        
        [self.tableView reloadData];
        
        [self.loginView setHidden:YES];//显示登录页面
    }else {
        [self.loginView setHidden:NO];//隐藏登录页面
    }
    
}


// 更新用户中心数据
- (void) setTableHeader:(FTUserBean *)localUser {

    if (localUser) {
        
        
        [self loadAvatarWithString:localUser.headpic];
        [self setNameLabelText:[localUser.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [self setNameLabelText:localUser.username ];
        [self setAgeLabelText:localUser.age];
//        [self setSexLabelText:localUser.sex ];
        [self setSexLabelText:[localUser.sex  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [self setSexLabelText:[localUser.sex stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]]];
//        [self setSexLabelText:[localUser.sex stringByAddingPercentEscapesUsingEncoding:enc]];
        
//        [self setSexLabelText:[localUser.sex stringByRemovingPercentEncoding]];
        [self setHeightLabelText:localUser.height];
        [self setWeightLabelText:localUser.weight];
    }
}


#pragma mark - setter

- (void) loadAvatarWithString:(NSString *)urlString {
    
    [self.avatarImageView  sd_setImageWithURL:[NSURL URLWithString:urlString]
                             placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
}

- (void) setNameLabelText:(NSString *) text {
    
    if (text.length <= 0 || text == nil) {
        [self.nameLabel setText:@"用户名未设置"];
        [self.nameLabel setTextColor:[UIColor colorWithHex:0x505050]];
    }else {
        [self.nameLabel setText:text];
    }
    
}
- (void) setSexLabelText:(NSString *) text {

    if (text.length <= 0 || text == nil) {
        [self.sexLabel setText:@"男"];
    }else {
        [self.sexLabel setText:text];
        NSLog(@"sex:%@",[text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }
}

- (void) setAgeLabelText:(NSString *) text {
    
    if (text.length <= 0 || text == nil) {
        [self.ageLabel setText:@"18岁"];
    }else {
        [self.ageLabel setText:[NSString stringWithFormat:@"%@岁",text]];
    }
}

- (void) setHeightLabelText:(NSString *) text {
    
    if (text.length <= 0 || text == nil) {
        [self.heightLabel setText:@"身高：-- cm"];
    }else {
        [self.heightLabel setText:[NSString stringWithFormat:@"身高：%@cm",text]];
    }
}

- (void) setWeightLabelText:(NSString *) text {
    
    if (text.length <= 0 || text == nil) {
        [self.weightLabel setText:@"体重：-- kg"];
    }else {
        [self.weightLabel setText:[NSString stringWithFormat:@"体重：%@kg",text]];
    }
}


#pragma mark - response methods

//微信快捷登录按钮
- (IBAction)weichatBtnAction:(id)sender {
    
    
    NetWorking *net = [[NetWorking alloc]init];
    [net weixinRequest];
    
    NSLog(@"微信快捷按钮");
}


- (IBAction)loginBtnAction:(id)sender {
    NSLog(@"loginBtn action Did");
    
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    baseNav.navigationBarHidden = NO;
    baseNav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:baseNav animated:YES completion:nil];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}


//编辑按钮事件
- (IBAction)editingBtnAction:(id)sender {
   
    [MobClick event:@"homePage_Date"];
    
    NSLog(@"%@",[@"男性" stringByRemovingPercentEncoding]);
    NSLog(@"%@",[[@"男性" stringByRemovingPercentEncoding] stringByRemovingPercentEncoding]);
    
    FTUserCenterViewController *userCenter = [[FTUserCenterViewController alloc]init];
    userCenter.title = @"个人资料";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:userCenter];
    baseNav.navigationBarHidden = NO;
//    baseNav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:baseNav animated:YES completion:nil];
}

//设置按钮事件
- (IBAction)settingBtnAction:(id)sender {
    [MobClick event:@"homePage_SetUp"];
    
    FTSettingViewController *settingVC = [[FTSettingViewController alloc]init];
    settingVC.title = @"设置";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:settingVC];
    baseNav.navigationBarHidden = NO;

    [self presentViewController:baseNav animated:YES completion:nil];
}


//  充值按钮，点击跳转到充值界面
- (void) payBtnAction:(id) sender {
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    [self presentViewController:baseNav animated:YES completion:nil];
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FTDrawerCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:colllectionCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.fightType = indexPath.row;
    [cell setBackImgView];
    
    return cell;
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    switch (indexPath.row) {
        case 0:
            width = 68;
            break;
        case 1:
            width = 48.5;
            break;
        case 2:
            width = 48.5;
            break;
        case 3:
            width = 68;
            break;
        case 4:
            width = 48.5;
            break;
        case 5:
            width = 59;
            break;
        case 6:
            width = 48.5;
            break;
        case 7:
            width = 48.5;
            break;
        case 8:
            width = 59;
            break;
        case 9:
            width = 48.5;
            break;
        case 10:
            width = 48.5;
            break;
        case 11:
            width = 68;
            break;
        case 12:
            width = 48.5;
            break;
        default:
            break;
    }

    return (CGSize){width,14};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
}


#pragma mark - tableViewDatasource delegate

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return 4;
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 65;
    }
    
    if (indexPath.row == 1) {
        return 85;
    }
    
//    if (indexPath.row == 0) {
//        return 85;
//    }
    return 45 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        FTLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelsCellId"];
        
        if (_labelArray.count > 0) {
            
            [cell.tipLabel setHidden:YES];
            [cell.collectionView registerClass:[FTDrawerCollectionCell class] forCellWithReuseIdentifier:colllectionCellId];
            cell.collectionView.dataSource = self;
            cell.collectionView.delegate = self;
        }else {
        
            [cell.tipLabel setHidden:NO];
        }
        return cell;
        
    }else if (indexPath.row == 1) {
        
        FTDrawerPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCellId"];
        cell.cellTitle.text = @"账户余额:";
        cell.subtitle.text = @"0P";
        
        [cell.payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        if (localUserData == nil) {
            return cell;
        }
        
        FTPaySingleton *singleton = [FTPaySingleton shareInstance];
        NSLog(@"balance:%ld",singleton.balance);
        [cell setBalanceText:[NSString stringWithFormat:@"%ld",singleton.balance]];
        
        return cell;
    }else {
        
        FTDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellId"];
        
        if (indexPath.row == 2) {
            cell.cellTitle.text = @"我的关注";
            [cell.subtitle setHidden:YES];
        }else if (indexPath.row == 3) {
            cell.cellTitle.text = @"我的收藏";
            [cell.subtitle setHidden:YES];
        }else if (indexPath.row == 4) {
            cell.cellTitle.text = @"比赛信息";
            [cell.subtitle setHidden:YES];
        }
        
         return cell;
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"cell did select");
    if (indexPath.row == 1) {
        FTPayViewController *payVC = [[FTPayViewController alloc]init];
        FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
        baseNav.navigationBarHidden = NO;
        [self presentViewController:baseNav animated:YES completion:nil];
        
    }
}

#pragma  mark - FTDynamicsDelegate

- (void) leftButtonClicked:(UIButton *) button {

    [self.dynamicsDrawerViewController setPaneState:FTDynamicsDrawerPaneStateOpen
                                       inDirection:FTDynamicsDrawerDirectionLeft
                                          animated:YES
                             allowUserInterruption:YES
                                        completion:nil];
}


#pragma mark - 点击事件

//设置点击事件，连续点击屏幕5次可以切换app发布版和预览版
- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.tableView.tableHeaderView addGestureRecognizer:tap];
    
}

//响应点击事件
- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    [self gotoHomepageWithUseroldid:nil];
}

#pragma mark 个人主页入口
- (void)gotoHomepageWithUseroldid:(NSString *)olduserid{
    if (!olduserid) {
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        olduserid = localUser.olduserid;
    }
    FTHomepageMainViewController *homepageViewController = [FTHomepageMainViewController new];
    homepageViewController.olduserid = olduserid;
    
    
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:homepageViewController];
    baseNav.navigationBarHidden = NO;
    
    [self presentViewController:baseNav animated:YES completion:nil];
}

#pragma mark - private methods

- (void) setHomeViewController {
    
    // 早期版本展示页
    {
//    // 视频
//    FTVideoViewController *videoVC = [FTVideoViewController new];
//    //    FTBaseNavigationViewController *fightKingNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:fightKingVC];
//    videoVC.tabBarItem.title = @"视频";
//    [videoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
//                                                nil] forState:UIControlStateSelected];
//    
//    videoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-视频"];
//    videoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-视频pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    videoVC.drawerDelegate = self;
    
    
    
//    //拳吧
//    FTArenaViewController *arenaVC = [FTArenaViewController new];
//    arenaVC.tabBarItem.title = @"拳吧";
//    [arenaVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
//                                                     nil] forState:UIControlStateSelected];
//    
//    arenaVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳吧"];
//    arenaVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳吧pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    arenaVC.drawerDelegate = self;

    
    //    infoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳讯"];
    //    infoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳讯pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    // 拳讯
    FTInformationViewController *infoVC = [FTInformationViewController new];
    infoVC.title = @"拳讯";
    infoVC.tabBarItem.title = @"拳讯";
    [infoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               Bar_Item_Select_Title_Color,NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateSelected];
    
    infoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-视频"];
    infoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-视频pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 格斗场
    FTFightingViewController *fightingVC = [FTFightingViewController new];
    fightingVC.title = @"格斗场";
    fightingVC.tabBarItem.title = @"格斗场";
    [fightingVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    fightingVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    fightingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 学拳
    FTPracticeViewController *practiceVC = [FTPracticeViewController new];
    practiceVC.title = @"学拳";
    practiceVC.tabBarItem.title = @"学拳";
    [practiceVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                   nil] forState:UIControlStateSelected];
    
    practiceVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    practiceVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 排行榜
    FTRankViewController *rankHomeVC = [FTRankViewController new];
    rankHomeVC.title = @"排行榜";
    rankHomeVC.tabBarItem.title = @"排行榜";
    [rankHomeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                   nil] forState:UIControlStateSelected];
    rankHomeVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-底部排行榜"];
    rankHomeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-底部排行榜pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    // 版本1.6 隐藏兑吧商城
    // 兑吧
//    FTStoreViewController *duibaVC = [FTStoreViewController new];
//    duibaVC.title = @"格斗商城";
//    duibaVC.tabBarItem.title = @"格斗商城";
//    [duibaVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                   Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
//                                                   nil] forState:UIControlStateSelected];
//    
//    duibaVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-商城"];
//    duibaVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-商城pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 自定义H5页面商城
    FTShopViewController *shopVC = [FTShopViewController new];
    shopVC.title = @"格斗商城";
    shopVC.tabBarItem.title = @"格斗商城";
    [shopVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    
    shopVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-商城"];
    shopVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-商城pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 设置tabbar的属性
    _tabBarVC = [FTBaseTabBarViewController new];
    
    _tabBarVC.tabBar.barTintColor = [UIColor blackColor];
    _tabBarVC.tabBar.translucent = NO;
    _tabBarVC.navigationController.navigationBar.translucent = NO;
    _tabBarVC.drawerDelegate = self;
    _tabBarVC.openSliderDelegate = self.dynamicsDrawerViewController;
    
//    tabBartVC.viewControllers = @[infoVC, arenaVC, fightingVC, videoVC,practiceVC];
//    tabBartVC.viewControllers = @[infoVC, arenaVC,videoVC,practiceVC];
//    tabBartVC.viewControllers = @[infoVC,videoVC,practiceVC,arenaVC];
    
//    tabBartVC.viewControllers = @[infoVC,fightingVC,practiceVC,rankNavi,duibaVC];
    
//    
//    if (_duibaConfig == 0) {
//        
//        _tabBarVC.viewControllers = @[infoVC,rankHomeVC,practiceVC,duibaVC];
//    }else {
//        
//        _tabBarVC.viewControllers = @[infoVC,practiceVC,rankHomeVC];
//    }
    
    _tabBarVC.viewControllers = @[infoVC,fightingVC,practiceVC,rankHomeVC];
    
//     _tabBarVC.viewControllers = @[infoVC,fightingVC,practiceVC,rankHomeVC,shopVC];
    
    FTBaseNavigationViewController *navi = [[FTBaseNavigationViewController alloc]initWithRootViewController:_tabBarVC];
    [self.dynamicsDrawerViewController  setPaneViewController:navi];
    
    
    [self getDuibaConfigInfo:^{
        
        if (_duibaConfig == 0) {
            
           [self addTabBarVC:shopVC];
        }

    }];
    
    // 推送
    [self checkPush];
}



- (void) addTabBarVC:(UIViewController *)viewController {

    NSMutableArray *mutabelItems = [[NSMutableArray alloc]initWithArray:self.tabBarVC.viewControllers];
    
    [mutabelItems addObject:viewController];
    NSArray *items = [[NSArray alloc]initWithArray:mutabelItems];
    
    self.tabBarVC.viewControllers = items;

}

- (void) checkPush {

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessageDic"];
    if (dic != nil) {
        
        [self push:dic];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushMessageDic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//推送响应方法
- (void) push:(NSDictionary *)dic {

    FTBaseNavigationViewController *navi = (FTBaseNavigationViewController *)self.dynamicsDrawerViewController.paneViewController;
    
    FTBaseTabBarViewController *tabBartVC = [navi.viewControllers firstObject];
    
    if ([dic[@"urlType"] isEqualToString:@"news"]) {
        [tabBartVC setSelectedIndex:0];
        
        FTInformationViewController *infoVC = [tabBartVC.viewControllers objectAtIndex:0];
        [infoVC pushToDetailController:dic];
        
    }else if ([dic[@"urlType"] isEqualToString:@"video"]) {
        [tabBartVC setSelectedIndex:7];
        
        FTVideoViewController *infoVC = [tabBartVC.viewControllers objectAtIndex:1];
        [infoVC pushToDetailController:dic];
        
    }else if ([dic[@"urlType"] isEqualToString:@"arenas"]) {
        [tabBartVC setSelectedIndex:6];
        
        FTArenaViewController *infoVC = [tabBartVC.viewControllers objectAtIndex:2];
        [infoVC pushToDetailController:dic];
    }else if ([dic[@"urlType"] isEqualToString:@"teach"]) {
        [tabBartVC setSelectedIndex:2];
        
        FTPracticeViewController *vc = [tabBartVC.viewControllers objectAtIndex:2];
        [vc pushToDetailController:dic];
    }else if ([dic[@"urlType"] isEqualToString:@"match"]) {//比赛
        [tabBartVC setSelectedIndex:1];
        FTFightingViewController *vc = [tabBartVC.viewControllers objectAtIndex:1];
        [vc pushToDetailController:dic];
    }
    
    
    if([dic[@"taskLocalNotification"] isEqualToString:@"taskLocalNotification"]) {
    
        [self.tabBarVC taskBtnAction:nil];
    }
    
}


#pragma mark - 网络通讯

// 获取兑吧地址
- (void) getDuibaConfigInfo:(void (^)(void)) option{

    [NetWorking GetDuiBaConfig:^(NSDictionary *dict) {
        
        NSLog(@"duiba dict:%@",dict);
        
        if (!dict) {
            return ;
        }
        
        NSDictionary *dict_data = [dict[@"data"] objectAtIndex:0];
        if (dict_data) {
            
            _duibaConfig = [dict_data[@"config_value"] integerValue];
        }
        
        option();
        
    }];
}
@end
