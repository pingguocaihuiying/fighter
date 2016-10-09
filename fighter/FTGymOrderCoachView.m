//
//  FTGymOrderCoachView.m
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymOrderCoachView.h"

@implementation FTGymOrderCoachView

#pragma mark - response
- (IBAction)rechargeButtonAction:(id)sender {
    
}

- (IBAction)confirmButtonAction:(id)sender {
    
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

- (void)setDisplay{
    _titleLabel.text = [NSString stringWithFormat:@"确定预约 %@ 的课吗？", _coachName];
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@", _dateString, _timeSection];
    
    //价格start
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    dic1[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dic1[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attSTr1 = [[NSAttributedString alloc]initWithString:@"本次预约消耗：" attributes:dic1];
    
    if (!_price) {
        _price = @"-1";
    }
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    dic2[NSForegroundColorAttributeName] = Custom_Red;
    dic2[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    NSAttributedString *attSTr2 = [[NSAttributedString alloc]initWithString:_price attributes:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    dic3[NSForegroundColorAttributeName] = Custom_Red;
    dic3[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    NSAttributedString *attSTr3 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic3];
    
    NSMutableAttributedString *mutaAttrString = [[NSMutableAttributedString alloc]init];
    [mutaAttrString appendAttributedString:attSTr1];
    [mutaAttrString appendAttributedString:attSTr2];
    [mutaAttrString appendAttributedString:attSTr3];
    
    _consumeLabel.attributedText = mutaAttrString;
    //价格end
    
    //余额start
    if (!_balance) {
        _balance = @"-1";
    }
    
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    dic4[NSForegroundColorAttributeName] = Custom_Red;
    dic4[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attSTr4 = [[NSAttributedString alloc]initWithString:_balance attributes:dic4];
    

    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    dic5[NSForegroundColorAttributeName] = Custom_Red;
    dic5[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attSTr5 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic5];

    
    NSMutableAttributedString *mutaAttrString2 = [[NSMutableAttributedString alloc]init];
    [mutaAttrString2 appendAttributedString:attSTr4];
    [mutaAttrString2 appendAttributedString:attSTr5];
    
    _balanceLabel.attributedText = mutaAttrString2;
    //余额end
}

@end
