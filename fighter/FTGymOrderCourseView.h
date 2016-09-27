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
    FTGymCourseStatusCancelOrder
};

@protocol FTGymOrderCourseViewDelegate <NSObject>



@end

#import <UIKit/UIKit.h>

@interface FTGymOrderCourseView : UIView
@property (strong, nonatomic) IBOutlet UIView *belowView1;
@property (strong, nonatomic) IBOutlet UIView *belowView2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *belowView1Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *belowView2Height;
@property (nonatomic, assign) FTGymCourseStatus status;
@end
