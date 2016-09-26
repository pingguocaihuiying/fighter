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
- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *) timeSection;

@end

#import <UIKit/UIKit.h>
#import "FTGymSourceTableViewCell.h"

@interface FTGymSourceView : UIView

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (nonatomic, weak) id<FTGymCourseTableViewDelegate> delegate;
- (void)reloadTableViews;//刷新tableView
@end
