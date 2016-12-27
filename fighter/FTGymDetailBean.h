//
//  FTGymDetailBean.h
//  fighter
//
//  Created by 李懿哲 on 16/9/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTGymDetailBean : FTBaseBean

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int commentcount;//评论数
@property (nonatomic, assign) int gym_corporationid;
@property (nonatomic, assign) NSInteger corporationid;
@property (nonatomic, assign) float grade;//评级
@property (nonatomic, assign) int pictureCount;///图片数量统计
@property (nonatomic, assign) int videoCount;//视频数量统计

@property (nonatomic, copy) NSString *gym_location;//地址
@property (nonatomic, copy) NSString *gym_name;//名称
@property (nonatomic, copy) NSString *picture;//拳馆宣传图地址
@property (nonatomic, copy) NSString *gym_show_img;//拳馆宣传图地址
@property (nonatomic, strong) NSArray *gymImgs;//图片地址数组
@property (nonatomic, strong) NSArray *gymVideos;//视频地址数组
@property (nonatomic, copy) NSString *urlprefix;//图片、视频地址前缀  coachs
@property (nonatomic, strong) NSArray *coachs;//拳馆的所有教练
@property (nonatomic, copy) NSString *gym_tel;//拳馆电话
@property (nonatomic, copy) NSString *gym_remark;//拳馆电话
@property (nonatomic, assign) int openItem;//课程开关 0（默认）-都开启；1-只开团课；2-只开私课
@end
