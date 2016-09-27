//
//  FTCoachHistoryCourseTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachHistoryCourseTableViewCell.h"

@interface FTCoachHistoryCourseTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *dividingLineView;

@end

@implementation FTCoachHistoryCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dividingLineView.backgroundColor = Cell_Space_Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
