//
//  FTCommentViewController.h
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTNewsBean.h"
#import "FTVideoBean.h"
#import "FTArenaBean.h"
#import "FTGymBean.h"
#import "FTMatchDetailBean.h"

@protocol CommentSuccessDelegate <NSObject>
- (void)commentSuccess;
@end

@interface FTCommentViewController : FTBaseViewController
@property (nonatomic, strong)FTNewsBean *newsBean;
@property (nonatomic, strong)FTVideoBean *videoBean;
@property (nonatomic, strong)FTGymBean *gymBean;
@property (nonatomic, strong)FTArenaBean *arenaBean;
@property (nonatomic, strong)FTMatchDetailBean *matchDetailBean;

@property (nonatomic, copy) NSString *objId;//用户id（包含普通用户、拳手用户）
@property (nonatomic, copy) NSString *tableName;//评论用户时的tableName
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak)id<CommentSuccessDelegate> delegate;

@end
