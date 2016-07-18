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
#import "FTMatchViewController.h"
#import "FTCoachViewController.h"
#import "FTBoxingHallViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTBaseTabBarViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "AFHTTPRequestOperationManager.h"
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

@interface FTDrawerViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray *interestsArray;
//@property (nonatomic, strong) FTDrawerTableViewHeader *header;

@property (nonatomic , weak) UIButton *leftBtn;
@property (nonatomic , strong) NSMutableArray *leftBtnArray;
@property (nonatomic, strong) NSArray *labelArray; //标签数组
@property (nonatomic, copy) NSString *balance; // 余额

@end

static NSString *const colllectionCellId = @"colllectionCellId";
static NSString *const tableCellId = @"tableCellId";

@implementation FTDrawerViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initData];
    
    [self setLoginedTableView];
    
    [self setLoginView];
    
    [self setVersion];

}

- (void) viewWillAppear:(BOOL)animated {
    
    [self setNoti];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void) initData {

    _balance = @"0P";
}

- (void) setVersion {

    [self.qqLabel setTextColor:[UIColor colorWithHex:0x828287]];
    [self.versionLabel setTextColor:[UIColor colorWithHex:0x828287]];
    
    //iOS获取应用程序信息
    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    //版本号：
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
    [self.versionLabel setText:[@"当前版本：" stringByAppendingString:version]];
    
}

#pragma mark 设置监听器
- (void) setNoti {
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginResponseInDrawer:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginedViewData:) name:@"loginAction" object:nil];
    
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBalance:) name:@"RechargeOrCharge" object:nil];
    
     [self showLoginedViewData:nil];
}



// 设置登录以后显示的用户信息 tableView
- (void) setLoginedTableView {
    
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



//登陆后更新用户中心数据
- (void) showLoginedViewData:(NSNotification *)noti {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"LOGOUT"]) {//退出登录
        
        NSLog(@"执行退出登录");
        [self.loginView setHidden:NO];//显示登录页面
        
    }else {
        
        NSLog(@"show Login View");
        
        if (localUser) {
            [self setLoginedViewData:localUser];
            _labelArray = localUser.interestList;
            [self.tableView reloadData];
            
            [self.loginView setHidden:YES];//显示登录页面
        }else {
            [self.loginView setHidden:NO];//隐藏登录页面
        }
    }
    //跟新头像
    [self updateUserAvatar:localUser.headpic];
    
}


#pragma mark 更新用户头像
- (void) updateUserAvatar:(NSString *)headpic {

    
    for (UIButton *button in self.leftBtnArray) {
        
        [button sd_setImageWithURL:[NSURL URLWithString:headpic]
                          forState:UIControlStateNormal
                  placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }
}


#pragma mark 更新用户中心数据
- (void) setLoginedViewData:(FTUserBean *)localUser {

    if (localUser) {
        
        [self setAvatarImageViewImageWithString:localUser.headpic];
        [self setNameLabelText:[localUser.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [self setNameLabelText:localUser.username ];
        [self setAgeLabelText:localUser.age];
        [self setSexLabelText:[localUser.sex  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self setSexLabelText:localUser.sex];
        [self setHeightLabelText:localUser.height];
        [self setWeightLabelText:localUser.weight];
        
    }
}


#pragma mark - setter
- (void) setAvatarImageViewImageWithString:(NSString *)urlString {
    
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
// 刷新余额
- (void) refreshBalance:(NSNotification *)noti {
    
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

//微信快捷登录按钮
- (IBAction)weichatBtnAction:(id)sender {
    
    
    NetWorking *net = [[NetWorking alloc]init];
    [net weixinRequest];
    
    NSLog(@"微信快捷按钮");
}

//微信登录响应
- (void)wxLoginResponseInDrawer:(NSNotification *)noti{
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"微信登录成功"];
        
        [self showLoginedViewData:nil];
    
    }else if ([msg isEqualToString:@"ERROR"]){
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"微信登录失败"];
    }
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
        
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        if (localUserData == nil ) {
            return cell;
        }

        
        // 获取余额
        [NetWorking queryMoneyWithOption:^(NSDictionary *dict) {
            
            NSLog(@"dict:%@",dict);
            if ([dict[@"status"] isEqualToString:@"success"] && dict[@"data"]) {
                
                NSDictionary *dic = dict[@"data"];
                
                NSInteger taskTotal = [dic[@"taskTotal"] integerValue];
                NSInteger otherTotal = [dic[@"otherTotal"] integerValue];
                NSInteger cost = [dic[@"cost"] integerValue];
                
//                _balance = [NSString stringWithFormat:@"%ldP",taskTotal+otherTotal-cost];
//                [ cell.subtitle setText:_balance];
                [cell setBalanceText:[NSString stringWithFormat:@"%ld",taskTotal+otherTotal-cost]];
            }else {
                
                NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            }
        }];
        
        [cell.payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void) addButtonToArray:(UIButton *)button {
    
    if (!self.leftBtnArray) {
        
        self.leftBtnArray = [[NSMutableArray alloc]init];
        
    }
     [self.leftBtnArray addObject:button];
    
}

- (void) leftButtonClicked:(UIButton *) button {

//    if (!self.leftBtnArray) {
//        
//        self.leftBtnArray = [[NSMutableArray alloc]init];
//        
//    }
//    if(![self.leftBtnArray containsObject:button]){
//        [self.leftBtnArray addObject:button];
//    }
//    [self.leftBtnArray addObject:button];
    
//    self.leftBtn = button;
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

#pragma mark - private methods

- (void) setHomeViewController {
    FTInformationViewController *infoVC = [FTInformationViewController new];
    //    FTBaseNavigationViewController *infoNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:infoVC];
    infoVC.tabBarItem.title = @"拳讯";
    
    [infoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               Bar_Item_Select_Title_Color,NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateSelected];
    infoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳讯"];
    infoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳讯pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoVC.drawerDelegate = self;
    
    
    FTMatchViewController *matchVC = [FTMatchViewController new];
    //    FTBaseNavigationViewController *matchNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:matchVC];
    matchVC.tabBarItem.title = @"赛事";
    [matchVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    
    
    matchVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-赛事"];
    matchVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-赛事pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    matchVC.drawerDelegate = self;
    
    FTVideoViewController *videoVC = [FTVideoViewController new];
    //    FTBaseNavigationViewController *fightKingNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:fightKingVC];
    videoVC.tabBarItem.title = @"视频";
    [videoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    
    videoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-视频"];
    videoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-视频pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    videoVC.drawerDelegate = self;
    
    
    FTCoachViewController *coachVC = [FTCoachViewController new];
    //    FTBaseNavigationViewController *coachNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:coachVC];
    coachVC.tabBarItem.title = @"教练";
    [coachVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    
    coachVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    coachVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachVC.drawerDelegate = self;
    
    FTBoxingHallViewController *boxingHallVC = [FTBoxingHallViewController new];
    //    FTBaseNavigationViewController *boxingHallNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:boxingHallVC];
    boxingHallVC.tabBarItem.title = @"拳馆";
    [boxingHallVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateSelected];
    
    boxingHallVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    boxingHallVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    boxingHallVC.drawerDelegate = self;
    
    //拳吧
    FTArenaViewController *arenaVC = [FTArenaViewController new];
    arenaVC.tabBarItem.title = @"拳吧";
    [arenaVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateSelected];
    
    arenaVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳吧"];
    arenaVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳吧pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    arenaVC.drawerDelegate = self;

    //格斗场
    FTFightingViewController *fightingVC = [FTFightingViewController new];
    fightingVC.tabBarItem.title = @"格斗场";
    [fightingVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                nil] forState:UIControlStateSelected];
    fightingVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    fightingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fightingVC.drawerDelegate = self;
    
    //学拳
    FTPracticeViewController *practiceVC = [FTPracticeViewController new];
    practiceVC.tabBarItem.title = @"学拳";
    [practiceVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, NSForegroundColorAttributeName,
                                                   nil] forState:UIControlStateSelected];
    
    practiceVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    practiceVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    practiceVC.drawerDelegate = self;
    
    //设置tabbar的属性
    FTBaseTabBarViewController *tabBartVC = [FTBaseTabBarViewController new];
    
    tabBartVC.tabBar.barTintColor = [UIColor blackColor];
    tabBartVC.tabBar.translucent = NO;
//    tabBartVC.viewControllers = @[infoVC, matchVC, videoVC, coachVC, boxingHallVC];
    tabBartVC.viewControllers = @[infoVC, arenaVC, fightingVC, videoVC,practiceVC];
//        tabBartVC.viewControllers = @[infoVC, videoVC];
    
    FTBaseNavigationViewController *navi = [[FTBaseNavigationViewController alloc]initWithRootViewController:tabBartVC];
    [self.dynamicsDrawerViewController  setPaneViewController:navi];
    
    
    [self checkPush];
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
        [tabBartVC setSelectedIndex:3];
        
        FTVideoViewController *infoVC = [tabBartVC.viewControllers objectAtIndex:1];
        [infoVC pushToDetailController:dic];
    }else if ([dic[@"urlType"] isEqualToString:@"arenas"]) {
        [tabBartVC setSelectedIndex:1];
        
        FTArenaViewController *infoVC = [tabBartVC.viewControllers objectAtIndex:2];
        [infoVC pushToDetailController:dic];
    }
    
}

- (void) dealloc {
    
    [self removeObserver:self forKeyPath:@"loginAction"];
}

@end
