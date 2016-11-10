//
//  FTUserCourseCommentHeaderView.m
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserCourseCommentHeaderView.h"
#import "UIView+DividingLine.h"

@implementation FTUserCourseCommentHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addBottomDividingLine];
}

@end
