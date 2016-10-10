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
    NSString *courseName = dic[@"label"];
    NSRange range = [courseName rangeOfString:@"("];
    if (range.length > 0) {
        courseName = [courseName substringToIndex:range.location];
    }
    if (_isPast) {
        _selectionImage.hidden = YES;
        _courseNameLabel.text  = courseName;
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

        
        _courseNameLabel.text  = courseName;
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

-(void)setCoachCourseWithDic:(NSDictionary *)dic{
    _courseNameLabel.hidden = YES;
    _courseStatusLabel.hidden = YES;
    _orderStatusLabel.hidden = NO;
    
    //过去了的
    if (_isPast) {
        _orderStatusLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
        _orderStatusLabel.text = @"--";
    } else {
        if (_isEmpty) {//如果是空闲的
            _orderStatusLabel.textColor = [UIColor colorWithHex:0x24b33c];
            _orderStatusLabel.text = @"可预约";
            _selectionImage.hidden = YES;
        } else {
            
                    //"type":"0"//类型，0-团课预约（表明不可预约），2-私教预约,3-其他（例如：教练把某日期时段设为不可预约）
            NSString *type = _courserCellDic[@"type"];
            
            if ([type isEqualToString:@"3"]) {
                //如果不可约
                _orderStatusLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
                _orderStatusLabel.text = @"不可约";
                _selectionImage.hidden = YES;
            } else {
                //如果已约
                _orderStatusLabel.textColor = [UIColor whiteColor];
                _orderStatusLabel.text = @"已约";
                
                //"myIsOrd": 1,//当前用户是否预定该课程， 0 - 没有，1 - 已有预约
                NSString *myIsOrd = [NSString stringWithFormat:@"%@", _courserCellDic[@"myIsOrd"]];
                if ([myIsOrd isEqualToString:@"1"]) {//如果是自己约的
                    _selectionImage.hidden = NO;
                }
                
            }
            
        }

    }
}

- (void)setCoachCourseSelfWithDic:(NSDictionary *)dic{
    _courseNameLabel.hidden = YES;
    _courseStatusLabel.hidden = YES;
    _orderStatusLabel.hidden = NO;
    
    //过去了的
    if (_isPast) {
        _orderStatusLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
        _orderStatusLabel.text = @"--";
    } else {
        if (_isEmpty) {//如果是空闲的
            _orderStatusLabel.textColor = [UIColor colorWithHex:0x24b33c];
            _orderStatusLabel.text = @"可预约";
        } else {
            
            //"type":"0"//类型，0-团课预约（表明不可预约），2-私教预约,3-其他（例如：教练把某日期时段设为不可预约）
            NSString *type = _courserCellDic[@"type"];
            
            if ([type isEqualToString:@"3"]) {
                //如果不可约
                _orderStatusLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
                _orderStatusLabel.text = @"不可约";
                _selectionImage.hidden = YES;
            } else {
                //如果已约
                _orderStatusLabel.textColor = [UIColor whiteColor];
                _orderStatusLabel.text = _courserCellDic[@"createName"];
            }
            
        }
        
    }
}

@end
