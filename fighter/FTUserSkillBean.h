//
//  FTUserSkillBean.h
//  fighter
//
//  Created by 李懿哲 on 11/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTUserSkillBean : FTBaseBean

@property (nonatomic, assign) int id;//技能id
@property (nonatomic, copy) NSString *name;//技能名字
@property (nonatomic, assign) int subNumber;//子项个数
@property (nonatomic, assign) float score;//分值
@property (nonatomic, assign) int parrentId;//父技能id。如果是0，说明是母项
@property (nonatomic, assign) BOOL isParrent;//是否是父id，根据parrentId判断

@end
