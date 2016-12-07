//
//  FTArenaTextTableViewCell.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaTextTableViewCell.h"
#import "FTArenaBean.h"
#import "FTTools.h"

@implementation FTArenaTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

//    _kindLabel.font = [UIFont systemFontOfSize:14 * SCALE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWithBean:(FTArenaBean *)bean{
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.theTitle setTextColor: Main_Text_Color];
    }


    
    //根据数据源去设置显示内容
    self.theTitle.text = bean.title;
    if (bean.content) {
        self.sumupLabel.text = bean.content;
    }else{
        self.sumupLabel.text = @"";
    }

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    NSString *commentCount = [NSString stringWithFormat:@"%@", bean.commentCount == nil ? @"0" : bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"%@", bean.voteCount == nil ? @"0" : bean.voteCount];

    self.commentCountLabel.text = [NSString stringWithFormat:@"(%@)", commentCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"(%@)", voteCount];
    self.authorLabel.text = bean.nickname;
    self.timeLabel.text = [self getTimeLabelTextTimeStamp:bean.createTimeTamp];
    
    //调整正文行高
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.sumupLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.sumupLabel.text length])];
    self.sumupLabel.attributedText = attributedString;
    [self.sumupLabel sizeToFit];
    
    
//    NSLog(@"label : %@", bean.labels);
    //根据newsType去设置类型图片
//    self.typeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.labels]];
    _kindLabel.text = [FTTools getChNameWithEnLabelName:bean.labels];

}

-(NSString *)getTimeLabelTextTimeStamp:(NSString *)timeStamp{
    timeStamp = [timeStamp substringToIndex:timeStamp.length - 3];
    long daysBefore = (time(NULL) - [timeStamp integerValue]) / 3600 / 24;
    NSString *timeLabelString;
    switch (daysBefore) {
        case 0:
            //timeLabelString = @"今天";
        {
            long hours = (time(NULL) - [timeStamp integerValue]) / 3600;
            if (hours >= 1) {
                timeLabelString = [NSString stringWithFormat:@"%ld小时前", hours % 24];
            }else{
                long minutes = (time(NULL) - [timeStamp integerValue]) / 60;
                timeLabelString = [NSString stringWithFormat:@"%ld分钟前", minutes % 60];
            }
            
        }
            break;
        case 1:
            timeLabelString = @"昨天";
            break;
        case 2:
            timeLabelString = @"前天";
            break;
        case 3:
            timeLabelString = @"3天前";
            break;
        case 4:
            timeLabelString = @"4天前";
            break;
        case 5:
            timeLabelString = @"5天前";
            break;
            
        default:
        {
            NSTimeInterval timeInterval = [timeStamp doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            NSString *timeString = [self fixStringForDate:date];
            timeLabelString = timeString;
        }
            break;
    }
    return timeLabelString;
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
