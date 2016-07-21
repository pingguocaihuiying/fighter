//
//  FTGymBean.m
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymBean.h"

@implementation FTGymBean

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

- (void)setValuesWithDic:(NSDictionary *)dic{
    
    self.gymId = dic[@"gymId"];
    self.gymType = dic[@"gymType"];
    self.gymOpenTime = dic[@"gymOpenTime"];
    self.city = dic[@"city"];
    self.gymLocation = dic[@"gymLocation"];
    self.gymTel = dic[@"gymTel"];
    self.gymPlaceNum = dic[@"gymPlaceNum"];
    self.urlPrefix = dic[@"urlPrefix"];
    self.gymShowVideo = dic[@"gymShowVideo"];
    self.gymShowImg = dic[@"gymShowImg"];
    self.gymShowImgMore = dic[@"gym_show_img_more"];
    
    self.gymName = dic[@"gymName"];
    self.createtime = dic[@"createtime"];
    self.updatetime = dic[@"updatetime"];
    
    self.voteCount = dic[@"voteCount"];
    self.commentCount = dic[@"commentCount"];
    self.viewCount = dic[@"viewCount"];
    
    self.gymFrom = dic[@"gym_from"];
    
}


@end