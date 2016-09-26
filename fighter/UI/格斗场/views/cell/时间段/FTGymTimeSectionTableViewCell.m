//
//  FTGymTimeSectionTableViewCell.m
//  fighter
//
//  Created by Liyz on 08/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymTimeSectionTableViewCell.h"


@implementation FTGymTimeSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bottomLineView.backgroundColor = Cell_Space_Color;
    _rightLineView.backgroundColor = Cell_Space_Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTimeLabelWithTimeSectionString:(NSString *)timeSectionString{
    NSArray *timePointArray = [timeSectionString componentsSeparatedByString:@"~"];
    _startTimeLabel.text = [timePointArray firstObject];
    _endTimeLabel.text = [timePointArray lastObject];
}

- (void)updateCellStatus{
//    static int count = 0;
//    NSLog(@"count : %d", ++count);
    if (_isAvailable) {
        _startTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.textColor = [UIColor whiteColor];
    } else {
        _startTimeLabel.textColor = [UIColor colorWithHex:0x505050];
        _endTimeLabel.textColor = [UIColor colorWithHex:0x505050];
    }
}

- (void)setWhiteColor{
        _startTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.textColor = [UIColor whiteColor];
    
    _rightLineView.hidden = NO;//显示右侧分割线
    
}
@end
