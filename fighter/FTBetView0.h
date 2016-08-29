//
//  FTBetView0.h
//  fighter
//
//  Created by 李懿哲 on 16/8/29.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTMatchBean.h"

@protocol FTBetViewDelegate0 <NSObject>

/**
 *  下注
 *
 *  @param betValue 下注数（单位p）
 */
- (void)betStep1WithBetValues:(int)betValue andIsPlayer1Win:(BOOL )isPlayer1Win andMatchBean:(FTMatchBean *)matchBean;


- (void)pushToRechargeVC;

@end

@interface FTBetView0 : UIView


@property (nonatomic, strong) FTMatchDetailBean *matchDetailBean;
@property (nonatomic, strong) FTMatchBean *matchBean;
@property (nonatomic, weak)id<FTBetViewDelegate0> delegate;
@property (nonatomic, assign) int betValue;//当前的下注点数

@property (nonatomic, assign) BOOL isbetPlayer1Win;

//根据对战信息，更新UI显示
- (void)updateDisplay;

@end
