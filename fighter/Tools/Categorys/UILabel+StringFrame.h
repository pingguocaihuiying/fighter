//
//  UILabel+StringFrame.h
//  Mapbar
//
//  Created by liushuai on 16/2/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;
/**
 *  根据宽度返回自适应行高
 *
 *  @param width 固定宽度
 *
 *  @return 
 */
- (CGSize)boundingRectWithWidth:(CGFloat)width;
@end
