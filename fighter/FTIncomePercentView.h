

//
//  FTHeightPickerView.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTIncomePercentView;
@protocol FTIncomePercentPickerViewDelegate <NSObject>
- (void)pickerView:(FTIncomePercentView *) incomePercentView didSelectedIncomeValuePercent:(NSInteger)curIncomePoint;//收益百分比选择回调
@end

@interface FTIncomePercentView : UIView
@property (nonatomic ,strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, weak) id<FTIncomePercentPickerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger availablePoint;//用于表示可选百分比，1p代表5个百分点
@property (nonatomic, assign)NSInteger curPoint;//当前点数
@property (nonatomic, copy) NSString *pickerTopLabelString;//“我方收益”、“对方收益”、“赞助者受益”

- (instancetype)initWithAvailablePoint:(NSInteger)availablePoint andCurPoint:(NSInteger)curPoint;//根据可用点数和当前点数初始化
@end
