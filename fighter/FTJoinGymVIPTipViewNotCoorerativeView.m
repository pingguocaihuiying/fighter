//
//  FTJoinGymVIPTipViewNotCoorerativeView.m
//  fighter
//
//  Created by 李懿哲 on 06/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

#import "FTJoinGymVIPTipViewNotCoorerativeView.h"

@implementation FTJoinGymVIPTipViewNotCoorerativeView
- (void)awakeFromNib{
    [super awakeFromNib];
    //设置按钮的title颜色为标准红
    [_gymTelButton setTitleColor:Custom_Red forState:UIControlStateNormal];
}
//cancel
- (IBAction)cancelButtonClicked:(id)sender {
    [self removeFromSuperview];
}
@end
