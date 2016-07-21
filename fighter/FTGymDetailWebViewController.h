//
//  FTGymDetailWebViewController.h
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTGymBean.h"
@interface FTGymDetailWebViewController : FTBaseViewController

@property (nonatomic ,strong) FTGymBean *gymBean;

// bottom view
@property (weak, nonatomic) IBOutlet UIView *focusView; //关注
@property (weak, nonatomic) IBOutlet UIView *shareView; // 分享
@property (weak, nonatomic) IBOutlet UIView *commentView; // 评论
@property (weak, nonatomic) IBOutlet UIView *voteView; //拨号


// button
@property (weak, nonatomic) IBOutlet UIButton *focusButton;//  收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn; //评论按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;// 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *dialBtn; // 点赞按钮


@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasAttention;


@end
