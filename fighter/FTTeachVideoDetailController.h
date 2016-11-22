//
//  FTTeachVideoDetailController.h
//  fighter
//
//  Created by kang on 16/7/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTVideoDetailViewController.h"
#import "FTVideoBean.h"
#import "FTArenaBean.h"

@interface FTTeachVideoDetailController : FTBaseViewController

@property (nonatomic, weak)id<FTVideoDetailDelegate> delegate;

@property (nonatomic ,copy)NSString *webViewUrlString;

// bottom view
@property (weak, nonatomic) IBOutlet UIView *favourateView; // 收藏
@property (weak, nonatomic) IBOutlet UIView *shareView; // 分享
@property (weak, nonatomic) IBOutlet UIView *commentView; // 评论
@property (weak, nonatomic) IBOutlet UIView *voteView; //点赞

// button
@property (weak, nonatomic) IBOutlet UIButton *starButton;//  收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn; //评论按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;// 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton; // 点赞按钮


@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;

@property (nonatomic, strong)FTVideoBean *videoBean;


@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NSString *webUrlString;
@property (nonatomic ,copy)NSString *urlId;//从个人主页跳转过来用到的拳讯或视频id

//分享
@property (nonatomic, copy) NSString *labelImage;
@property (nonatomic, copy) NSString *label;

@end
