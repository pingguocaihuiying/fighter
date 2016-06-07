//
//  FTHomepageCommentListViewController.h
//  fighter
//
//  Created by Liyz on 6/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTHomepageCommentListViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (nonatomic, copy) NSString *objId;//用户id,用于请求评论列表、关注等
@property (nonatomic, copy) NSString *tableName;//查询评论的表
@end
