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
    _isUnderway = NO;
    _hasOrder = NO;
    _canOrder = NO;
    
    _dividingLine.backgroundColor = Cell_Space_Color;
    _bgView.backgroundColor = [UIColor colorWithHex:0x191919];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setwithDic:(NSDictionary *)dic andCourseType:(FTGymPublicCourseType) courseType{
    _courseNameLabel.hidden = NO;
    _courseTimeSectionLabel.hidden = NO;
    _coachNameLabel.hidden = NO;
    
    
    _courseNameLabel.text  = dic[@"courseName"];//课程名
    _courseTimeSectionLabel.text = dic[@"timeSection"];//时间段
    _coachNameLabel.text = [NSString stringWithFormat:@"教练：%@", dic[@"coach"]];//教练名
    
    //是否是过去的
    if (_isPast) {
        if (_isUnderway) {//正在进行中
            _courseStatusLabel.text = @"进行中";
            _courseStatusLabel.hidden = NO;
            
            _courseNameLabel.textColor = [UIColor whiteColor];
            _courseStatusLabel.textColor = Custom_Green_Color;
            _courseTimeSectionLabel.textColor = [UIColor whiteColor];
            _coachNameLabel.textColor = [UIColor whiteColor];
            
            _hasOrderImageView.hidden = YES;
            _orderStatusLabel.hidden = YES;
            _statusButton.hidden = YES;
        } else {//确实已经过去了
            _courseStatusLabel.text = @"已结束";
            _courseStatusLabel.hidden = NO;
            
            _courseNameLabel.textColor = [UIColor colorWithHex:0x5a5a5a];
            _courseStatusLabel.textColor = [UIColor colorWithHex:0x505050];
            _courseTimeSectionLabel.textColor = [UIColor colorWithHex:0x505050];
            _coachNameLabel.textColor = [UIColor colorWithHex:0x505050];
            
            _hasOrderImageView.hidden = YES;
            _orderStatusLabel.hidden = YES;
            _statusButton.hidden = YES;
        }

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
            
            _courseStatusLabel.hidden = YES;
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
//            [_statusButton setBackgroundImage:[UIImage imageNamed:@"拳馆详情新课表-可用"] forState:UIControlStateNormal];
//            [_statusButton setBackgroundImage:[UIImage imageNamed:@"拳馆详情新课表-可用"] forState:UIControlStateDisabled];
            [_statusButton setTitle:@"预约" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHex:0x23b33c] forState:UIControlStateNormal];//把背景图去掉了，修改字体的颜色 12月23日 lyz
        } else {
        
            _orderStatusLabel.textColor = [UIColor colorWithHex:0xbe1e1e];
//            [_statusButton setBackgroundImage:[UIImage imageNamed:@"拳馆详情新课表-不可用"] forState:UIControlStateNormal];
//            [_statusButton setBackgroundImage:[UIImage imageNamed:@"拳馆详情新课表-不可用"] forState:UIControlStateDisabled];
            [_statusButton setTitle:@"已满" forState:UIControlStateNormal];
            [_statusButton setTitleColor:[UIColor colorWithHex:0x505050] forState:UIControlStateNormal];
        }
    }
    
    if (courseType == FTGymPublicCourseTypeForUser) {
        _rightArrowImageview.hidden = YES;
        _orderCountRightMargin.constant = 8;
    } else if (courseType == FTGymPublicCourseTypeForCoach) {//如果教练端
        
        //需要显示的
        _rightArrowImageview.hidden = NO;
        _orderCountRightMargin.constant = -23;
        
        //需要隐藏的
        _hasOrderImageView.hidden = YES;
        _courseStatusLabel.hidden = YES;
        _statusButton.hidden = YES;
    }
}


- (void)setBlank{
    _courseStatusLabel.hidden = YES;
    
    _courseNameLabel.hidden = YES;
    _courseTimeSectionLabel.hidden = YES;
    _coachNameLabel.hidden = YES;
    
    _hasOrderImageView.hidden = YES;
    _orderStatusLabel.hidden = YES;
    _statusButton.hidden = YES;    
    
    _hasCourseData = NO;
}

- (void)hideRightArrow{
    _rightArrowImageview.hidden = YES;
}

@end
