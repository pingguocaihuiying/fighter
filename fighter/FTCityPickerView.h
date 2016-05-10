//
//  FTCityPickerView.h
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPickerViewDelegate.h"

@interface FTCityPickerView : UIView
@property (nonatomic ,strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, weak) id<FTPickerViewDelegate> delegate;

@end


