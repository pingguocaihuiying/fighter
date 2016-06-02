//
//  FTDatePickerView.h
//  PickerViewDemo
//
//  Created by kang on 16/4/28.
//  Copyright © 2016年 kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPickerViewDelegate.h"



@interface FTDatePickerView : UIView

@property (nonatomic ,strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, weak) id<FTPickerViewDelegate> delegate;
@end

