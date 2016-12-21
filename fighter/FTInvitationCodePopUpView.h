//
//  FTInvitationCodePopUpView.h
//  fighter
//
//  Created by kang on 2016/12/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FTMemberType) {
 
    FTMemberTypeMoney,   // 余额会员
    FTMemberTypeTimes,   // 次卡会员
    FTMemberTypeDate     // 日期会员
};


typedef void(^DismissSuperControllerBlock)();

/**
 邀请码弹出框
 */
@interface FTInvitationCodePopUpView : UIView

@property (nonatomic, copy) NSString *gymName;
@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *times;    //次卡会员剩余次数
@property (nonatomic, copy) NSString *deadline; // 日期会员截止日期
@property (nonatomic, copy) NSString *balance;  // 余额会员的余额

@property (nonatomic, assign) FTMemberType memberType;

@property (nonatomic, strong) NSMutableDictionary *notificationDic;

@property (nonatomic, copy) DismissSuperControllerBlock dismissBlock;
@end
