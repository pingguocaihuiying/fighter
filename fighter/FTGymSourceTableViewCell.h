//
//  FTGymSourceTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"
#import "FTGymSourceView.h"

@interface FTGymSourceTableViewCell : FTBaseTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
@property (nonatomic, assign) BOOL isAvailable;//是否可以选择
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseStatusLabel;
@property (nonatomic, assign) BOOL canOrder;//可以预约：绿色
@property (nonatomic, assign) BOOL hasOrder;//已经预约：有红圈
@property (nonatomic, assign) BOOL isPast;//是否已经结束
@property (nonatomic, assign) BOOL isFull;//是否已经满员 *注：满员是不可约的充分条件

@property (nonatomic, strong) NSDictionary *courserCellDic;//存放一小段课程
@property (nonatomic, assign) BOOL hasCourseData;

//预约教练块新加的
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (nonatomic, assign) BOOL isEmpty;//该时间段空闲，说明可以预约教练

-(void)setwithDic:(NSDictionary *)dic;
-(void)setCoachCourseWithDic:(NSDictionary *)dic;
- (void)setCoachCourseSelfWithDic:(NSDictionary *)dic;
@end
