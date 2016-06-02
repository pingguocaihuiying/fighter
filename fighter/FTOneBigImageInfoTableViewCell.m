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
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithBean:(FTNewsBean *)bean{
    
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.myTitleLabel setTextColor:Main_Text_Color];
    }else {
        [self.myTitleLabel setTextColor:[UIColor whiteColor]];
    }
    
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
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.numOfCommentLabel.text = commentCount;
    self.numOfthumbLabel.text = voteCount;
    
    //根据newsType去设置类型图片
    self.newsTypeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.newsType]];
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
