//
//  FTArenaTextTableViewCell.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaTextTableViewCell.h"

@implementation FTArenaTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWithBean:(FTNewsBean *)bean{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
//    [label setBackgroundColor:[UIColor blackColor]];
//    [label setFont:[UIFont systemFontOfSize:16]];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setNumberOfLines:0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.sumupLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.sumupLabel.text length])];
    self.sumupLabel.attributedText = attributedString;
//    [self.view addSubview:label];
    [self.sumupLabel sizeToFit];
}
@end
