//
//  FTMatchDetailBean.h
//  fighter
//
//  Created by mapbar on 16/8/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTMatchDetailBean : FTBaseBean

@property (nonatomic,copy) NSNumber *incomeCorp;//拳馆收益（%）
@property (nonatomic,copy) NSNumber *theDate;//比赛日期
@property (nonatomic,copy) NSString *gym_location;//拳馆位置
@property (nonatomic,copy) NSNumber *incomeSponsor;//我方收益（%
@property (nonatomic,copy) NSString *updateName;
@property (nonatomic,copy) NSNumber *updateTime;
@property (nonatomic,copy) NSString *updateTimeTamp;
@property (nonatomic,copy) NSString *payType;//支付方式，0-我支付，1-对方支付，2-赢家支付，3-AA支付，4-输家支付，5-赞助支付
@property (nonatomic,copy) NSString *timeSection;//时间
@property (nonatomic,copy) NSString *statu;//0-未开始等待对手，1-比赛进行中，2-已结束
@property (nonatomic,copy) NSNumber *ticket;//门票价格
@property (nonatomic,copy) NSString *createTimeTamp;
@property (nonatomic,copy) NSNumber *incomeAgainst;//对方收益（%）
@property (nonatomic,copy) NSString *payStatu;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *incomePatron;//赞助方收益（%）
@property (nonatomic,copy) NSString *label;//项目
@property (nonatomic,copy) NSNumber *cost;//成本
@property (nonatomic,copy) NSString *levelGap;//重量级差别
@property (nonatomic,copy) NSString *createName;
@property (nonatomic,copy) NSNumber *createTime;
@property (nonatomic,copy) NSString *userName;//发起人姓名
@property (nonatomic,copy) NSNumber *corporationid;//拳馆（部门）id
@property (nonatomic,copy) NSString *corporationName;//拳馆名字
@property (nonatomic,copy) NSString *userId;//发起人userId
@property (nonatomic,copy) NSString *against;//迎战人姓名
@property (nonatomic,copy) NSString *livePrice;//直播价格

@property (nonatomic,copy) NSString *referee;//裁判
@property (nonatomic,copy) NSString *refereeId;//裁判id
@property (nonatomic,copy) NSString *  weight1;//体重
@property (nonatomic,copy) NSString *win1;//胜
@property (nonatomic,copy) NSString *fail1;//败
@property (nonatomic,copy) NSString *draw1;//平
@property (nonatomic,copy) NSString *knockout1;//击倒
@property (nonatomic,copy) NSString *headUrl1;//发起人头像

@end
