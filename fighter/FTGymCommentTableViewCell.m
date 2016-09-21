//
//  FTGymCommentTableViewCell.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentTableViewCell.h"
#import "FTGymCommentBean.h"

typedef NS_ENUM(NSInteger, GymCommentState) {
    GymCommentStateComfort,
    GymCommentStateStrength,
    GymCommentStateTeachLevel,
};


@interface FTGymCommentTableViewCell()
{
    
    
}

@end

@implementation FTGymCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.CollectionHeightConstraint.constant = 0;
    
    //将多余的部分切掉
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
    
//    self.comfortArray = @[_comfortImage1,
//                          _comfortImage2,
//                          _comfortImage3,
//                          _comfortImage4,
//                          _comfortImage5];
//    
//    self.strengthArray = @[_strengthImage1,
//                           _strengthImage2,
//                           _strengthImage3,
//                           _strengthImage4,
//                           _strengthImage5];
//    
//    self.levelArray = @[_levelImage1,
//                        _levelImage2,
//                        _levelImage3,
//                        _levelImage4,
//                        _levelImage5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setImageToIndex:(int) index  levelTag:(GymCommentState) gymCommentState {
    
    NSArray *array = nil;
    switch (gymCommentState) {
        case GymCommentStateComfort:{
            array = @[_comfortImage1,
                      _comfortImage2,
                      _comfortImage3,
                      _comfortImage4,
                      _comfortImage5];
        }
            break;
        case GymCommentStateStrength: {
            array = @[_strengthImage1,
                       _strengthImage2,
                       _strengthImage3,
                       _strengthImage4,
                       _strengthImage5];
        }
            break;
        case GymCommentStateTeachLevel:{
            array = @[_levelImage1,
                    _levelImage2,
                    _levelImage3,
                    _levelImage4,
                    _levelImage5];

        }
        default:
            break;
    }
    
    for (int i = index-1; i >= 0 ; i--) {
        UIImageView *imageView = [array objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-红"]];
    }
    
    for (int i = index; i < 5 ; i++) {
        UIImageView *imageView = [array objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-灰"]];
    }
}

- (void) setCellContentWithBean:(FTGymCommentBean *)bean {

    self.commentbean = bean;
    [self getThumbState];
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
    
    // 评论文字内容
    self.detailLabel.text = bean.comment;
    
    // 评分图示
    [self setImageToIndex:bean.comfort levelTag:GymCommentStateComfort];
    [self setImageToIndex:bean.strength levelTag:GymCommentStateStrength];
    [self setImageToIndex:bean.teachLevel levelTag:GymCommentStateTeachLevel];
    
    // 评论数
    if (bean.commentcount > 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"(%d)",bean.commentcount] forState:UIControlStateNormal];
    }
    
    // 点赞数
    if (bean.thumbCount > 0) {
        [self.thumbsButton setTitle:[NSString stringWithFormat:@"(%d)",bean.thumbCount] forState:UIControlStateNormal];
    }
    
    
    
}

- (void) getThumbState {

    [NetWorking getVoteStatusWithObjid:[NSString stringWithFormat:@"%d",self.commentbean.id] andTableName:@"" andOption:^(BOOL result) {
        
        if (result) {
            [self.thumbsButton setImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
        }else {
            [self.thumbsButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        }
    }];
    
}

@end
