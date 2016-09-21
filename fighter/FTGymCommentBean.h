//
//  FTGymCommentBean.h
//  fighter
//
//  Created by kang on 16/9/21.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTGymCommentBean : FTBaseBean

@property (nonatomic, assign) int id;

@property (nonatomic, assign) int comfort;//舒适度
@property (nonatomic, assign) int strength;//实力
@property (nonatomic, assign) int teachLevel;//教学水平

@property (nonatomic, assign) int commentcount;//评论数
@property (nonatomic, assign) int thumbCount;//点赞数

@property (nonatomic, copy) NSString *comment;//评论内容
@property (nonatomic, copy) NSString *createName;//
@property (nonatomic, copy) NSString *createTime;//评论时间
@property (nonatomic, copy) NSString *headUrl;//评论用户头像
@property (nonatomic, strong) NSString *userId;//评论用户的userId
@property (nonatomic, strong) NSString *objId;//评论拳馆id
@property (nonatomic, strong) NSString *urls;//评论拳馆id

@end
