//
//  FTVideoCollectionViewCell.m
//  fighter
//
//  Created by Liyz on 5/6/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoCollectionViewCell.h"

@implementation FTVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awake from nib");
    self.cellWidthConstraint.constant = self.cellWidthConstraint.constant * SCALE;
    self.cellHeightConstraint.constant = self.cellHeightConstraint.constant * SCALE;
    self.titleLabelTopConstraint.constant = self.titleLabelTopConstraint.constant * SCALE;
}

- (void)setWithBean:(FTVideoBean *)bean{//根据bean设置cell的显示内容
    
    //设置来源标签的颜色
//    self.fromLabel.textColor = Secondary_Text_Color;
    self.videoLengthLabel.text = bean.videoLength;
    ;

    self.myTitleLabel.text = bean.title;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    
    
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.comentCountLabel.text = commentCount;
    self.voteCount.text = voteCount;
    self.viewCountlabel.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    NSLog(@"videotype : %@", bean.videosType);
    //根据newsType去设置类型图片
    if ([bean.videosType isEqualToString:@"Boxing"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([bean.videosType isEqualToString:@"MMA"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([bean.videosType isEqualToString:@"ThaiBoxing"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-泰拳"];
    }else if ([bean.videosType isEqualToString:@"Taekwondo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-跆拳道"];
    }else if ([bean.videosType isEqualToString:@"Judo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-柔道"];
    }else if ([bean.videosType isEqualToString:@"Wrestling"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-摔跤"];
    }else if ([bean.videosType isEqualToString:@"Sumo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-相扑"];
    }else if ([bean.videosType isEqualToString:@"FemaleWrestling"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-女子格斗"];
    }else{//如果类型不属于这些标签，则不显示
        self.videoTypeImageView.image = nil;
    }
}

@end
