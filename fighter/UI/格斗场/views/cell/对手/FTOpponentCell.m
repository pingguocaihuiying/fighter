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

- (void)setWithDic:(NSDictionary *)dic{
    //名字
    _opponentNameLabel.text = dic[@"name"];
    
    
    //战绩
    NSString *winCount = dic[@"win"] == nil ? @"0" : dic[@"win"];
    NSString *failCount = dic[@"fail"] == nil ? @"0" : dic[@"fail"];
    NSString *drawCount = dic[@"draw"] == nil ? @"0" : dic[@"draw"];
    NSString *knockoutCount = dic[@"knockout"] == nil ? @"0" : dic[@"knockout"];
    
    _recordLabel.text = [NSString stringWithFormat:@"%@胜 %@负 %@平 %@", winCount, failCount, drawCount, knockoutCount];
    
    //头像
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"headUrl"]]];
}

@end
