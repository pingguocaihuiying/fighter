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
//    _labelLabel.font = [UIFont systemFontOfSize:14 * SCALE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setWithBean:(FTArenaBean *)bean{
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.theTitle setTextColor:Main_Text_Color];
    }
    
    //根据数据源去设置显示内容
    self.theTitle.text = bean.title;
    self.sumupLabel.text = bean.content;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    NSString *commentCount = [NSString stringWithFormat:@"%@", bean.commentCount == nil ? @"0" : bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"%@", bean.voteCount == nil ? @"0" : bean.voteCount];
//    NSString *viewCount = [NSString stringWithFormat:@"%@", bean.viewCount == nil ? @"0" : bean.viewCount];
    
//    int comment2 = [commentCount intValue] * 10;
//    int voteCount2 = [voteCount intValue] * 5;
//    int viewCount2 = [viewCount intValue];
//    int allcount =  comment2 + voteCount2 + viewCount2;
//    self.commentCountLabel.text = [NSString stringWithFormat:@"(%d)", allcount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"(%@)", commentCount];
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"(%@)", voteCount];
    self.authorLabel.text = bean.nickname;
    self.timeLabel.text = [self getTimeLabelTextTimeStamp:bean.createTimeTamp];
    
    if (bean.videoUrlNames == nil) {
        bean.videoUrlNames = @"";
    }
    if (bean.pictureUrlNames == nil) {
        bean.pictureUrlNames = @"";
    }
    
    if (bean.videoUrlNames && ![bean.videoUrlNames isEqualToString:@""]) {//如果有视频图片，优先显示视频图片
//        NSLog(@"显示视频");
        NSString *firstVideoUrlString = [[bean.videoUrlNames componentsSeparatedByString:@","]firstObject];

        firstVideoUrlString = [NSString stringWithFormat:@"%@?vframe/png/offset/0/w/200/h/100", firstVideoUrlString];
        NSString *videoUrlString = [NSString stringWithFormat:@"https://%@/%@", bean.urlPrefix, firstVideoUrlString];

        NSLog(@"videoUrlString : %@", videoUrlString);
        [self.theImageView sd_setImageWithURL:[NSURL URLWithString:videoUrlString] placeholderImage:[UIImage imageNamed:@"占位图小"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _placeHoldImageView.hidden = YES;
            self.playVideoImageview.hidden = NO;
        }];
        self.playVideoImageview.hidden = NO;
        
    }else if(bean.pictureUrlNames && ![bean.pictureUrlNames isEqualToString:@""]){//如果没有视频，再去找图片的缩略图
//        NSLog(@"显示图片缩略图");
        NSString *firstImageUrlString = [[bean.pictureUrlNames componentsSeparatedByString:@","]firstObject];
        firstImageUrlString = [NSString stringWithFormat:@"%@?imageView2/2/w/200", firstImageUrlString];
        NSString *imageUrlString = [NSString stringWithFormat:@"https://%@/%@", bean.urlPrefix, firstImageUrlString];

        
        [self.theImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"占位图小"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _placeHoldImageView.hidden = YES;
        }];
        self.playVideoImageview.hidden = YES;
    }
    //根据newsType去设置类型图片
    _labelLabel.text = [FTTools getChNameWithEnLabelName:bean.labels];
    
}

-(NSString *)getTimeLabelTextTimeStamp:(NSString *)timeStamp{
    timeStamp = [timeStamp substringToIndex:timeStamp.length - 3];
    NSString *timeLabelString;
    long daysBefore = (time(NULL) - [timeStamp integerValue]) / 3600 / 24;
    
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
