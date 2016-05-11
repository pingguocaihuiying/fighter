//
//  FTButton.m
//  fighter
//
//  Created by kang on 16/5/11.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTButton.h"


@implementation FTButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */

// 自定义的初始化方法
//- (instancetype)initWithFrame:(CGRect)frame
//{
//self = [super initWithFrame:frame];
//if (self)
//{
//
//
//    boundingRect=[self.titleLabel.text boundingRectWithSize:CGSizeMake(320,font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//}
//    return self;
//}
//
////1.重写方法,改变 图片的位置  在  titleRect..方法后执行
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageX=self.frame.size.width/2+boundingRect.size.width/2;
//    UIScreen *s=[UIScreen mainScreen];
//    CGRect rect=s.bounds;
//    CGFloat imageY=contentRect.origin.y+14;
//    CGFloat width=24;
//    CGFloat height=24;
//    return CGRectMake(imageX, imageY, width, height);
//    
//}
//
////2.改变title文字的位置,构造title的矩形即可
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    
//    CGFloat imageX=(self.frame.size.width-boundingRect.size.width)/2;
//    CGFloat imageY=contentRect.origin.y+10;
//    CGFloat width=220;
//    CGFloat height=25;
//    return CGRectMake(imageX, imageY, width, height);
//    
//}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
