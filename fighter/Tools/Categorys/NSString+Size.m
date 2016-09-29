//
//  NSString+Size.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font height:(CGFloat) height
{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}





@end
