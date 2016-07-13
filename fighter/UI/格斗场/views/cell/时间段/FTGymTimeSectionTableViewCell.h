//
//  FTGymTimeSectionTableViewCell.h
//  fighter
//
//  Created by Liyz on 08/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTGymTimeSectionTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *timeSectionString;//时间段，例如："10:00~11:00"
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, assign) BOOL isAvailable;//是否可以选择
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;//底部分割线
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;

/**
 *  根据timeSectionString去设置标签显示
 *
 *  @param timeSectionString 时间段，例如："10:00~11:00"
 */
- (void)setTimeLabelWithTimeSectionString:(NSString *)timeSectionString;

/**
 *  更新cell的显示状态：可用、不可用
 */
- (void)updateCellStatus;

@end
