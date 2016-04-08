//
//  UIView+YBAddtitions.h
//  Mapbar
//
//  Created by liushuai on 16/1/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YBAddtitions)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

@property (nonatomic,readonly) CGFloat leftInBounds;

@property (nonatomic,readonly) CGFloat topInBounds;

@property (nonatomic,readonly) CGFloat rightInBounds;

@property (nonatomic,readonly) CGFloat bottomInBounds;

@property (nonatomic,readonly) CGFloat centerXInBounds;

@property (nonatomic,readonly) CGFloat centerYInBounds;
@end
