//
//  FTMatchBean.h
//  fighter
//
//  Created by Liyz on 25/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTMatchBean : FTBaseBean

@property (nonatomic, copy) NSString  *matchId;//比赛id

@property (nonatomic, copy) NSString  *needPay;//是否需要支付

@property (nonatomic, copy) NSString  *userName;//发起人姓名
@property (nonatomic, copy) NSString  *userId;//发起人id
@property (nonatomic, copy) NSString  *against;//迎战人姓名

@property (nonatomic, copy) NSString  *corporationName;//拳馆名

@property (nonatomic, copy) NSString  *headUrl1;//发起人头像
@property (nonatomic, copy) NSString  *headUrl2;//迎战人头像

@property (nonatomic, copy) NSString  *label;//项目
@property (nonatomic, copy) NSString  *levelGap;//重量级差别

/**
 * 发起人战绩
 */
@property (nonatomic, copy) NSString  *win1;//胜
@property (nonatomic, copy) NSString  *fail1;//败
@property (nonatomic, copy) NSString  *draw1;//平
@property (nonatomic, copy) NSString  *knockout1;//击倒
/**
 * 迎战人战绩
 */
@property (nonatomic, copy) NSString  *win2;//胜
@property (nonatomic, copy) NSString  *fail2;//败
@property (nonatomic, copy) NSString  *draw2;//平
@property (nonatomic, copy) NSString  *knockout2;//击倒

@property (nonatomic, copy) NSString  *timeSection;//时间，如：9:00~11:00（注意原型图上需要开始时间，需分割，取”~”前部分）

@property (nonatomic, copy) NSString  *weight1;// 发起人体重
@property (nonatomic, copy) NSString  *weight2;// 迎战人体重

@property (nonatomic, copy) NSString  *referee;//裁判
@property (nonatomic, copy) NSString  *refereeId;//裁判用户编号（olduserid）
@property (nonatomic, copy) NSString  *payStatu;// = '0';//0-等待支付，1-完成支付  。//(更新时使用，保存时默认为0，注：拳手新添加完成赛事，保存成功后，若需他支付费用 ，即payType为0、2、3、4，则跳转支付，走支付接口)
@property (nonatomic, copy) NSString  *statu;// = '0';//0-等待对手，1-对手已迎战&等待开赛，2-比赛进行中，3-比赛结束，4-对手拒绝迎战
@property (nonatomic, copy) NSString  *payType;//支付方式，0-我支付，1-对方支付，2-赢家支付，3-AA支付，4-输家支付，5-赞助支付

@property (nonatomic,copy) NSString *url;//直播链接

@property (nonatomic,copy) NSString *urlPre;//赛前宣传链接

@property (nonatomic,copy) NSString *urlRes;//赛后结果链接follow
@property (nonatomic, assign) BOOL follow;//是否关注
@property (nonatomic,copy) NSString *theDate;//比赛时间戳
@end
