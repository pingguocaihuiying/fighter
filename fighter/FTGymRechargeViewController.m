//
//  FTGymRechargeViewController.m
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymRechargeViewController.h"
#import "WXApi.h"

@interface FTGymRechargeViewController ()

@property (nonatomic, assign) NSInteger rechargeMoney; // 充值金额
@property (nonatomic, assign) CGFloat balance; // 充值金额
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, copy) NSString *membershipId;
@property (nonatomic, copy) NSString *tradeNO;
//@property (nonatomic, copy) NSString *gymId;
@end

@implementation FTGymRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNotification];
    
    [self setNavigationBar];
    
    [self setSubView];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化

- (void) initData {
    _rechargeMoney = 1000;
    
    [self getMembershipInfoFromServer];
    
}


- (void) setNotification {
    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayCallback:) name:WXPayResultNoti object:nil];
    
}

- (void) setNavigationBar {
    
    self.title = @"充值";
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    //导航栏右侧按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setBounds:CGRectMake(0, 0, 50, 14)];
    [cancelButton setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
}


-(void) setSubView {

    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}


#pragma mark - 查询会员信息

- (void) getMembershipInfoFromServer {
    
    if (self.corporationId == 0) {
        return;
    }
    
    NSString *corporationid = [NSString stringWithFormat:@"%ld",self.corporationId];
    [NetWorking getVIPInfoWithGymId:corporationid andOption:^(NSDictionary *dic) {
        NSLog(@"dic:%@",dic);
        
        if (dic == nil) {
            return ;
        }
        
        BOOL status = [dic[@"status"] isEqualToString:@"success"] ?YES:NO;
        if (status) {
            NSDictionary *tempDic = dic[@"data"];
            NSInteger tempId = [tempDic[@"id"] integerValue];
            self.balance = [tempDic[@"money"] integerValue]/100;
            [self.blanceLabel setText:[NSString stringWithFormat:@"%.2f",self.balance]];
            if (tempId != 0) {
                 self.membershipId = [NSString stringWithFormat:@"%ld",tempId];
            }
        }
    }];
}

#pragma mark - response

- (void) backBtnAction: (id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)subButtonAction:(id)sender {
    
    if ((_rechargeMoney - 1000) >0) {
        
        _rechargeMoney  = _rechargeMoney - 1000;
        self.rechargeLabel.text = [NSString stringWithFormat:@"%ld",_rechargeMoney];
    }
}

- (IBAction)addButtonAction:(id)sender {
    
    if ((_rechargeMoney + 1000) <=10000) {
        
        _rechargeMoney  = _rechargeMoney + 1000;
        
        self.rechargeLabel.text = [NSString stringWithFormat:@"%ld",_rechargeMoney];
    }
}

- (IBAction)rechargeButtonAction:(id)sender {
    
    if (self.membershipId == nil || self.membershipId.length == 0) {
        
        return;
    }
    

    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    
    NSString *userId = localUser.olduserid;//发起人id
    
    NSString *objType = @"gym";//类型--拳馆会员充值
    NSString *objId = self.membershipId; //会员信息id
    NSString *tableName = @"pl-gym";//拳馆会员充值
    NSString *isDelated = @"3";//0-无效记录；1-s支付；2-p支付;3-RMB元支付(默认为元)
    NSString *money =  [NSString stringWithFormat:@"%ld",self.rechargeMoney*100];//交易人民币（单位：分）
//        NSString *money =  [NSString stringWithFormat:@"%ld",self.rechargeMoney / 1000];//交易人民币（单位：分）
    NSString *payWay = @"1";//默认为0-积分支付； 值为1-微信支付
    NSString *body = @"拳馆会员充值";//商品描述，需传入应用市场上的APP名字-实际商品名称，天天爱消除-游戏充值，示例：腾讯充值中心-QQ会员充值
    NSString *detail =  [NSString stringWithFormat:@"拳馆会员充值：%ld元",self.rechargeMoney];//商品详情，商品名称明细列表，示例：Ipad mini 16G 白色
    NSString *loginToken = localUser.token;//当前用户的login token
    NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":userId,
                                                                                         @"objType":objType,
                                                                                         @"objId":objId,
                                                                                         @"tableName":tableName,
                                                                                         @"isDelated":isDelated,
                                                                                         @"money":money,
                                                                                         @"payWay":payWay,
                                                                                         @"body":body,
                                                                                         @"detail":detail,
                                                                                         @"loginToken":loginToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahdggrdearyhreayt251grd"];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    
    //把中文参数转码
    [dicBeforeMD5 setValue:[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"body"];
    [dicBeforeMD5 setValue:[detail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"detail"];
    
    NSDictionary *parmamDic = dicBeforeMD5;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking WXpayWithParamDic:parmamDic andOption:^(NSDictionary* dic) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"dic:%@",dic);
        if (dic ==nil) {
            return;
        }
        
        _tradeNO = dic[@"out_trade_no"];
        if (dic && dic.count > 0) {
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = dic[@"partnerid"];
            request.prepayId= dic[@"prepayid"];
            request.package = dic[@"package"];
            request.nonceStr= dic[@"noncestr"];
            request.timeStamp= [dic[@"timestamp"] intValue];
            request.sign= dic[@"sign"];
            [WXApi sendReq:request];
        } else {
            [self.view showMessage:@"下单失败，请稍后再试~"];
        }

    }];

}


- (void) wxPayCallback:(NSNotification *) noti {
    
    NSString *msg = [noti object];
    if ([msg isEqualToString:@"SUCESS"]) {
        
        if (_tradeNO == nil) {
            return;
        }
        
        [NetWorking wxPayStatusWithOrderNO:_tradeNO andOption:^(NSDictionary *dic) {
            
            NSLog(@"dic:%@",dic);
            NSLog(@"message:%@",dic[@"message"]);
            NSString *status = dic[@"status"];
            
            if ([status isEqualToString:@"success"]) {
                
                [self.view showMessage:@"微信支付成功~"];
                //查询余额信息
                [self getMembershipInfoFromServer];
                
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RechargeMoneytNoti object:@"SUCESS"];
                
            }else {
                [self.view showMessage:@"微信支付失败，请稍后再试~"];
            }
        }];
        
    }else {
        NSLog(@"noti:%@",noti);
        [self.view showMessage:@"微信支付失败，请稍后再试~"];

    }
    
}

@end
