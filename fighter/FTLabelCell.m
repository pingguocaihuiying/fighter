//
//  FTLabelCell.m
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLabelCell.h"

@implementation FTLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
