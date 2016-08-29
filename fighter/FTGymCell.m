//
//  FTGymCell.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCell.h"
#import "UIImage+LabelImage.h"

@implementation FTGymCell

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
    
    CGFloat width = SCREEN_WIDTH - 124;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
    
    for (NSString *label in labels) {
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForLabel:label]];
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
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForLabel:label]];
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

- (void) layoutSubviews {
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    
}

@end
