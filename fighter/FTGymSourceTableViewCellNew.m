//
//  FTGymSourceTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymSourceTableViewCellNew.h"

@implementation FTGymSourceTableViewCellNew

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置默认值
    _isPast = YES;
    _hasOrder = NO;
    _canOrder = NO;
    
    _dividingLine.backgroundColor = Cell_Space_Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setwithDic:(NSDictionary *)dic{
    
    _courseNameLabel.text  = dic[@"courseName"];//课程名
    _courseTimeSectionLabel.text = dic[@"timeSection"];//时间段
    _coachNameLabel.text = dic[@"coach"];//教练名
    
    //是否是过去的
    if (_isPast) {
        
        _courseStatusLabel.text = @"已结束";
        _courseStatusLabel.hidden = NO;
        
        _courseNameLabel.textColor = [UIColor colorWithHex:0x5a5a5a];
        _courseStatusLabel.textColor = [UIColor colorWithHex:0x505050];
        _courseTimeSectionLabel.textColor = [UIColor colorWithHex:0x505050];
        _coachNameLabel.textColor = [UIColor colorWithHex:0x505050];
        
        _hasOrderImageView.hidden = YES;
        _orderStatusLabel.hidden = YES;
        _statusButton.hidden = YES;
    } else {
        //是否已经预约该课
        
        _courseNameLabel.textColor = [UIColor whiteColor];
        _courseTimeSectionLabel.textColor = [UIColor whiteColor];
        _coachNameLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
        
        
        _hasOrder = [dic[@"myIsOrd"] integerValue];

        if (_hasOrder) {
            _hasOrderImageView.hidden = NO;
            _orderStatusLabel.hidden = NO;
            
            _orderStatusLabel.hidden = YES;
            _statusButton.hidden = YES;
            
            _courseStatusLabel.hidden = NO;
            _courseStatusLabel.text = @"已预约";
            _courseStatusLabel.textColor = [UIColor whiteColor];
        }else{
            _hasOrderImageView.hidden = YES;
            _orderStatusLabel.hidden = YES;
            
            _orderStatusLabel.hidden = NO;
            _statusButton.hidden = NO;
        }
        //是否已满(是否可以预约)
        
        NSInteger hasOrderCount = [dic[@"hasOrderCount"] integerValue];
        NSInteger orderLimit = [dic[@"topLimit"] integerValue];
        
        _orderStatusLabel.text = [NSString stringWithFormat:@"%ld/%ld", hasOrderCount, orderLimit];

        
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
            _orderStatusLabel.textColor = [UIColor colorWithHex:0x24b33c];
            [_statusButton setImage:[UIImage imageNamed:@"拳馆详情新课表-可用"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"预约" forState:UIControlStateNormal];
        } else {
        
            _orderStatusLabel.textColor = [UIColor colorWithHex:0xbe1e1e];
            [_statusButton setImage:[UIImage imageNamed:@"拳馆详情新课表-不可用"] forState:UIControlStateNormal];
            [_statusButton setTitle:@"已满" forState:UIControlStateNormal];
        }
    }
    
}

@end
