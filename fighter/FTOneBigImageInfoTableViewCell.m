//
//  FTOneBigImageInfoTableViewCell.m
//  fighter
//
//  Created by Liyz on 4/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTOneBigImageInfoTableViewCell.h"

@implementation FTOneBigImageInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithBean:(FTNewsBean *)bean{
    //设置来源标签的颜色
    self.fromLabel.textColor = Secondary_Text_Color;
    
    if (SCREEN_WIDTH == 320) {
//        self.titleLabelWidth.constant = SCREEN_WIDTH - 50;
    }
    self.fromLabel.text = [NSString stringWithFormat:@"来源：%@", bean.author];
    
    NSString *newsTime = bean.newsTime;
    newsTime = [newsTime substringToIndex:newsTime.length - 3];
    NSTimeInterval timeInterval = [newsTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [self fixStringForDate:date];
    self.timeLabel.text = timeString;
    self.timeLabel.textColor = Secondary_Text_Color;
    self.myTitleLabel.text = bean.title;
    
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img_big]];
//    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img_big]];
    
    //设置评论数、点赞数
    NSString *commentCount = [NSString stringWithFormat:@"%@", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"%@", bean.voteCount];
    self.numOfCommentLabel.text = commentCount;
    self.numOfthumbLabel.text = voteCount;
    
    //根据newsType去设置类型图片
    if ([bean.newsType isEqualToString:@"Boxing"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([bean.newsType isEqualToString:@"MMA"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([bean.newsType isEqualToString:@"ThaiBoxing"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-泰拳"];
    }else if ([bean.newsType isEqualToString:@"Taekwondo"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-跆拳道"];
    }else if ([bean.newsType isEqualToString:@"Judo"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-柔道"];
    }else if ([bean.newsType isEqualToString:@"Wrestling"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-摔跤"];
    }else if ([bean.newsType isEqualToString:@"Sumo"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-相扑"];
    }else if ([bean.newsType isEqualToString:@"FemaleWrestling"]) {
        self.newsTypeImageView.image = [UIImage imageNamed:@"格斗标签-女子格斗"];
    }
}
- (NSString *)fixStringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}
@end
