//
//  FTGymSourceTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

typedef NS_ENUM(NSInteger, FTGymPublicCourseType){//公开课课程表的类型
    FTGymPublicCourseTypeForUser,//用户端
    FTGymPublicCourseTypeForCoach//教练端
};

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTGymSourceTableViewCellNew : FTBaseTableViewCell

@property (nonatomic, assign) FTGymPublicCourseType courseType;

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
@property (nonatomic, assign) BOOL isAvailable;//是否可以选择
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;//课程名字
@property (strong, nonatomic) IBOutlet UILabel *courseTimeSectionLabel;//时间段
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;//教练名字
@property (strong, nonatomic) IBOutlet UIButton *statusButton;

@property (strong, nonatomic) IBOutlet UILabel *courseStatusLabel;//课程状态：一结束
@property (nonatomic, assign) BOOL canOrder;//可以预约：绿色
@property (nonatomic, assign) BOOL hasOrder;//已经预约：有红圈
@property (nonatomic, assign) BOOL isPast;//是否已经结束
@property (nonatomic, assign) BOOL isFull;//是否已经满员 *注：满员是不可约的充分条件
@property (strong, nonatomic) IBOutlet UIImageView *hasOrderImageView;


@property (nonatomic, strong) NSDictionary *courserCellDic;//存放一小段课程
@property (nonatomic, assign) BOOL hasCourseData;

//预约教练块新加的
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;//预约人数
@property (nonatomic, assign) BOOL isEmpty;//该时间段空闲，说明可以预约教练
@property (strong, nonatomic) IBOutlet UIView *dividingLine;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *orderCountRightMargin;//人数label右边距，用户看团课 8（默认），教练自己看-23
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImageview;

-(void)setwithDic:(NSDictionary *)dic andCourseType:(FTGymPublicCourseType) courseType;
- (void)setBlank;
- (void)hideRightArrow;//此方法暂时修复了一个显示上的bug
@end
