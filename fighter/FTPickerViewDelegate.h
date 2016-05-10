//
//  FTPickerViewDelegate.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FTPickerType) {
    FTPickerTypeNone = 0,   // no picker type
    FTPickerTypeDate,
    FTPickerTypeWeight,
    FTPickerTypeHeight,
    FTPickerTypeSex,
    FTPickerTypeCity,
    
};

@protocol FTPickerViewDelegate <NSObject>
@optional
- (void) didSelectedDate:(NSString *) date type:(FTPickerType) type;
@end
