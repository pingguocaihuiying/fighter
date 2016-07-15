//
//  FTTeachVideoCell.m
//  fighter
//
//  Created by kang on 16/7/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTeachVideoCell.h"

@implementation FTTeachVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //    NSLog(@"awakeFromNib");
    self.cellWidthConstraint.constant = self.cellWidthConstraint.constant * SCALE;
    self.cellHeightConstraint.constant = self.cellHeightConstraint.constant * SCALE;
    self.titleLabelTopConstraint.constant = self.titleLabelTopConstraint.constant * SCALE;
}

- (void)setWithBean:(FTVideoBean *)bean{//根据bean设置cell的显示内容
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.myTitleLabel setTextColor:Main_Text_Color];
    }else {
        [self.myTitleLabel setTextColor:[UIColor whiteColor]];
    }
    
    //设置来源标签的颜色
    //    self.fromLabel.textColor = Secondary_Text_Color;
    self.videoLengthLabel.text = bean.videoLength;
    ;
    
    self.myTitleLabel.text = bean.title;
    //    NSLog(@"视频list的 cell img%@", bean.img);
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    
    
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.comentCountLabel.text = commentCount;
    self.voteCount.text = voteCount;
    self.viewCountlabel.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    
    if (bean.price) {
        
        if ([bean.price isEqualToString:@"0"]) {
            [self.priceLabel setText:@"免费"];
            return;
        }
        
        [self setBalanceText:[NSString stringWithFormat:@"%@",bean.price]];
    }
    
    //根据newsType去设置类型图片
//    self.priceImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.videosType]];
}

#pragma mark - 显示余额
- (void) setBalanceText:(NSString *) balanceString {
    
    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: balanceString attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:11.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"P" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    
    [self.priceLabel setAttributedText:text];
    
}


@end
