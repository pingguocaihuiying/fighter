//
//  UIView+DividingLine.m
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "UIView+DividingLine.h"

@implementation UIView (DividingLine)

- (void)addTopDividingLine{
    UIView *topDividingLineView = [UIView new];
    topDividingLineView.frame = CGRectMake(0, 0, self.width, 1);
    topDividingLineView.backgroundColor = Cell_Space_Color;
    [self addSubview:topDividingLineView];
}

- (void)addBottomDividingLine{
    UIView *bottomDividingLineView = [UIView new];
    bottomDividingLineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
    bottomDividingLineView.backgroundColor = Cell_Space_Color;
    [self addSubview:bottomDividingLineView];
}

@end
