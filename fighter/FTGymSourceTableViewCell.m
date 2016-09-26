  //
//  FTGymSourceTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymSourceTableViewCell.h"

@implementation FTGymSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置默认值
    _isPast = YES;
    _hasOrder = NO;
    _canOrder = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setwithDic:(NSDictionary *)dic{
    //是否是过去的
    
    if (_isPast) {
        _selectionImage.hidden = YES;
        _courseNameLabel.text  = dic[@"label"];
        _courseStatusLabel.text = @"已结束";
        _courseNameLabel.textColor = [UIColor colorWithHex:0x505050];
        _courseStatusLabel.textColor = [UIColor colorWithHex:0x505050];
    } else {
        //是否已经预约该课
        _hasOrder = [dic[@"myIsOrd"] integerValue];
        if (_hasOrder) {
            _selectionImage.hidden = NO;
        }else{
            _selectionImage.hidden = YES;
        }
        //是否已满(是否可以预约)
        
        NSInteger hasOrderCount = [dic[@"hasOrderCount"] integerValue];
        NSInteger orderLimit = [dic[@"topLimit"] integerValue];
        _courseNameLabel.text  = dic[@"label"];
        _courseStatusLabel.text = [NSString stringWithFormat:@"%ld/%ld", hasOrderCount, orderLimit];
        
        if(orderLimit < 1){//如果上限人数比1小，可能是无效数据，不可约
            _canOrder = NO;
        }else{
            if (hasOrderCount < orderLimit) {
                _canOrder = YES;

            } else {
                _canOrder = NO;
                _isFull = YES;

            }
        }
        if (_canOrder) {
            _courseNameLabel.textColor = [UIColor colorWithHex:0x24b33c];
            _courseStatusLabel.textColor = [UIColor colorWithHex:0x24b33c];
        } else {
            _courseNameLabel.textColor = [UIColor redColor];
            _courseStatusLabel.textColor = [UIColor redColor];
        }
    }
    

}

@end
