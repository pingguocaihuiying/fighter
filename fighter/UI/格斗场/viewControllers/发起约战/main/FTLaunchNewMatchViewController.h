//
//  FTLaunchNewMatchViewController.h
//  fighter
//
//  Created by Liyz on 6/29/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
typedef NS_ENUM(NSInteger, FTMatchType) {//匹配类型
    FTMatchTypeFullyMatch = 0,//完全匹配
    FTMatchTypeOverOneLevel,//跨越1级别
    FTMatchTypeOverTwoLevel//跨越2级别
};

typedef NS_ENUM(NSInteger, FTMatchPayMode) {//支付方式
    FTMatchPayModeSelf = 0,//自己支付
    FTMatchPayModeConsult,//协定支付
    FTMatchPayModeOpponent,//对手支付
    FTMatchPayModeSupport,//赞助
};

typedef NS_ENUM(NSInteger, FTMatchConsultPayMode) {//协定支付方式
    FTMatchConsultPayModeWinner = 0,//协定-赢家支付
    FTMatchConsultPayModeAA,//协定-AA付款
    FTMatchConsultPayModeLoser//协定-输家支付
};

@interface FTLaunchNewMatchViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payModeViewHeight;//支付方式view的高度
@property (weak, nonatomic) IBOutlet UIView *consultPayDetailView;//协议支付详情
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;//项目类型
@property (weak, nonatomic) IBOutlet UILabel *selectedGymLabel;//选择的拳馆label
@property (weak, nonatomic) IBOutlet UILabel *opponentLabel;
@property (assign, nonatomic) FTMatchType matchType; //匹配类型
@property (assign, nonatomic) FTMatchPayMode matchPayMode; //支付类型（一级）
@property (assign, nonatomic) FTMatchConsultPayMode matchPayConsultMode; //协议支付具体类型（二级）
@property (weak, nonatomic) IBOutlet UILabel *totalTicketPriceLabel;//门票价格label

@property (nonatomic, assign) NSTimeInterval selectedDateTimestamp;//选中的比赛日期的时间戳
@property (nonatomic, copy) NSString *selectedTimeSectionString;//选中的时间段
@property (nonatomic, copy) NSString *selectedTimeSectionIDString;//选中的时间段id

@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;

@property (nonatomic, copy) NSString *gymSupportedLabelsString;//选择的拳馆支持的项目

@property (nonatomic, copy) NSString *challengedBoxerID;//挑战的拳手ID
@property (nonatomic, copy) NSString *challengedBoxerName;//挑战的拳手名字
@property (nonatomic, copy) NSString *gymName;//拳馆名字
@property (nonatomic, copy) NSString *corporationid;//拳馆corporationid
@property (nonatomic, copy) NSString *ticketPrice;//门票价格
@property (copy, nonatomic) NSString *gymServicePrice;//拳馆使用基础费用

- (void)displayMatchTypeButtons;//刷新匹配级别按钮


@end
