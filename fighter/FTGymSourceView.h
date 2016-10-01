//
//  FTGymSourceView.h
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//
@class FTGymSourceTableViewCell;
@protocol FTGymCourseTableViewDelegate <NSObject>
@optional

/**
 公开课cell点击后的回掉方法

 @param courseCell 点击的cell
 @param day        周几
 @param timeSection       时间段
 */
- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *) timeSection andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp;

@end

/**
 课程表类型

 - FTOrderCourseTypeGym:       拳馆公开课
 - FTOrderCourseTypeCoach:     预约教练
 - FTOrderCourseTypeCoachSelf: 教练查看自己的预约
 */
typedef NS_ENUM(NSInteger, FTOrderCourseType) {
    FTOrderCourseTypeGym,
    FTOrderCourseTypeCoach,
    FTOrderCourseTypeCoachSelf
};

#import <UIKit/UIKit.h>
#import "FTGymSourceTableViewCell.h"

@interface FTGymSourceView : UIView

@property (nonatomic, assign) FTOrderCourseType courseType;//课程表类型
@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (nonatomic, weak) id<FTGymCourseTableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewsHeight;//tableViews的高度
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)reloadTableViews;//刷新tableView
@end
