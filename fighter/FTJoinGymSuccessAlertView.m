//
//  FTJoinGymSuccessAlertView.m
//  fighter
//
//  Created by 李懿哲 on 16/9/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTJoinGymSuccessAlertView.h"

@implementation FTJoinGymSuccessAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)enterButtonClicked:(id)sender {
    NSLog(@"点击进入");
    if ([_delegate respondsToSelector:@selector(enterGymButtonClicked)]) {
        [_delegate enterGymButtonClicked];
    }
}

@end
