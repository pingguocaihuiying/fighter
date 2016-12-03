//
//  FTDrawerCell.m
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerCell.h"

@implementation FTDrawerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellTitle.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void) setSpaceView:(UIView *)spaceView {
    
    
}

- (void) setTitleWithString:(NSString *)string {
    
    self.cellTitle.text = string;
}
@end
