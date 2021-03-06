//
//  FTRecordRankTableViewCell.m
//  fighter
//
//  Created by Liyz on 6/2/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTRecordRankTableViewCell.h"

@implementation FTRecordRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithDic:(NSDictionary *)dic{
    NSString *race = dic[@"race"];//名称
    NSString *newRanking = [NSString stringWithFormat:@"%@", dic[@"newRanking"]];//最新排名
    NSString *newPeriod = [NSString stringWithFormat:@"%@", dic[@"newPeriod"]];//最新排名的届
    NSString *topPeriod = [NSString stringWithFormat:@"%@", dic[@"topPeriod"]];//最高排名的届
    NSString *topRanking = [NSString stringWithFormat:@"%@", dic[@"topRanking"]];//最高排名
    
    newRanking = [self handleRankWithRankString:newRanking];
    topRanking = [self handleRankWithRankString:topRanking];
    
    _competitionNameLabel.text = race;
    _curRankLabel.text = [NSString stringWithFormat:@"%@(第%@届)",newRanking , newPeriod];
    _bestRankLabel.text = [NSString stringWithFormat:@"%@(第%@届)", topRanking, topPeriod];
}

- (NSString *)handleRankWithRankString:(NSString *)rankStr{
    NSString *resultStr = @"";
    
    if ([rankStr isEqualToString:@"1"]) {
        resultStr = @"冠军";
    }else if ([rankStr isEqualToString:@"2"]){
        resultStr = @"亚军";
    }
    else if ([rankStr isEqualToString:@"3"]){
        resultStr = @"季军";
    }else{
        resultStr = [NSString stringWithFormat:@"No.%@", rankStr];
    }
    
    return resultStr;
}

@end
