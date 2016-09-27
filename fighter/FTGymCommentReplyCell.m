//
//  FTGymCommentReplyCell.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentReplyCell.h"
#import "CellDelegate.h"
#import "NSDate+Tool.h"

@implementation FTGymCommentReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //将多余的部分切掉
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void) setCellContentWithBean:(FTGymCommentBean *)bean {
    
    // 头像
    if (bean.headUrl.length > 0) {
        [self.avatarMask setHidden:NO];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }else {
        [self.avatarMask setHidden:YES];
        [self.avatarImageView setImage:[UIImage imageNamed:@"头像-空"]];
    }
    
    // 用户名
    self.nameLabel.text = bean.createName;
    self.timeLabel.text = [NSDate dateString:bean.createTime];
    
    // 评论文字内容
    self.detailLabel.text = bean.comment;
    
}



@end
