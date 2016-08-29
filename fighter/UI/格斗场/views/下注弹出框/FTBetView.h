//
//  FTBetView.h
//  fighter
//
//  Created by mapbar on 16/8/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTMatchBean.h"

@protocol FTBetViewDelegate <NSObject>

/**
 *  下注
 *
 *  @param betValue 下注数（单位p）
 */
- (void)betWithBetValues:(int)betValue andIsPlayer1Win:(BOOL )isPlayer1Win;


- (void)pushToRechargeVC;

@end

@interface FTBetView : UIView

@property (nonatomic, strong) FTMatchBean *matchBean;

@property (nonatomic, weak)id<FTBetViewDelegate> delegate;
@property (nonatomic, assign) int betValue;//当前的下注点数

@property (nonatomic, copy) NSString *player1Name;
@property (nonatomic, copy) NSString *player2Name;

@property (nonatomic, assign) BOOL isbetPlayer1Win;

//根据对战信息，更新UI显示
- (void)updateDisplay;
@end
