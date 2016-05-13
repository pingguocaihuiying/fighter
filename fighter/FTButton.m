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
//    CGRect frame  = contentRect;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    
    CGFloat space = self.space;
    CGFloat imageW = self.imageW;
    CGFloat imageH = self.imageH;
    CGFloat imageX;
    CGFloat imageY;
    
    
    switch (self.buttonModel) {
        case FTButtonModelTopImage:
        {
        
            
            CGFloat textH = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
            
            imageX = (width - imageH)/2;
            imageY =  (height-textH - space - self.imageH)/2;
            break;
            
            
        }
           
        case FTButtonModelLeftImage:
        {
           
            CGFloat textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            
            imageX = (width-textW - space - imageW)/2;
            imageY = (height- imageH)/2;
            
            break;
        }
            
        case FTButtonModelBottomImage:
        {
            
            
            CGFloat textH = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
            
            imageX = (width - imageH)/2;
            imageY =  height - (height-textH - space - self.imageH)/2 - imageH;;
            break;
            
            
        }

        case FTButtonModelRightImage:
        {
            CGFloat textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            
            imageX = width - (width-textW - space - imageW)/2 - imageW;
            imageY = (height- imageH)/2;
            break;
        }
            
        case FTButtonModelImage:
            return contentRect;
            break;
        case FTButtonModelTitle:
            return contentRect;
            break;
        case FTButtonModelNone:
            return contentRect;
            break;
            
        default:
        {
            return contentRect;
            break;
        }
            
    }
    
    
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}
//
//2.改变title文字的位置,构造title的矩形即可
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{

    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    
    CGFloat space = self.space;
    CGFloat textW;
    CGFloat textH;
    CGFloat textX;
    CGFloat textY;
    
    
    switch (self.buttonModel) {
        case FTButtonModelTopImage:
        {
            textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            textH = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
            
            textX = (width - textW)/2;
            textY =  height - (height-textH - space - self.imageH)/2 - textH;;
            break;
        }
            
        case FTButtonModelLeftImage:
        {
            
            textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            textH = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
            
            textX = width - (width-textW - space - self.imageW)/2 - textW;
            textY = (height- textH)/2;
            
            break;
        }
            
        case FTButtonModelBottomImage:
        {
            textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            textH = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
            
            textX = (width - textW)/2;
            textY =  (height-textH - space - self.imageH)/2 ;;
            break;
            
        }
            
        case FTButtonModelRightImage:
        {
            CGFloat textW = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
            
            textX = (width-textW - space - self.imageW)/2;
            textY = (height- textH)/2;
            break;
        }
            
        case FTButtonModelImage:
        {
            return contentRect;
        }
            
        case FTButtonModelTitle:
        
        {
            return contentRect;
        }
            
        case FTButtonModelNone:
        {
            return contentRect;
        }
            
            
        default:
            return contentRect;
            break;
    }
    
    
    return CGRectMake(textX, textY, textW, textH);

}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end