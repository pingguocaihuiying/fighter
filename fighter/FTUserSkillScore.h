//
//  FTUserSkillScore.h
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTUserSkillScore : FTBaseBean

@property (nonatomic, copy) NSString *skill;//名称
@property (nonatomic, assign) float score;//较新的得分
@property (nonatomic, assign) float increase;//变化的得分
@property (nonatomic, assign) float scoreOld;//旧的分数，由较新得分-变化得分获得

@end
