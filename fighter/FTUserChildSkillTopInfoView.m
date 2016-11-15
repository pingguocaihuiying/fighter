//
//  FTUserChildSkillTopInfoView.m
//  fighter
//
//  Created by 李懿哲 on 11/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserChildSkillTopInfoView.h"

@implementation FTUserChildSkillTopInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
    self.ratingBar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
    
    self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [self.ratingBar displayRating:5.0f];
}

@end
