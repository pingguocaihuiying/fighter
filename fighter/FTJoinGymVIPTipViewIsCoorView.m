//
//  FTJoinGymVIPTipViewIsCoor.m
//  fighter
//
//  Created by 李懿哲 on 06/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

#import "FTJoinGymVIPTipViewIsCoorView.h"

@interface FTJoinGymVIPTipViewIsCoorView()
@property (strong, nonatomic) IBOutlet UIView *dividingLineView;

@end

@implementation FTJoinGymVIPTipViewIsCoorView

- (void)awakeFromNib{
    [super awakeFromNib];
    //设置按钮的title颜色为标准红
    [_gymTelButton setTitleColor:Custom_Red forState:UIControlStateNormal];
    //设置分割线的颜色
    _dividingLineView.backgroundColor = Cell_Space_Color;
}
- (IBAction)confirmButtonClicked:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self removeFromSuperview];
}
@end
