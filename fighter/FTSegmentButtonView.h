//
//  FTSegmentButtonView.h
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

@protocol FTSegmentButtonViewDelegate <NSObject>

- (void)leftButtonClicked;//左边按钮被点击
- (void)rightButtonClicked;//右边按钮被点击
@optional
- (void)middleButtonClicked;//中间按钮被点击
@end

#import <UIKit/UIKit.h>

@interface FTSegmentButtonView : UIView

@property (nonatomic, weak) id<FTSegmentButtonViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonLeft;
@property (strong, nonatomic) IBOutlet UIButton *buttonMiddle;
@property (strong, nonatomic) IBOutlet UIButton *buttonRight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleButtonWidth;


/**
 设置按钮的个数
    （目前只处理3的传参：显示中间的按钮，并将其宽度设置为100 2016.12.20 by lyz）
 
 @param buttonCount 按钮的个数
 */
- (void)setButtonCount:(int)buttonCount;
@end
