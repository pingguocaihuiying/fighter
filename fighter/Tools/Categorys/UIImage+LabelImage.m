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

@end
