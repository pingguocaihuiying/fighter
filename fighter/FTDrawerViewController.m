//
//  FTDrawerViewController.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerViewController.h"
#import "FTDrawerCollectionCell.h"
#import "FTDrawerTableViewCell.h"
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
#import "Mobclick.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "UUID.h"
#import "FTNetConfig.h"
#import "RBRequestOperationManager.h"
#import "UIButton+WebCache.h"
#import "FTUserCenterViewController.h"
#import "UMFeedback.h"
#import "FTSettingViewController.h"
#import "NetWorking.h"


@interface FTDrawerViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray *interestsArray;

//@property (nonatomic, strong) FTDrawerTableViewHeader *header;
@property (nonatomic , weak) UIButton *leftBtn;
@end

static NSString *const colllectionCellId = @"colllectionCellId";
static NSString *const tableCellId = @"tableCellId";

@implementation FTDrawerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    _interestsArray = @[ @[综合格斗],
//                       @[sanda]]
    
    [self setLoginedView];
    
    [self setLoginView];
    
    [self hiddenViews];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //注册通知，接收微信登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLoginResponse:) name:WXLoginResultNoti object:nil];
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginedViewData) name:@"loginAction" object:nil];
    [self showLoginedViewData];
}



- (void) viewWillDisappear:(BOOL)animated {
    
    //销毁通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

//hidden the some view that current version app does not need
- (void) hiddenViews {
    
    [self.collectionView setHidden:YES];
    [self.tableView setHidden:YES];
    [self.settingBtn setHidden:NO];
    
}



- (void) setLoginedView {
    
    NSLog(@"serSubviews");
    
    [self.view setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [self.drawerView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    
    
    //切换图层，把头像边框放到上层
    [self.drawerView sendSubviewToBack:self.avatarImageView];
    
    //设置头像圆角
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:39];
    
    //设置身高、体重label字体颜色
    self.heightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    self.weightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    
    [self.collectionView registerClass:[FTDrawerCollectionCell class] forCellWithReuseIdentifier:colllectionCellId];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    //    [self.tableView registerClass:[FTDrawerTableViewCell class] forCellReuseIdentifier:tableCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithHex:0x505050];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    CGFloat offsetW = [UIScreen mainScreen].bounds.size.width *0.3;
    
    @try {
        //把约束添加到父视图上
        [self.drawerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //子view的右边缘离父view的右边缘40个像素
        NSLayoutConstraint *rightContraint = [NSLayoutConstraint constraintWithItem:self.drawerView
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
    
    
    [self.abountUsBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateHighlighted];
    [self.feedbackBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateHighlighted];
    
//    CGFloat offsetW = [UIScreen mainScreen].bounds.size.width *0.3;
//    //子view的右边缘离父view的右边缘40个像素
//    NSLayoutConstraint *rightContraint = [NSLayoutConstraint constraintWithItem:self.loginView
//                                                                      attribute:NSLayoutAttributeRight
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:self.view
//                                                                      attribute:NSLayoutAttributeRight
//                                                                     multiplier:1.0
//                                                                       constant:-offsetW];
//    
//    //把约束添加到父视图上
//    [self.loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addConstraint:rightContraint];

}


//
- (void) showLoginedViewData {
    
    NSLog(@"show Login View");
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (localUser) {
        
        [self setLoginedViewData:localUser];
        [self.loginView setHidden:YES];//隐藏登录界面
        
    }else {
    
        [self.loginView setHidden:NO];//隐藏登录界面
    }
}

- (void) setLoginedViewData:(FTUserBean *)localUser {

    if (localUser) {
        
        [self.loginView setHidden:YES];//隐藏登录界面
        
        [self setAvatarImageViewImageWithString:localUser.headpic];
        [self setNameLabelText:[localUser.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [self setNameLabelText:localUser.username ];
        [self setAgeLabelText:localUser.age];
        [self setSexLabelText:[localUser.sex  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self setSexLabelText:localUser.sex];
        [self setHeightLabelText:localUser.height];
        [self setWeightLabelText:localUser.weight];
        
        if(self.leftBtn && localUser.headpic){
            [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"头像-空"]];

        }
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
//微信快捷登录按钮
- (IBAction)weichatBtnAction:(id)sender {
    
    
    NetWorking *net = [[NetWorking alloc]init];
    [net weixinRequest];
    
//    if ([WXApi isWXAppInstalled] ) {
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo";
//        req.state = @"fighter";
//        [WXApi sendReq:req];
//
//    }else{
//        NSLog(@"目前只支持微信登录，请安装微信");
//        [self showHUDWithMessage:@"未安装微信！"];
//    }
    
    NSLog(@"微信快捷按钮");
}

//
//- (void)wxLoginResponse:(NSNotification *)noti{
//    NSString *msg = [noti object];
//    if ([msg isEqualToString:@"SUCESS"]) {
//        [self showHUDWithMessage:@"微信登录成功"];
//        
//        //从本地读取存储的用户信息
//        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//        if (localUser) {
//            [self setLoginedViewData:localUser];
//        }
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }else if ([msg isEqualToString:@"ERROR"]){
//        [self showHUDWithMessage:@"微信登录失败"];
//    }
//}

- (IBAction)loginBtnAction:(id)sender {
    NSLog(@"loginBtn action Did");
    
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    baseNav.navigationBarHidden = NO;
    baseNav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:baseNav animated:YES completion:^{
        [self showLoginedViewData];
    }];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (IBAction)abountUsAction:(id)sender {
    
}

- (IBAction)feedBackAction:(id)sender {
    
//    [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                animated:YES];
    
    UIViewController *feedback = [UMFeedback feedbackViewController];
    self.navigationController.navigationBar.hidden = NO;
    [feedback.view setBackgroundColor:[UIColor colorWithHex:0x191919]];
    
    for (int i= 0;  i<[feedback.view subviews].count;i++) {
        UIView *view = [[feedback.view subviews] objectAtIndex:i];
        CGRect frame = view.frame;
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLog(@"%d\n:%@\nframe:(%f,%f,%f,%f)",i,view,frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        if (i < 5) {
            [view.layer setMasksToBounds:YES];
            CGPoint point = CGPointMake(frame.origin.x, frame.origin.y+60);
            CGSize  size  = CGSizeMake(frame.size.width, frame.size.height +30);
            view.frame = (CGRect){ point,size};
        }
    }
    
    [self.navigationController pushViewController:feedback
                                         animated:YES];
//    [self.navigationController presentViewController:[UMFeedback feedbackViewController] animated:YES completion:nil];

}

//编辑按钮事件
- (IBAction)editingBtnAction:(id)sender {
   
    
    FTUserCenterViewController *userCenter = [[FTUserCenterViewController alloc]init];
    userCenter.title = @"个人资料";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:userCenter];
    baseNav.navigationBarHidden = NO;
//    baseNav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:baseNav animated:YES completion:nil];
    
}

//设置按钮事件
- (IBAction)settingBtnAction:(id)sender {
    
    FTSettingViewController *settingVC = [[FTSettingViewController alloc]init];
    settingVC.title = @"设置";
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:settingVC];
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
            width = 70;
            break;
        case 1:
            width = 40;
            break;
        case 2:
            width = 40;
            break;
        case 3:
            width = 70;
            break;
        case 4:
            width = 40;
            break;
        case 5:
            width = 50;
            break;
        case 6:
            width = 40;
            break;
        case 7:
            width = 40;
            break;
        case 8:
            width = 50;
            break;
        case 9:
            width = 40;
            break;
        case 10:
            width = 50;
            break;
        case 11:
            width = 70;
            break;
        case 12:
            width = 40;
            break;
        default:
            break;
    }

    return (CGSize){width,20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
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

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46 ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.5;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor colorWithHex:0x505050];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    if (cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"右箭头"]];
        [cell addSubview:imageView];
        
        CGRect frame = cell.textLabel.frame;
        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
        [cell.textLabel setFrame:frame];
        __weak __typeof(&*cell) weakCell = cell;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakCell.mas_centerY);
            make.right.equalTo(weakCell.mas_right).with.offset(-16);
            make.height.equalTo(@14);
            make.width.equalTo(@7);

        }];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的关注";
        cell.textLabel.textColor = [UIColor whiteColor];
    }else {
        cell.textLabel.text = @"我的收藏";
    }
//    FTDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
//    
//    if (!cell) {
//        
////        cell = [[FTDrawerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTDrawerTableViewCell" owner:self options:nil]firstObject];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"我的关注";
////        [cell setTitleWithString:@"我的关注"];
////        cell.cellTitle.text = @"我的关注";
//        
//    }else {
//        cell.textLabel.text = @"我的关注";
////        cell.cellTitle.text = @"我的收藏";
//    }
//    NSLog(@"cell:%@",cell);
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma  mark - FTDynamicsDelegate

- (void) leftButtonClicked:(UIButton *) button {

    self.leftBtn = button;
    [self.dynamicsDrawerViewController setPaneState:FTDynamicsDrawerPaneStateOpen
                                       inDirection:FTDynamicsDrawerDirectionLeft
                                          animated:YES
                             allowUserInterruption:YES
                                        completion:nil];
}

#pragma mark - private methods
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


- (void) setHomeViewController {

    
    FTInformationViewController *infoVC = [FTInformationViewController new];
    //    FTBaseNavigationViewController *infoNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:infoVC];
    infoVC.tabBarItem.title = @"拳讯";
    
    [infoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                               nil] forState:UIControlStateSelected];
    infoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳讯"];
    infoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳讯pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoVC.drawerDelegate = self;
    
    FTMatchViewController *matchVC = [FTMatchViewController new];
    //    FTBaseNavigationViewController *matchNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:matchVC];
    matchVC.tabBarItem.title = @"赛事";
    [matchVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    
    
    matchVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-赛事"];
    matchVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-赛事pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    matchVC.drawerDelegate = self;
    
    FTVideoViewController *videoVC = [FTVideoViewController new];
    //    FTBaseNavigationViewController *fightKingNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:fightKingVC];
    videoVC.tabBarItem.title = @"视频";
    [videoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    
    videoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-视频"];
    videoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-视频pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    videoVC.drawerDelegate = self;
    
    FTCoachViewController *coachVC = [FTCoachViewController new];
    //    FTBaseNavigationViewController *coachNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:coachVC];
    coachVC.tabBarItem.title = @"教练";
    [coachVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    
    coachVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    coachVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    coachVC.drawerDelegate = self;
    
    FTBoxingHallViewController *boxingHallVC = [FTBoxingHallViewController new];
    //    FTBaseNavigationViewController *boxingHallNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:boxingHallVC];
    boxingHallVC.tabBarItem.title = @"拳馆";
    [boxingHallVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                     nil] forState:UIControlStateSelected];
    
    boxingHallVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    boxingHallVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    boxingHallVC.drawerDelegate = self;
    
    //设置tabbar的属性
    FTBaseTabBarViewController *tabBartVC = [FTBaseTabBarViewController new];
    
    tabBartVC.tabBar.barTintColor = [UIColor blackColor];
    tabBartVC.tabBar.translucent = NO;
    tabBartVC.viewControllers = @[infoVC, matchVC, videoVC, coachVC, boxingHallVC];
    
    FTBaseNavigationViewController *navi = [[FTBaseNavigationViewController alloc]initWithRootViewController:tabBartVC];
    
    
    [self.dynamicsDrawerViewController  setPaneViewController:navi];
}

- (void) dealloc {
    
    [self removeObserver:self forKeyPath:@"loginAction"];
}

@end
