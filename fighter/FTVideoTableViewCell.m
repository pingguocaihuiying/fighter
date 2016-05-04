//
//  FTVideoTableViewCell.m
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoTableViewCell.h"
#import "FTVideoBean.h"

@implementation FTVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"init with frame.");
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)init{
    NSLog(@"init");
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setWithBean:(FTVideoBean *)bean{//根据bean设置cell的显示内容
    NSLog(@"titile宽度：%f", self.myTitleLabel.frame.size.width);
    CGRect r = self.myTitleLabel.frame;
    r.size.height = 28 / 2;
    self.myTitleLabel.frame = r;
//    self.myTitleLabel.numberOfLines = 1;
    //设置播放按钮的二态
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"列表用视频播放"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"列表用视频播放pre"] forState:UIControlStateHighlighted];
    
    self.myTitleLabel.text = bean.title;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
    
    
    
    //设置评论数、点赞数等
    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
    self.numOfCommentLabel.text = commentCount;
    self.numOfthumbLabel.text = voteCount;
    self.numOfWatch.text = [NSString stringWithFormat:@"(%@)", bean.viewCount];
    self.durationOfVideoLabel.text = [NSString stringWithFormat:@"%@", bean.videoLength];
    
//    根据Type去设置类型图片
    if ([bean.videosType isEqualToString:@"Boxing"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-拳击"];
    }else if ([bean.videosType isEqualToString:@"MMA"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-综合格斗"];
    }else if ([bean.videosType isEqualToString:@"ThaiBoxing"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-泰拳"];
    }else if ([bean.videosType isEqualToString:@"Taekwondo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-跆拳道"];
    }else if ([bean.videosType isEqualToString:@"Judo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-柔道"];
    }else if ([bean.videosType isEqualToString:@"Wrestling"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-摔跤"];
    }else if ([bean.videosType isEqualToString:@"Sumo"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-相扑"];
    }else if ([bean.videosType isEqualToString:@"FemaleWrestling"]) {
        self.videoTypeImageView.image = [UIImage imageNamed:@"格斗标签-女子格斗"];
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
