//
//  FTDrawerCollectionCell.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerCollectionCell.h"
#import "NSString+Size.h"
#import "Masonry.h"

@implementation FTDrawerCollectionCell




- (void) setBackImgView {
    
    _backImgView = [[UIImageView alloc]initWithImage:[self setBackImageWithTpye:self.fightType]];
    [self addSubview:_backImgView];
}

//- (CGFloat) setCellWidth {
//    
//    CGFloat width;
//    switch (type) {
//        case 0:
//            width = 50;
//            image = [UIImage imageNamed:@"格斗标签-综合格斗"];
//            break;
//        case 1:
//            image = [UIImage imageNamed:@"格斗标签-拳击"];
//            break;
//        case 2:
//            image = [UIImage imageNamed:@"格斗标签-摔跤"];
//            break;
//        case 3:
//            image = [UIImage imageNamed:@"格斗标签-女子格斗"];
//            break;
//        case 4:
//            image = [UIImage imageNamed:@"格斗标签-泰拳"];
//            break;
//        case 5:
//            image = [UIImage imageNamed:@"格斗标签-跆拳道"];
//            break;
//        case 6:
//            image = [UIImage imageNamed:@"格斗标签-柔道"];
//            break;
//        case 7:
//            image = [UIImage imageNamed:@"格斗标签-相扑"];
//            break;
//        case 8:
//            image = [UIImage imageNamed:@"格斗标签-截拳道"];
//            break;
//        case 9:
//            image = [UIImage imageNamed:@"格斗标签-散打"];
//            break;
//        case 10:
//            image = [UIImage imageNamed:@"格斗标签-空手道"];
//            break;
//        case 11:
//            image = [UIImage imageNamed:@"格斗标签-自由搏击"];
//            break;
//        case 12:
//            image = [UIImage imageNamed:@"格斗标签-相扑"];
//            break;
//        default:
//            break;
//    }
//}
- (UIImage *) setBackImageWithTpye:(NSInteger)type {

    UIImage *image;
    
    switch (type) {
        case 0:
            image = [UIImage imageNamed:@"格斗标签-综合格斗"];
            break;
        case 1:
            image = [UIImage imageNamed:@"格斗标签-拳击"];
            break;
        case 2:
            image = [UIImage imageNamed:@"格斗标签-摔跤"];
            break;
        case 3:
            image = [UIImage imageNamed:@"格斗标签-女子格斗"];
            break;
        case 4:
            image = [UIImage imageNamed:@"格斗标签-泰拳"];
            break;
        case 5:
            image = [UIImage imageNamed:@"格斗标签-跆拳道"];
            break;
        case 6:
            image = [UIImage imageNamed:@"格斗标签-柔道"];
            break;
        case 7:
            image = [UIImage imageNamed:@"格斗标签-相扑"];
            break;
        case 8:
            image = [UIImage imageNamed:@"格斗标签-截拳道"];
            break;
        case 9:
            image = [UIImage imageNamed:@"格斗标签-散打"];
            break;
        case 10:
            image = [UIImage imageNamed:@"格斗标签-空手道"];
            break;
        case 11:
            image = [UIImage imageNamed:@"格斗标签-自由搏击"];
            break;
        case 12:
            image = [UIImage imageNamed:@"格斗标签-相扑"];
            break;
        default:
            break;
    }
    return image;
}

- (void) layoutLabel {
    
}


- (void) layoutSubviews {

    
}

- (void) drawRect:(CGRect)rect {
    
    
}
@end
