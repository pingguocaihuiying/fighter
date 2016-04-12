//
//  FTBaseInfoTableViewCell.m
//  fighter
//
//  Created by Liyz on 4/11/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTOneImageInfoTableViewCell.h"

@implementation FTOneImageInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)thumbButtonClicked:(id)sender {
    NSLog(@"thumb button clicked.");
}
- (IBAction)commentButtonClicked:(id)sender {
    NSLog(@"comment button clicked.");
}

@end
