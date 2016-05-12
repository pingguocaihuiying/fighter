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



- (CGRect) contentRectForBounds:(CGRect)bounds {

    return bounds;
}


//1.重写方法,改变 图片的位置  在  titleRect..方法后执行
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //1.获取按钮frame
    CGRect frame  = contentRect;
    CGFloat imageX;
    CGFloat imageY;
    
    //2.计算imageframe
    
    switch (self.buttonModel) {
        case FTButtonModelTopImage:
            
            break;
        case FTButtonModelLeftImage:
            
            break;
        case FTButtonModelBottomImage:
            
            break;
        case FTButtonModelRightImage:
            
            break;
        case FTButtonModelImage:
            
            break;
        case FTButtonModelTitle:
            
            break;
        case FTButtonModelNone:
            
            break;
        
        default:
            break;
    }
    
    
    return CGRectMake(imageX, imageY, _imageW, _imageH);
    
}
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
