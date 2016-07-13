//
//  FTLabelsCell.m
//  fighter
//
//  Created by kang on 16/7/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLabelsCell.h"

@implementation FTLabelsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
