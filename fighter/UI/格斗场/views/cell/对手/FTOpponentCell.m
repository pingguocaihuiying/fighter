//
//  FTOpponentCellTableViewCell.m
//  fighter
//
//  Created by Liyz on 7/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTOpponentCell.h"

@implementation FTOpponentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)challengeButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectOpponentByIndex:)]) {
        [_delegate selectOpponentByIndex:self.tag];
    }
}

@end
