//
//  FTBetView.h
//  fighter
//
//  Created by mapbar on 16/8/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTBetViewDelegate <NSObject>

- (void)betWithBetValues:(int)betValue;

@end

@interface FTBetView : UIView

@property (nonatomic, weak)id<FTBetViewDelegate> delegate;
@property (nonatomic, assign) int betValue;//当前的下注点数

@property (nonatomic, copy) NSString *player1Name;
@property (nonatomic, copy) NSString *player2Name;

//根据对战信息，更新UI显示
- (void)updateDisplay;
@end
