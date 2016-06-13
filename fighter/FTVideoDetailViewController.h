//
//  FTVideoDetailViewController.h
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTVideoBean.h"
#import "FTArenaBean.h"

@protocol FTVideoDetailDelegate <NSObject>

- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath;

@end


@interface FTVideoDetailViewController : FTBaseViewController

@property (nonatomic, weak)id<FTVideoDetailDelegate> delegate;

@property (nonatomic ,copy)NSString *webViewUrlString;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;
@property (nonatomic, strong)FTVideoBean *videoBean;
@property (nonatomic, strong) FTArenaBean *arenaBean;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *favourateView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NSString *webUrlString;
@property (nonatomic ,copy)NSString *urlId;//从个人主页跳转过来用到的拳讯或视频id
@end
