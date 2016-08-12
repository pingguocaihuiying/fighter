//
//  FTLabelCell.m
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLabelCell.h"

@implementation FTLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) labelsViewAdapter:(NSString *) labelsString {
    
    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 124;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
    
    for (NSString *label in labels) {
        
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[self imageForLabel:label]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        if (x + w <= width) {
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }else {
            x = 0;
            y = y + h + 6;
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }
        
        [self.labelsView addSubview:labelView];
    }
    [self.labelsView layoutIfNeeded];
    [self layoutIfNeeded];
}


- (UIImage *) imageForLabel:(NSString *)label {
    
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


- (CGFloat) caculateHeight:(NSString *) labelsString {
    
    if (!labelsString ||labelsString.length == 0)
        return 0;
    
    CGFloat width = SCREEN_WIDTH - 124;
    CGFloat w=0;
    CGFloat h=0;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
    
    for (NSString *label in labels) {
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[self imageForLabel:label]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        if (x + w <= width) {
            x = x + w + 8;
        }else {
            x = 0;
            y = y + h + 6;
            x = x + w + 8;
        }
    }
    
    //    NSLog(@"hhhhhhhhhhhh=%f",h+y);
    if (h + y < 30) {
        return 14;
    }
    return  h + y;
    
}



//- (void) setImgStr:(NSString *)imgStr {
//
//    if (!imgStr || imgStr.length == 0) {
//        return;
//    }
//    _imgStr = imgStr;
//    NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[tempArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"拳馆占位图"]];
//}

- (void) clearLabelView {
    
    for (UIView *view in self.labelsView.subviews) {
        [view removeFromSuperview];
    }
}



@end
