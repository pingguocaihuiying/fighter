//
//  FTGymBean.h
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTGymBean : FTBaseBean
/**

     gymId:           拳馆id
     gymType:        拳馆支持类型同接口参数【英文标签以,分割】
     gymOpenTime:     拳馆营业时间
     city:           拳馆所在城市
     gymLocation：   具体位置
     gymTel：        电话号码
     gymPlaceNum:     场地数量
     urlPrefix:       封面图，宣传图，视频的前缀，具体拼接方法参考七牛
     gymShowVideo：    视频【多个以,为分割】
     gymShowImg：       封面图【多个以,为分割】
     gym_show_img_more:    宣传图【多个以,为分割】
     gymName:         拳馆名称
     createtime：       创建时间
     updatetime：       更新时间
     commentCount：   评论数
     voteCount：         点赞数
     viewCount：         观看数
     gym_from：         拳馆来源 0 system后台创建  1 Crm创建
 **/
@property (nonatomic,copy) NSString *gymId;//用于个人主页关注、取消关注
@property (nonatomic,copy) NSString *corporationid;//用于格斗场发起比赛、选择拳馆的时间段
@property (nonatomic,copy) NSString *gymType;
@property (nonatomic,copy) NSString *gymOpenTime;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *gymLocation;
@property (nonatomic,copy) NSString *gymTel;
@property (nonatomic,copy) NSString *gymPlaceNum;
@property (nonatomic,copy) NSString *urlPrefix;
@property (nonatomic,copy) NSString *gymShowVideo;
@property (nonatomic,copy) NSString *gymShowImg;
@property (nonatomic,copy) NSString *gymShowImgMore;

@property (nonatomic,copy) NSString *gymName;
@property (nonatomic,copy) NSString *createtime;

@property (nonatomic,copy) NSString *updatetime;
@property (nonatomic,copy) NSString *commentCount;

@property (nonatomic,copy) NSString *voteCount;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *gymFrom;

@property (nonatomic, copy) NSString *isGymUser;//当前用户是否是该拳馆的会员



@end
