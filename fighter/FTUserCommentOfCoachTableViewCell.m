//
//  FTUserCommentOfCoachTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 21/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserCommentOfCoachTableViewCell.h"
#import "FTCoachsCommentByUserBean.h"
#import "FTRatingBar.h"

@interface FTUserCommentOfCoachTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (strong, nonatomic) IBOutlet UIView *ratingBarContainerView;
@property (strong, nonatomic) IBOutlet FTRatingBar *ratingBar;
@property (strong, nonatomic) IBOutlet UIView *dividingLine;

@end

@implementation FTUserCommentOfCoachTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initRatingBar];
    
    //设置颜色
    _dividingLine.backgroundColor = Cell_Space_Color;
    _topDividingLine.backgroundColor = Cell_Space_Color;
    _bottomDividingLine.backgroundColor = Cell_Space_Color;
}

- (void)initRatingBar{
        _ratingBar = [[FTRatingBar alloc]initWithSpacing:5];
        float ratingBarWidth = 21 * 5 + 5 * 4;
        _ratingBar.frame = CGRectMake(0, 0, ratingBarWidth, 28);
        
        self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
        self.ratingBar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
        self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [_ratingBarContainerView addSubview:_ratingBar];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setWithBean:(FTBaseBean *)bean{
    FTCoachsCommentByUserBean * coachsCommentByUserBean = (FTCoachsCommentByUserBean *)bean;
    _nameLabel.text = coachsCommentByUserBean.studentName;
    _timeLabel.text = coachsCommentByUserBean.timeString;
    _evaluationLabel.text = [self rateString:coachsCommentByUserBean.score];
    [_ratingBar displayRating:coachsCommentByUserBean.score];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:coachsCommentByUserBean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
}
- (NSString *) rateString:(float) rate {
    
    NSString *feedbackString = 0;
    if (rate <= 1) {
        feedbackString = @"真的不怎么样";
    }else if (rate <= 2 && rate > 1) {
        feedbackString = @"感觉差点意思";
    }else if (rate <= 3 && rate > 2) {
        feedbackString = @"还可以啦";
    }else if (rate <= 4 && rate > 3) {
        feedbackString = @"教的不错哦";
    }else if ( rate > 4) {
        feedbackString = @"神级体验，完美无瑕！";
    }
    
    return feedbackString;
}
@end
