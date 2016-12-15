//
//  FTButton.m
//  fighter
//
//  Created by kang on 16/5/11.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTButton.h"


@implementation FTButton
@synthesize imageW = _imageW;
@synthesize imageH = _imageH;
@synthesize space = _space;
@synthesize buttonModel = _buttonModel;

@synthesize textW = _textW;
@synthesize textH = _textH;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
#pragma mark - init


+ (instancetype) buttonWithType:(UIButtonType)buttonType option:(void(^)(FTButton *button))option {

    
    FTButton *button = [super buttonWithType:buttonType];
    if (button) {
       
        if (option) {
            __weak FTButton *weakSelf = button;
            option(weakSelf);
            
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
        }
    }
    
    return button;
    
}


+ (instancetype) buttonWithType:(UIButtonType)buttonType {
    
    FTButton *button = [super buttonWithType:buttonType];
    if (button) {
//        button.spaceBetweenImageAndText = 0;
    }
    
    return button;
}

+ (FTButton *) buttonWithtitle:(NSString *)title {
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    FTButton *selectBtn = [FTButton buttonWithType:UIButtonTypeCustom option:^(FTButton *button) {
        
        button.imageH = 10;
        button.imageW = 13;
        button.buttonModel = FTButtonModelRightImage;
        button.space = 10.0;
        button.bounds = CGRectMake(0, 0, buttonW, 40);
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:Main_Text_Color forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头pre"] forState:UIControlStateHighlighted];
        
        CGSize size =  [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        
        if (size.width > buttonW - 30-10-13) {
            size = CGSizeMake(buttonW - 30-10-13, size.height);
        }
        
        button.textH = size.height;
        button.textW = size.width;
        
    }];
    
    return selectBtn;
}



#pragma mark - set

- (void) setImageAndText:(void(^)(FTButton *button))option {

    if (option) {
        __weak __typeof(&*self)weakSelf = self;
        option(weakSelf);
    }
}


- (void) setTitle:(NSString *)title forState:(UIControlState)state {
    
    CGSize size =  [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    if (size.width > self.frame.size.width - 30-10-13) {
        size = CGSizeMake(self.frame.size.width - 30-10-13, size.height);
    }
    _textH = size.height;
    _textW = size.width;
    
    [super setTitle:title forState:state];
}




#pragma mark - overwrite

- (void) layoutSubviews {
    
    [super layoutSubviews];
//    NSLog(@"layoutSubViews");
    CGSize size =  [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];

    if (size.width > self.frame.size.width - 30-10-13) {
        size = CGSizeMake(self.frame.size.width - 30-10-13, size.height);
    }

    _textH = size.height;
    _textW = size.width;
}




- (CGRect) contentRectForBounds:(CGRect)bounds {
    
//    NSLog(@"contentRectForBounds(%f,%f,%f,%f)",bounds.origin.x,bounds.origin.y,bounds.size.width ,bounds.size.height);
    
    return bounds;
}


//1.重写方法,改变 图片的位置  在  titleRect..方法后执行
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
//    NSLog(@"imageRectForContentRect(%f,%f,%f,%f)",contentRect.origin.x,contentRect.origin.y,contentRect.size.width ,contentRect.size.height);
    //1.获取按钮frame
//    CGRect frame  = contentRect;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    
    CGFloat space = _space;
    CGFloat imageW = _imageW;
    CGFloat imageH = _imageH;
    CGFloat imageX;
    CGFloat imageY;
    
//    NSLog(@"imageW:%f",_imageW);
//    NSLog(@"imageH:%f",_imageH);
    
    switch (_buttonModel) {
        case FTButtonModelTopImage:
        {
        
            imageX = (width - imageH)/2;
            imageY =  (height-_textH - space - _imageH)/2;
            break;
        }
           
        case FTButtonModelLeftImage:
        {
            imageX = (width-_textW - space - imageW)/2;
            imageY = (height- imageH)/2;
            break;
        }
            
        case FTButtonModelBottomImage:
        {
            imageX = (width - imageH)/2;
            imageY =  height - (height-_textH - space - _imageH)/2 - imageH;;
            break;
        }

        case FTButtonModelRightImage:
        {
            
            imageX = width - (width-_textW - space - imageW)/2 - imageW;
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
    
//    NSLog(@"imageRect(%f,%f,%f,%f)",imageX,imageY,imageW,imageH);
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}
//
//2.改变title文字的位置,构造title的矩形即可
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//     NSLog(@"titleRectForContentRect(%f,%f,%f,%f)",contentRect.origin.x,contentRect.origin.y,contentRect.size.width ,contentRect.size.height);

//    NSLog(@"textW:%f",_textW);
//    NSLog(@"textH:%f",_textH);
    
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    
    CGFloat space = _space;;
    
    CGFloat textX;
    CGFloat textY;
    
    
    switch (_buttonModel) {
        case FTButtonModelTopImage:
        {
            textX = (width - _textW)/2;
            textY =  height - (height-_textH - space - _imageH)/2 - _textH;;
            break;
        }
            
        case FTButtonModelLeftImage:
        {
            textX = width - (width-_textW - space - _imageW)/2 - _textW;
            textY = (height- _textH)/2;
            
            break;
        }
            
        case FTButtonModelBottomImage:
        {
            
            textX = (width - _textW)/2;
            textY =  (height- _textH - space - _imageH)/2 ;;
            break;
            
        }
            
        case FTButtonModelRightImage:
        {
            textX = (width- _textW - space - _imageW)/2;
            textY = (height- _textH)/2;
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
    
    
//    NSLog(@"textRect(%f,%f,%f,%f)",textX,textY,_textW,_textH);
    return CGRectMake(textX, textY, _textW, _textH);

}

- (void)drawRect:(CGRect)rect {
//    NSLog(@"drawRect");
    
}


@end
