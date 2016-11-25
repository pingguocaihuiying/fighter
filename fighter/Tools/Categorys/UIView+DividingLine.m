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

- (void)addLeftDividingLine{
    UIView *leftDividingLineView = [UIView new];
    leftDividingLineView.frame = CGRectMake(0, 0, 1, self.height);
    leftDividingLineView.backgroundColor = Cell_Space_Color;
    [self addSubview:leftDividingLineView];
}

- (void)addRightDividingLine{
    UIView *rightDividingLineView = [UIView new];
    rightDividingLineView.frame = CGRectMake(self.width - 1, 0, 1, self.height);
    rightDividingLineView.backgroundColor = Cell_Space_Color;
    [self addSubview:rightDividingLineView];
}

- (void)addFrameLine{
    [self addTopDividingLine];
    [self addLeftDividingLine];
    [self addBottomDividingLine];
    [self addRightDividingLine];
}
@end
