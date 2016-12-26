//
//  FTPracticeViewController.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPracticeViewController.h"
#import "FTSegmentedControl.h"
#import "FTPracticeView.h"
#import "FTCoachView.h"
#import "FTGymView.h"
#import "FTMembershipGymView.h"
#import "FTRankViewController.h"
#import "FTGymDetailWebViewController.h"
#import "FTOrderCoachViewController.h"

@interface FTPracticeViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)  FTPracticeView *practiceView;
@property (strong, nonatomic)  FTCoachView *coachView;
@property (strong, nonatomic)  FTGymView *gymView;
@property (strong, nonatomic)  FTMembershipGymView *membershipGymView;

@property (weak, nonatomic) IBOutlet UIButton *teachBtn;

@property (weak, nonatomic) IBOutlet UIButton *coachBtn;

@property (weak, nonatomic) IBOutlet UIButton *gymBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coachBtnWidthConstraint;

@end

@implementation FTPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    [self setNotification];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark  - setup

- (void) setNotification {
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMemberGyms:) name:ShowMemberShipGymsNavNoti object:nil];
    
    // 注册通知，监听应用内跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchDetailAction:) name:SwitchPracticeDetailNoti object:nil];
    
}

- (void) initSubviews {

    [self setsubViewsState];
}

- (void) setsubViewsState {
    
    FTUserBean *loginUser = [FTUserBean loginUser];
    if (loginUser.isGymUser.count > 0) {
        
//        self.coachBtnWidthConstraint.constant = 0;
//        [self coachBtnAction:nil];
        
        [self.gymBtn setTitle:@"我的拳馆" forState:UIControlStateNormal];
        [self.gymBtn setTitle:@"我的拳馆" forState:UIControlStateSelected];
        [self gymBtnAction:nil];
    }else {
        [self.gymBtn setTitle:@"拳馆列表" forState:UIControlStateNormal];
        [self.gymBtn setTitle:@"拳馆列表" forState:UIControlStateSelected];
        
        self.coachBtnWidthConstraint.constant = 0;
        [self teachBtnAction:nil];
    }
}

/**
 教学视频
 */
- (void) initPracticeView {
    
    if (!_practiceView) {
        _practiceView = [[FTPracticeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _practiceView.delegate = self;
    }
    
    [self.contentView addSubview:_practiceView];
}


/**
 教练
 */
- (void) initCoachView {

    if (!_coachView) {
        _coachView = [[FTCoachView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _coachView.delegate = self;
    }
    
    [self.contentView addSubview:_coachView];
    
}


/**
 我的拳馆
 */
- (void) initMembershipGymView {
    
    if (!_membershipGymView) {
        _membershipGymView = [[FTMembershipGymView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _membershipGymView.delegate = self;
    }
    
    [self.contentView addSubview:_membershipGymView];
}

/**
 拳馆
 */
- (void) initGymView {
    
    if (!_gymView) {
        _gymView = [[FTGymView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _gymView.delegate = self;
    }
    
    [self.contentView addSubview:_gymView];
    
}


#pragma mark - delegate
- (void)pushToController:(UIViewController *)viewController {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - response

- (IBAction)teachBtnAction:(id)sender {
    
//    _teachBtn.enabled = NO;
    _teachBtn.selected = YES;
    
    _coachBtn.selected = NO;
    _coachBtn.enabled = YES;
    
    _gymBtn.selected = NO;
    _gymBtn.enabled = YES;
    
    
    [self initPracticeView];
    
    [_membershipGymView removeFromSuperview];
    [_gymView removeFromSuperview];
}

- (IBAction)coachBtnAction:(id)sender {
    
    _teachBtn.enabled = YES;
    _teachBtn.selected = NO;
    
    _coachBtn.selected = YES;
//    _coachBtn.enabled = NO;
    
    _gymBtn.selected = NO;
    _gymBtn.enabled = YES;
    
//    [self initCoachView];
    [self initMembershipGymView];
    
    [_practiceView removeFromSuperview];
    [_gymView removeFromSuperview];
}

- (IBAction)gymBtnAction:(id)sender {
    
    _teachBtn.enabled = YES;
    _teachBtn.selected = NO;
    
    _coachBtn.selected = NO;
    _coachBtn.enabled = YES;
    
    _gymBtn.selected = YES;
//    _gymBtn.enabled = NO;
    
    FTUserBean *loginUser = [FTUserBean loginUser];
    if (loginUser.isGymUser.count > 0) {
        [self initMembershipGymView];
        
        [_practiceView removeFromSuperview];
        [_gymView removeFromSuperview];
        
    }else {
        [self initGymView];
        
        [_practiceView removeFromSuperview];
        [_membershipGymView removeFromSuperview];
    }


    
}


// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self setsubViewsState];
    }
}


#pragma mark - get data from web

- (void) showMemberGyms:(NSNotification *) noti {

    FTUserBean *loginUser = [FTUserBean loginUser];
    
    if (loginUser) {
        
        if (loginUser.isGymUser == nil || loginUser.isGymUser.count == 0) {
            [self getMembershipGymsFromWeb];
        }
    }
}

// 获取tableView 数据
- (void) getMembershipGymsFromWeb {
    
    NSString *showType  = [FTNetConfig showType];
    
    NSString *gymTag = @"1";
    NSString *gymType = @"ALL";
    NSString *gymCurrId = @"-1";
    NSString *getType = @"new";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:gymType forKey:@"gymType"];
    [dic setObject:gymCurrId forKey:@"gymCurrId"];
    [dic setObject:gymTag forKey:@"gymTag"];
    [dic setObject:getType forKey:@"getType"];
    [dic setObject:showType forKey:@"showType"];
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    [dic setObject:userId forKey:@"userId"];
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",gymType,gymCurrId,gymTag, getType, ts, @"quanjijia222222"]];
    
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [NetWorking getMemberGymsByDic:dic option:^(NSDictionary *dict) {
        
        SLog(@"table dic:%@",dict);
        SLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (dict == nil) {
            return ;
        }
        
        if ([dict[@"status"] isEqualToString:@"error"]) {
            return ;
        }
        
        NSArray *tempArray = dict[@"data"];
        if (tempArray.count > 0) {
            FTUserBean *loginuser = [FTUserBean loginUser];
            self.coachBtnWidthConstraint.constant = 100;
            
            for (int i = 0; i < tempArray.count ; i++) {
                
                NSNumber *memberShipGymId = [NSNumber numberWithInteger:[dict[@"corporationid"] integerValue]];
                
                if (![loginuser.isGymUser containsObject:memberShipGymId]) {
                   loginuser.isGymUser=  [NSArray arrayWithObject:memberShipGymId];
                }
                
                //将用户信息保存在本地
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginuser];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        
    }];
}

#pragma mark - 推送方法

#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic {
    
}

#pragma mark - 通知
- (void) switchDetailAction:(NSNotification *) noti {
    
    NSDictionary *dic = noti.userInfo;
    if (dic != nil) {
        NSString *type = dic[@"type"];
        
        FTUserBean *loginUser = [FTUserBean loginUser];
        BOOL isCoach = NO;
        if (loginUser) {
            for (NSDictionary *identityDic in loginUser.identity) {
                if ([identityDic[@"itemValueEn"] isEqualToString:@"coach"]) {
                    if (loginUser.corporationid) {
                        isCoach = YES;
                    }
                    break;
                }
            }
        }
        
        if ([type isEqualToString:@"gym"]){
             // 如果不是教练身份才跳转到拳馆详情界面
            if (!isCoach) {
                NSInteger corporationid = [dic[@"corporationid"] integerValue];
                FTGymBean *bean = [FTGymBean new];
                bean.corporationid = corporationid;
                
                FTGymDetailWebViewController *gymDetailWebViewController = [FTGymDetailWebViewController new];
                gymDetailWebViewController.gymBean = bean;
                [self.navigationController pushViewController:gymDetailWebViewController animated:YES];
            }
            
        }else if([type isEqualToString:@"coach"]){
            
            // 如果不是教练身份才跳转到教练约课界面
            if (!isCoach) {
                
                NSString *coachId = dic[@"coachId"];
                FTCoachBean *coachBean = [FTCoachBean new];
                coachBean.userId = coachId;
                
                FTOrderCoachViewController *orderCoachViewController = [FTOrderCoachViewController new];
                orderCoachViewController.coachBean = coachBean;
                [self.navigationController pushViewController:orderCoachViewController animated:YES];
            }
            
        }else if ([type isEqualToString:@"video"]){
            
        }
    }
}

@end
