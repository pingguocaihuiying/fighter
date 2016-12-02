//
//  FTNavigationBar.m
//  fighter
//
//  Created by kang on 2016/12/2.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTNavigationBar.h"
#import <objc/runtime.h>

@interface FTNavigationBar ()

@end

static char RankButtonKey;
@implementation FTNavigationBar


- (void) setRankButton:(UIButton *) rankButton {
    
    objc_setAssociatedObject(self, &RankButtonKey, rankButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:rankButton];
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIButton *ranBtn = objc_getAssociatedObject(self, &RankButtonKey);
    
    if (ranBtn) {
        // 当前坐标系上的点转换到按钮上的点
        CGPoint btnP = [self convertPoint:point toView:ranBtn];
        
        // 判断点在不在按钮上
        if ([ranBtn pointInside:btnP withEvent:event]) {
            // 点在按钮上
            return ranBtn;
        }else{
            return [self.superview hitTest:point withEvent:event];
        }
    }else {
        
        return [self.superview hitTest:point withEvent:event];
    }
    
}


@end
