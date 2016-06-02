//
//  FTButton.h
//  fighter
//
//  Created by kang on 16/5/11.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FTButtonModel) {
    FTButtonModelNone = 0,   // 系统默认样式
    FTButtonModelLeftImage,  // 图片在左侧
    FTButtonModelRightImage, // 图片在右侧
    FTButtonModelTopImage,   // 图片在上侧
    FTButtonModelBottomImage,// 图片在下侧
    FTButtonModelImage,      // 只有图片
    FTButtonModelTitle,      // 只有文字
};


@interface FTButton : UIButton

@property (nonatomic, assign) CGFloat imageH;//图片高度
@property (nonatomic, assign) CGFloat imageW;//图片宽度

@property (nonatomic, assign) CGFloat textW;//文字高度
@property (nonatomic, assign) CGFloat textH;//文字宽度

@property (nonatomic, assign) CGFloat space; //图片和title的间隔宽度

@property (nonatomic, assign) FTButtonModel buttonModel;//按钮的样式



+ (instancetype) buttonWithType:(UIButtonType)buttonType option:(void(^)(FTButton *button))option;

- (void) setImageAndText:(void(^)(FTButton *button))option;
- (void) setTitle:(NSString *)title forState:(UIControlState)state;

@end