//
//  FTDailyTaskViewController.m
//  fighter
//
//  Created by kang on 16/8/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDailyTaskViewController.h"
#import "FTTaskShareCell.h"
#import "FTTaskRemindCell.h"
#import "FTFinishedTaskViewController.h"

@interface FTDailyTaskViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTDailyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"东西任务";
    
    [self setNavigationbar];
    
    [self initSubViews];
}


- (void) viewWillAppear:(BOOL)animated {
    
    // 注册通知，分享到微信成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callbackShareToWeiXin:) name:WXShareResultNoti object:nil];
    
}


- (void) viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:WXShareResultNoti object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - 初始化

- (void) setNavigationbar {

    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void) initSubViews {

    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTaskShareCell" bundle:nil] forCellReuseIdentifier:@"TaskShareCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTaskRemindCell" bundle:nil] forCellReuseIdentifier:@"TaskRemindCell"];
    
}


#pragma mark - button response

- (void) backBtnAction:(id) sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - delegate
#pragma mark UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = (FTTaskShareCell *)[tableView dequeueReusableCellWithIdentifier:@"TaskShareCell"];
        
    }else if (indexPath.section == 1) {
    
        cell = (FTTaskRemindCell *) [tableView dequeueReusableCellWithIdentifier:@"TaskRemindCell"];
    }
    
    return cell;
    
}

#pragma mark UITableVIew Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 380;
    }else {
        return 80;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *footer = [UIView new];
    return footer;
}


#pragma mark - 分享回调

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
            
            NSDate *recordDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults]setObject:recordDate forKey:@"FinishDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RechargeResultNoti object:@"RECHARGE"];
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"积分+1P"];
            
            FTFinishedTaskViewController *finishTaskVC = [FTFinishedTaskViewController new];
            [self.navigationController  pushViewController:finishTaskVC animated:YES];
            
        }else {
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
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
