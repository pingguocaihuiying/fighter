//
//  UIImage+LabelImage.m
//  fighter
//
//  Created by kang on 16/8/29.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "UIImage+LabelImage.h"

@implementation UIImage (LabelImage)

+ (UIImage *) imageForLabel:(NSString *)label {
    
    UIImage *image;
    if ([label isEqualToString:@"拳击"]) {
        image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([label isEqualToString:@"综合格斗(MMA)"]) {
        image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([label isEqualToString:@"泰拳"]) {
        image = [UIImage imageNamed:@"格斗标签-泰拳"];
    }else if ([label isEqualToString:@"跆拳道"]) {
        image = [UIImage imageNamed:@"格斗标签-跆拳道"];
    }else if ([label isEqualToString:@"柔道"]) {
        image = [UIImage imageNamed:@"格斗标签-柔道"];
    }else if ([label isEqualToString:@"摔跤(WWE)"]) {
        image = [UIImage imageNamed:@"格斗标签-摔跤"];
    }else if ([label isEqualToString:@"相扑"]) {
        image = [UIImage imageNamed:@"格斗标签-相扑"];
    }else if ([label isEqualToString:@"女子格斗"]) {
        image = [UIImage imageNamed:@"格斗标签-女子格斗"];
    }else if ([label isEqualToString:@"街斗"]) {
        image = [UIImage imageNamed:@"格斗标签-街斗"];
    }else if ([label isEqualToString:@"其它"]) {
        image = [UIImage imageNamed:@"格斗标签-其他"];
    }else if ([label isEqualToString:@"Match"]) {
        image = [UIImage imageNamed:@"格斗标签-比赛"];
    }
    return image;
}
+ (UIImage *) imageForENLabel:(NSString *)label {
    
    UIImage *image;
    if ([label isEqualToString:@"Boxing"]) {
        image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([label isEqualToString:@"MMA"]) {
        image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([label isEqualToString:@"泰拳"]) {
        image = [UIImage imageNamed:@"格斗标签-泰拳"];
    }else if ([label isEqualToString:@"Taekwondo"]) {
        image = [UIImage imageNamed:@"格斗标签-跆拳道"];
    }else if ([label isEqualToString:@"Judo"]) {
        image = [UIImage imageNamed:@"格斗标签-柔道"];
    }else if ([label isEqualToString:@"Wrestling"]) {
        image = [UIImage imageNamed:@"格斗标签-摔跤"];
    }else if ([label isEqualToString:@"Sumo"]) {
        image = [UIImage imageNamed:@"格斗标签-相扑"];
    }else if ([label isEqualToString:@"FemaleWrestling"]) {
        image = [UIImage imageNamed:@"格斗标签-女子格斗"];
    }else if ([label isEqualToString:@"StreetFight"]) {
        image = [UIImage imageNamed:@"格斗标签-街斗"];
    }else if ([label isEqualToString:@"Others"]) {
        image = [UIImage imageNamed:@"格斗标签-其他"];
    }else if ([label isEqualToString:@"Match"]) {
        image = [UIImage imageNamed:@"格斗标签-比赛"];
    }
    return image;
}

#pragma mark  - 处理图片缩放
/*
 *  编辑图标
 *  img 需要编辑的原生图片
 *  side 最终图片的最大边长
 */
+ (UIImage *)editImage:(UIImage *)_img  side:(CGFloat) side
{
    
   
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (_img.size.width>_img.size.height) {
        
        height = side;
        width = _img.size.width *(height/_img.size.height);
        
    }else{
        
        width = side;
        height= _img.size.height *(width/_img.size.width);
    }
    
    
    CGSize size=CGSizeMake(width,height);
    
    UIGraphicsBeginImageContext(size);
    
    
    CGRect _rect = CGRectMake(0, 0, width, height);
    // 绘制改变大小的图片
    [_img drawInRect:_rect];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    return scaledImage;
}


/*
 *  手动实现图片压缩
 *  img 需要编辑的原生图片
 *  imageScale 压缩比例
 */
+ (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}



@end
