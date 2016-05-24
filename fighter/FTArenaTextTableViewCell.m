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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWithBean:(FTArenaBean *)bean{
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.theTitle setTextColor:Nonmal_Text_Color];
    }

    //调整正文行高
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.sumupLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.sumupLabel.text length])];
    self.sumupLabel.attributedText = attributedString;
    [self.sumupLabel sizeToFit];
    
    //根据数据源去设置显示内容
    self.theTitle.text = bean.title;
    self.sumupLabel.text = bean.content;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:bean.thumbUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    NSString *commentCount = [NSString stringWithFormat:@"%@", bean.commentCount == nil ? @"0" : bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"%@", bean.voteCount == nil ? @"0" : bean.voteCount];

    self.commentCountLabel.text = [NSString stringWithFormat:@"(%@)", commentCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"(%@)", voteCount];
    self.authorLabel.text = bean.nickname;
    self.timeLabel.text = bean.createTime;
//    NSLog(@"label : %@", bean.labels);
    //根据newsType去设置类型图片
    self.typeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.labels]];
    
//    NSLog(@"time : %@", [NSDate date]);
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
