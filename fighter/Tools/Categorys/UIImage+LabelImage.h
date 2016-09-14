//
//  UIImage+LabelImage.h
//  fighter
//
//  Created by kang on 16/8/29.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LabelImage)

+ (UIImage *) imageForLabel:(NSString *)label;


/*
 *  编辑图标
 *  img 需要编辑的原生图片
 *  side 最终图片的最大边长
 */
+ (UIImage *)editImage:(UIImage *)_img  side:(CGFloat) side;


/*
 *  手动实现图片压缩
 *  img 需要编辑的原生图片
 *  imageScale 压缩比例
 */

+ (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale;
@end
