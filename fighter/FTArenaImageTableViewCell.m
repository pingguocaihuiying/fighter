//
//  FTArenaImageTableViewCell.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaImageTableViewCell.h"
#import "FTArenaBean.h"
#import "FTTools.h"

@implementation FTArenaImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewWidth.constant *= SCALE;
    self.imageViewHeight.constant *= SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setWithBean:(FTArenaBean *)bean{
    
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
    

    if (bean.videoUrlNames && ![bean.videoUrlNames isEqualToString:@""]) {
        NSString *firstVideoUrlString = [[bean.videoUrlNames componentsSeparatedByString:@","]firstObject];

        firstVideoUrlString = [NSString stringWithFormat:@"%@?imageView2/2/w/200", firstVideoUrlString];
        NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", bean.urlPrefix, firstVideoUrlString];
        NSLog(@"videoUrlString : %@", imageUrlString);
        [self.theImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    }else if(bean.pictureUrlNames && ![bean.pictureUrlNames isEqualToString:@""]){
        NSString *firstImageUrlString = [[bean.pictureUrlNames componentsSeparatedByString:@","]firstObject];
//        firstImageUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstImageUrlString];
        firstImageUrlString = [NSString stringWithFormat:@"%@?imageView2/2/w/200", firstImageUrlString];
        NSString *imageUrlString = [NSString stringWithFormat:@"%@/%@", bean.urlPrefix, firstImageUrlString];
        NSLog(@"imageUrlString : %@", imageUrlString);
        [self.theImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    }
    //根据newsType去设置类型图片
//        NSLog(@"label : %@", bean.labels);
    self.typeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.labels]];
    
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
