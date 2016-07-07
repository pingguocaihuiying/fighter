//
//  FTPickerViewDelegate.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTIncomePercentView.h"
typedef NS_ENUM(NSInteger, FTPickerType) {
    FTPickerTypeNone = 0,   // no picker type
    FTPickerTypeDate,
    FTPickerTypeWeight,
    FTPickerTypeHeight,
    FTPickerTypeSex,
    FTPickerTypeCity,
    
};

@class FTIncomePercentView;
@protocol FTPickerViewDelegate <NSObject>
- (void) didSelectedDate:(NSString *) date type:(FTPickerType) type;
- (void) didRemovePickerView;
- (void)pickerView:(FTIncomePercentView *) incomePercentView didSelectedIncomeValuePercent:(NSInteger)curIncomePoint;//收益百分比选择回调
@end
