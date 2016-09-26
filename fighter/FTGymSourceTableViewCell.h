//
//  FTGymSourceTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTGymSourceTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
@property (nonatomic, assign) BOOL isAvailable;//是否可以选择
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseStatusLabel;
@property (nonatomic, assign) BOOL canOrder;//可以预约：绿色
@property (nonatomic, assign) BOOL hasOrder;//已经预约：有红圈
@property (nonatomic, assign) BOOL isPast;//是否已经结束
@property (nonatomic, assign) BOOL isFull;//是否已经满员 *注：满员是不可约的充分条件
@property (nonatomic, assign) BOOL hasCourseData;//有课程数据

-(void)setwithDic:(NSDictionary *)dic;

@end
