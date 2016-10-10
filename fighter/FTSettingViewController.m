//
//  FTSettingViewController.m
//  fighter
//
//  Created by kang on 16/5/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSettingViewController.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"
#import "NSString+Size.h"
#import "FTTableViewCell5.h"
#import "FTFiler.h"
#import "FTAbountUsViewController.h"
#import "FTManagerAccountViewController.h"

@interface FTSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableBackground;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation FTSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
//
    
    [self initSubviews];
    
    //设置点击事件
    [self setTouchEvent];
}



- (void) initSubviews {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell5" bundle:nil] forCellReuseIdentifier:@"SettingCellId"];
//        [self.tableView registerClass:[FTTableViewCell5 class] forCellReuseIdentifier:@"cellId"];
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = Cell_Space_Color;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
     FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self.logoutBtn setEnabled:NO];
    }
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self.logoutBtn setHidden:YES];
    }else {
    
        [self.logoutBtn setHidden:NO];
    }
    
}


-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -response 

- (IBAction)loginOutBtnAction:(id)sender {
    
    [MobClick event:@"homePage_SetUp_Logout"];
    
    NetWorking *net = [NetWorking new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [net loginOut:^(NSDictionary *dict) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNoti object:@"LOGOUT"];
        
        NSLog(@"dict:%@",dict);
        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"退出成功"];
    }];
}

- (void) backBtnAction:(id) sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView datasouce and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46 ;
}


//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *header = [[UIView alloc]init];
//    header.backgroundColor = [UIColor colorWithHex:0x505050];
//    return header;
//}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cell for row");
    FTTableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellId"];
//    FTTableViewCell5 *cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTableViewCell5" owner:nil options:nil]firstObject];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"账号管理：";
    }if (indexPath.row == 1) {
        cell.titleLabel.text = @"清除缓存：";
       
        FTFiler * filer = [[FTFiler alloc]init];

        cell.remarkLabel.text = [NSString stringWithFormat:@"%.1fMB",[filer sizeOfCaches]];;
    }if (indexPath.row == 2) {
        cell.titleLabel.text = @"意见反馈：";
    }if (indexPath.row == 3) {
        cell.titleLabel.text = @"关于我们：";
    }if (indexPath.row == 4) {
        cell.titleLabel.text = @"评个分吧：";
    }

    
    NSLog(@"cell:%@",cell);
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if(indexPath.row == 0) {
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        if (localUser) {
            FTManagerAccountViewController *managerVC = [[FTManagerAccountViewController alloc]init];
            managerVC.title = @"账号管理";
            [self.navigationController pushViewController:managerVC animated:YES];
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"请先登陆"];
        }
        
    
    }else if (indexPath.row == 1){
        //清除缓存
        FTFiler * filer = [[FTFiler alloc]init];
        
        if ([filer sizeOfCaches] > 0.099999999) {
            [filer clearCacheFiles];
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"清除缓存成功"];
            [self.tableView reloadData];
        }else {
        
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"没有缓存"];
        }
        
        
    }else if (indexPath.row == 2){
        [MobClick event:@"homePage_SetUp_Feedback"];
        [UMFeedback showFeedback:self  withAppkey:@"570739d767e58edb5300057b"];
        
    }else if (indexPath.row == 3){
        [MobClick event:@"homePage_SetUp_AboutUs"];
        
        FTAbountUsViewController *abountUsVC = [[FTAbountUsViewController alloc]init];
        abountUsVC.title = @"关于我们";
        [self.navigationController pushViewController:abountUsVC animated:YES];
        
    }else if (indexPath.row == 4){
        //评分
        [MobClick event:@"homePage_SetUp_Score"];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *cacheDirectory = [paths objectAtIndex:0];
//        NSString *appFile = [cacheDirectory stringByAppendingPathComponent:NEW_VERSION_INFO];
//        NSDictionary* tDic = [[[NSDictionary alloc]initWithContentsOfFile:appFile]autorelease];
//        NSString* tPath = [tDic valueForKey:@"path"];
//        
//        NSRange range1 = [tPath rangeOfString:@"/id"];
//        tPath = [tPath substringFromIndex:range1.location+range1.length];
        //    NSRange range2 = [tPath rangeOfString:@"?"];
        //    tPath = [tPath substringToIndex:range2.location];
        NSString * urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",APPID];
//        NSString *urlStr = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1108272405&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//        https://itunes.apple.com/cn/app/ge-dou-jia-ge-dou-ping-tai/id1108272405?mt=8
    }
    
}




//设置点击事件，连续点击屏幕5次可以切换app发布版和预览版
- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 5;
    [self.view addGestureRecognizer:tap];
    
}

//响应点击事件
- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.view];
    for (UIView *view in self.view.subviews) {
        CGRect frame = [self.view convertRect:view.frame toView:self.view];
        if (CGRectContainsPoint(frame, point)) {
            return;
        }
    }
    
//    NSString *showType = [[NSUserDefaults standardUserDefaults] objectForKey:ShowType];
//    if ([showType isEqualToString:@"1"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ShowType];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        []
//    }else {
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ShowType];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
    [FTNetConfig changePreviewVersion];
    if ([[FTNetConfig showType] integerValue] == 1) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"已经切换为预览版"];
    }else {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"已经切换为正式版"];
    }
    
}



@end
