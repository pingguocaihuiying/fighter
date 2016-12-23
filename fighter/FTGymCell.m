//
//  FTGymCell.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCell.h"
#import "UIImage+LabelImage.h"
#import "FTLabelView.h"

@implementation FTGymCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setSubviews];
}

- (void) setSubviews {

    // 设置ratingbar
    
    self.ratingBar.imageW = 15;
    self.ratingBar.imageH = 15;
    self.ratingBar.spaceW = 5;
    
    self.ratingBar.halfSelectedImage = [UIImage imageNamed:@"小号的评级星-半"];
    self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"小号的评级星-红"];
    self.ratingBar.unSelectedImage = [UIImage imageNamed:@"小号的评级星-灰"];
    self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [self.ratingBar displayRating:5.0f];
    
    // 设置头像边框
    self.avatarImageView.layer.borderColor = [UIColor colorWithHex:0x2d2d2d].CGColor;
    self.avatarImageView.layer.borderWidth = 0.5;
    
    // 设置labelview 高度
    self.labelViewHeightConstriant.constant = 0;
}



- (void) labelsViewAdapter:(NSString *) labelsString {
    
    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 124;
    CGFloat w=0;
    CGFloat h=16;
    CGFloat x=0;
    CGFloat y=0;
    CGFloat fontSize = 10;
    float spacing = 10;
    NSArray *labels = [labelsString componentsSeparatedByString:@","];
    
    for (NSString *labelstring in labels) {
        

        FTLabelView *labelView = [[FTLabelView alloc]initWithString:labelstring];
        
        
//        UIView *labelView = [UIView new];
//        CGSize labelSize = [labelstring sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
////
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(spacing, (h - fontSize) / 2, spacing * 2 + labelSize.width, fontSize)];
//        label.text = labelstring;
//        label.font = [UIFont systemFontOfSize:fontSize];
//        label.textColor = [UIColor whiteColor];
//        
//        //添加背景图片
//        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(spacing / 2, 0, labelView.width - spacing, labelView.height)];
//        bgImageView.image = [UIImage imageNamed:@"拳种标签2"];
//        
//        labelView.frame = CGRectMake(0, 0, labelSize.width + spacing * 2, h);
//        [labelView addSubview:bgImageView];
//        [labelView sendSubviewToBack:bgImageView];
//        
//        
//        
//        [labelView addSubview:label];
//        //        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForENLabel:label]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        
        if (x + w <= width) {
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 5;
        }else {
            
            x = 0;
            y = y + h + 5;
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }
        
        [self.labelsView addSubview:labelView];
        self.labelViewHeightConstriant.constant = y + h;
    }
    
    
    
    [self.labelsView layoutIfNeeded];
     [self layoutIfNeeded];
}


//- (void) labelsViewAdapter:(NSString *) labelsString {
//    
//    if (!labelsString ||labelsString.length == 0)
//        return;
//    
//    CGFloat width = SCREEN_WIDTH - 30;
//    CGFloat w=0;
//    CGFloat h=21;
//    CGFloat x=0;
//    CGFloat y=0;
//    
//    CGFloat fontSize = 12;
//    
//    NSArray *labels = [labelsString componentsSeparatedByString:@","];
//    //    labels = @[@"如来神掌",@"化骨绵掌",@"降龙十八掌",@"狮子吼",@"形意拳",@"太极拳",@"跆拳道",@"械斗",@"散打",@"泰拳", @"综合格斗"];
//    float spacing = 10;
//    for (NSString *labelStr in labels) {
//        NSString *labelCh = [FTTools getChNameWithEnLabelName:labelStr];
//        UIView *labelView = [UIView new];
//        CGSize labelSize = [labelCh sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(spacing, (h - fontSize) / 2, spacing * 2 + labelSize.width, fontSize)];
//        label.text = labelCh;
//        label.font = [UIFont systemFontOfSize:fontSize];
//        label.textColor = [UIColor whiteColor];
//        labelView.frame = CGRectMake(0, 0, labelSize.width + spacing * 2, h);
//        
//        //添加背景图片
//        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(spacing / 2, 0, labelView.width - spacing, labelView.height)];
//        bgImageView.image = [UIImage imageNamed:@"拳种标签2"];
//        [labelView addSubview:bgImageView];
//        [labelView sendSubviewToBack:bgImageView];
//        
//        [labelView addSubview:label];
//        //        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageForENLabel:label]];
//        w = labelView.frame.size.width;
//        h = labelView.frame.size.height;
//        if (x + w <= width) {
//            labelView.frame = CGRectMake(x, y, w, h);
//            x = x + w;
//        }else {
//            x = 0;
//            y = y + h + 6;
//            labelView.frame = CGRectMake(x, y, w, h);
//            x = x + w;
//        }
//        
//        [self.labelView addSubview:labelView];
//    }
//    //    [self.labelView layoutIfNeeded];
//    //    [self.view layoutIfNeeded];
//    _labelViewHeight.constant = y + h;
//    _topMainViewHeight.constant += _labelViewHeight.constant;
//}



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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
