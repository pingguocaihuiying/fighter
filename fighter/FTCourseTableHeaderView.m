//
//  FTCourseTableHeaderView.m
//  fighter
//
//  Created by 李懿哲 on 22/10/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCourseTableHeaderView.h"

@implementation FTCourseTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    _dateLabel.textColor = [UIColor colorWithHex:0x22b33c];
    _dayLabel.textColor = [UIColor colorWithHex:0x22b33c];
    self.backgroundColor = [UIColor redColor];
    
}

@end
