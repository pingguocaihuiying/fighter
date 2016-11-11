//
//  FTTraineeCell.m
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeCell.h"

@implementation FTTraineeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.avatarImageView.layer setMasksToBounds:YES];
    self.avatarImageView.layer.cornerRadius = self.avatarContraintHeight.constant/2;
}


/**
  根据bean和课程状态设置cell

 @param bean  数据模型
 @param state 课程状态
 */
- (void) setCellWithBean:(FTTraineeBean *)bean  state:(FTTraineeCourseState) courseState{

    NSString *sex = [bean.sex stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sex:%@:",sex);
    if ([bean.sex isEqualToString:@"男性"]) {
        
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage: [UIImage imageNamed:@"学员头像-无头像男"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.avatarMaskImageView.image = [UIImage imageNamed:@"学员头像-有头像男"];
            }
        }];
        
    }else {
        
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage: [UIImage imageNamed:@"学员头像-无头像女"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.avatarMaskImageView.image = [UIImage imageNamed:@"学员头像-有头像女"];
            }
        }];
    }
    self.nameLabel.text = bean.createName;
    
    
    if (courseState == FTTraineeCourseStateComplete) {
        self.markImageView.hidden = YES;
        if (bean.signStatus) {
            self.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-旷课"];
        }else {
            if (bean.hasGrade == 0) {
                self.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-未评分"];
            }else {
                self.traineeStateImageView.image = [UIImage imageNamed:@"学员状态-已评分"];
            }
        }
    }else {
        self.traineeStateImageView.hidden = YES;
        if (bean.newMember == 0) {
            self.markImageView.hidden = YES;
        }
    }
}
@end
