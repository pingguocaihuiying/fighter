//
//  FTModuleBean.h
//  fighter
//
//  Created by 李懿哲 on 28/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTModuleBean : FTBaseBean

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, assign) NSInteger followId;//注：若该字段有返回且大于0，表示当前用户关注了该板块
@property (nonatomic, copy) NSString *name;//版块名称，如：综合格斗
@property (nonatomic, copy) NSString *category;//该版块所属的分类，如：格斗装备、推荐版块
@property (nonatomic, copy) NSString *pict;//图片地址
@property (nonatomic, copy) NSString *desc;

@end
