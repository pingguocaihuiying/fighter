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
//    NSLog(@"awakeFromNib");
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
    NSLog(@"视频list的 cell img%@", bean.img);
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    
    
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.comentCountLabel.text = commentCount;
    self.voteCount.text = voteCount;
    self.viewCountlabel.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    
    //根据newsType去设置类型图片
    self.videoTypeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.videosType]];
}

@end
