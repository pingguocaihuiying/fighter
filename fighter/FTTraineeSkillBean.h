//
//  FTTraineeSkillBean
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTTraineeSkillBean : NSObject

@property (nonatomic, assign) NSInteger score;

@property (nonnull, nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger parent;

@property (nonatomic, assign) NSInteger id;

- (_Nonnull instancetype)initWithFTTraineeSkillBeanDic:(NSDictionary * _Nonnull)infoDic;

@end
