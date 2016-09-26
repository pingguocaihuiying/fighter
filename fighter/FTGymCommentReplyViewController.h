//
//  FTGymCommentReplyViewController.h
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"
@class FTGymCommentBean;

@interface FTGymCommentReplyViewController : FTBaseViewController2
@property(nonatomic, strong) NSString *objId;
@property (nonatomic, strong) FTGymCommentBean *bean;
@property (nonatomic, assign) BOOL thumbState;
@end
