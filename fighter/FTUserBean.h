//
//  User.h
//  renzhenzhuan
//
//  Created by Liyz on 4/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTBaseBean.h"

@interface FTUserBean : FTBaseBean<NSCoding>
//@property (nonatomic, copy)NSString *uid;
//@property (nonatomic, copy)NSString *tel;
//@property (nonatomic, copy)NSString *username;
//@property (nonatomic, copy)NSString *realname;
//@property (nonatomic, copy)NSString *token;
//@property (nonatomic, copy)NSString *password;
//@property (nonatomic, copy)NSString *headpic;
//@property (nonatomic, copy)NSString *stemfrom;
//@property (nonatomic, copy)NSString *olduserid;
//@property (nonatomic, copy)NSString *telmodel;
//@property (nonatomic, copy)NSString *email;
//@property (nonatomic, copy)NSString *remorks;
//@property (nonatomic, copy)NSString *lastlogintime;
//@property (nonatomic, copy)NSString *imei;

@property (nonatomic,copy) NSString *userid;//用于个人主页关注、取消关注
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *unionId;
@property (nonatomic,copy) NSString *openId;
@property (nonatomic,copy) NSString *olduserid;
@property (nonatomic,copy) NSString *registertime;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *imei;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *cardType;
@property (nonatomic,copy) NSString *stemfrom;
@property (nonatomic,copy) NSString *wxopenId;

@property (nonatomic,copy) NSString *telmodel;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *lastModifyName;
@property (nonatomic,copy) NSString *effect;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *remorks;
@property (nonatomic,copy) NSString *unionuserid;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *headpic;//头像
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *lastlogintime;
@property (nonatomic,copy) NSString *username;

@property (nonatomic, copy) NSArray *interestList;
@property (nonatomic, copy) NSArray *isGymUser;
//更新字段
@property (nonatomic,copy) NSString *height;//身高
@property (nonatomic,copy) NSString *weight;//体重
@property (nonatomic,copy) NSString *address;//地址，归属地

//微信
@property (nonatomic, copy) NSString *wxHeaderPic;//微信头像
@property (nonatomic, copy) NSString *wxName;//微信昵称
//@property (nonatomic, copy) NSString *wxToken;//

/**
 *  个人主页新增的字断，没有进行归档 
 */
@property (nonatomic, copy)NSString *followCount;//关注数
@property (nonatomic, copy)NSString *fansCount;//粉丝数
@property (nonatomic, copy)NSString *dynamicCount;//动态数
@property (nonatomic, copy)NSString *name;//name
@property (nonatomic, copy)NSString *background;//个人用户目前没有;//背景图
@property (nonatomic, copy)NSArray* identity;//身份（服务器传来一个数组，自己遍历查身份）


@property (nonatomic, copy)NSString* headUrl;//头像
@property (nonatomic, copy)NSString *query;//身份标识
@property (nonatomic, copy)NSString *brief;//简介
@property (nonatomic, strong)NSArray *boxerRaceInfos;//赛事信息
@property (nonatomic, copy)NSString *standings;//战绩 
@property (nonatomic, copy)NSString *boxerId;//拳手id
@property (nonatomic, copy)NSString *coachId;//教练id
@property (nonatomic, copy)NSString *win;//胜场
@property (nonatomic, copy)NSString *fail;//负场
@property (nonatomic, copy)NSString *draw;//打平场数
@property (nonatomic, copy)NSString *knockout;//击倒数

@property (nonatomic, assign) NSString *isBoxerChecked;

// 拳馆相关字段
@property (nonatomic, copy)NSString *corporationid;

//计算年龄
- (NSString *) age;
//格式化生日
- (NSString *) formaterBirthday;

+ (FTUserBean *) loginUser;

/**
 返回用户userId
 */
+ (NSString *) userId;

/**
 判断用户是否是教练
 */
+ (BOOL) isCoach;
@end
