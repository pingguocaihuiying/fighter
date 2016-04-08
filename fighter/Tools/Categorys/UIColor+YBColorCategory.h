//
//  UIColor+YBColorCategory.h
//  Mapbar
//
//  Created by liushuai on 16/1/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YBColorCategory)
+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha;
@end
