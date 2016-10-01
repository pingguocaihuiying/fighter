//
//  FTGymOrderCourseView.h
//  fighter
//
//  Created by 李懿哲 on 26/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

/**
 预约弹出框的三中状态

 - FTGymCourseStatusHasOrder:  已预约状态：显示『取消预约』和『我知道了』
 - FTGymCourseStatusCanOrder:可以预约状态：显示『课程详情』和『确定预约』。预约成功后，变为『已预约』状态
 - FTGymCourseStatusCantOrder: 不可预约状态：：显示『课程详情』和『确定』
 - FTGymCourseStatusCancelOrder: 取消预约状态：：显示『点错了』和『确定』
 */
typedef NS_ENUM(NSInteger, FTGymCourseStatus) {
    FTGymCourseStatusHasOrder,
    FTGymCourseStatusCanOrder,
    FTGymCourseStatusCantOrder,
    FTGymCourseStatusCancelOrder,
    FTGymCourseStatusIsFull
};

@protocol FTGymOrderCourseViewDelegate <NSObject>
- (void)bookSuccess;

@end

#import <UIKit/UIKit.h>

@interface FTGymOrderCourseView : UIView
@property (strong, nonatomic) IBOutlet UIView *belowView1;
@property (strong, nonatomic) IBOutlet UIView *belowView2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *belowView1Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *belowView2Height;
@property (nonatomic, assign) FTGymCourseStatus status;
@property (nonatomic, strong) NSDictionary *courserCellDic;//存放一小段课程
@property (nonatomic, copy) NSString *dateTimeStamp;//课程那一天的时间戳
@property (nonatomic, copy) NSString *dateString;//课程那一天的日期，eg：7月8日
@property (nonatomic, copy) NSString *gymId;//拳馆id
@property (nonatomic, weak) id<FTGymOrderCourseViewDelegate> delegate;

@end
