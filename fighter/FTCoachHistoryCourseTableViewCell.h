//
//  FTCoachHistoryCourseTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTCoachHistoryCourseTableViewCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@property (weak, nonatomic) IBOutlet UILabel *timeSectionLabel;//时间段

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//学生名字

@property (strong, nonatomic) IBOutlet UIImageView *gradeImageView;//是否评分
@end
