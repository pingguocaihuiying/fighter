//
//  FTCoachCellTableViewCell.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCoachCell.h"

@implementation FTCoachCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) labelsViewAdapter:(NSString *) labelsString {

    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 93;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@", "];
    
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
    [self layoutIfNeeded];
    
}


- (UIImage *) imageForLabel:(NSString *)label {
    
    UIImage *image;
    if ([label isEqualToString:@"Boxing"]) {
        image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([label isEqualToString:@"MMA"]) {
        image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([label isEqualToString:@"ThaiBoxing"]) {
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
    }
    
    return image;
}


- (CGFloat) caculateHeight:(NSString *) labelsString {

    if (!labelsString ||labelsString.length == 0)
        return 0;
    
    CGFloat width = SCREEN_WIDTH - 93;
    CGFloat w=0;
    CGFloat h=0;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@", "];
    
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
        }
    }
    return  h + y;

}



- (void) clearLabelView {
    
    for (UIView *view in self.labelsView.subviews) {
        [view removeFromSuperview];
    }
}



- (void) layoutSubviews {
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    
}



@end
