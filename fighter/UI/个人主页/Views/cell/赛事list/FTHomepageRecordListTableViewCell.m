//
//  FTHomepageRecordListTableViewCell.m
//  fighter
//
//  Created by Liyz on 6/2/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTHomepageRecordListTableViewCell.h"

@implementation FTHomepageRecordListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithDic:(NSDictionary *)dic{
    self.raceTitleLabel.text = dic[@"title"];
    self.opponentNameLabel.text = dic[@"partner"];
    self.theTimelabel.text = [FTTools fixStringForDate:dic[@"createTimeTamp"]];
    
    //胜负
    if ([dic[@"outcome"] isEqualToString:@"胜"]) {
        self.raceResultImageView.image = [UIImage imageNamed:@"胜"];
    }else if ([dic[@"outcome"] isEqualToString:@"负"]){
        self.raceResultImageView.image = [UIImage imageNamed:@"负"];
    }else if ([dic[@"outcome"] isEqualToString:@"平"]){
        self.raceResultImageView.image = [UIImage imageNamed:@"平"];
    }
    
    //类型
    if ([dic[@"urlType"] isEqualToString:@"0"]) {
        self.typeImageView.hidden = YES;
    }else if([dic[@"urlType"] isEqualToString:@"1"]){
        self.typeImageView.image = [UIImage imageNamed:@"赛事-文章详情"];
    }else if([dic[@"urlType"] isEqualToString:@"2"]){
        self.typeImageView.image = [UIImage imageNamed:@"赛事-视频详情"];
    }
}

@end
