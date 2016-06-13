//
//  FTArenaChooseLabelView.h
//  fighter
//
//  Created by Liyz on 5/24/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTArenaChooseLabelDelegate <NSObject>

- (void)chooseLabel:(NSString *)itemValueEn;

@end

@interface FTArenaChooseLabelView : UIView
@property (nonatomic, weak)id<FTArenaChooseLabelDelegate> delegate;
@property (nonatomic, assign) BOOL isBoxerOrCoach;//如果是拳手或教练，显示“训练”标签
@end
