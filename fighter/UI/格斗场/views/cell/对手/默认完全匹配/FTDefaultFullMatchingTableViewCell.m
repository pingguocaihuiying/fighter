//
//  FTDefaultFullMatchingTableViewCell.m
//  fighter
//
//  Created by Liyz on 7/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTDefaultFullMatchingTableViewCell.h"

@implementation FTDefaultFullMatchingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(defaultFullyMatchingSelected)]) {
        [_delegate defaultFullyMatchingSelected];
    }
}

@end
