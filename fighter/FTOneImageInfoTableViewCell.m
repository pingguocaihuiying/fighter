//
//  FTBaseInfoTableViewCell.m
//  fighter
//
//  Created by Liyz on 4/11/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTOneImageInfoTableViewCell.h"

@implementation FTOneImageInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)thumbButtonClicked:(id)sender {
    NSLog(@"thumb button clicked.");
}
- (IBAction)commentButtonClicked:(id)sender {
    NSLog(@"comment button clicked.");
}

- (void)setWithBean:(FTNewsBean *)bean{
    self.fromLabel.text = [NSString stringWithFormat:@"来源：%@", bean.author];
    NSString *newsTime = bean.newsTime;
    newsTime = [newsTime substringToIndex:newsTime.length - 3];
    NSTimeInterval timeInterval = [newsTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [self fixStringForDate:date];
    self.timeLabel.text = timeString;
    self.myTitleLabel.text = bean.title;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img_small_one]];
    
    //根据newsType去设置类型图片
//    if ([bean.newsType isEqualToString:@"Sumo"]) {
//        self.newsTypeImageView.image = [UIImage imageNamed:@"KickBoxing_Sanda"];
//    }
    
//    self.imageView.contentMode = UIViewContentModeRight;
    
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
