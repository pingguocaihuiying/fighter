//
//  FTArenaPostsDetailViewController.h
//  fighter
//
//  Created by Liyz on 5/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTArenaBean.h"

@protocol FTArenaDetailDelegate <NSObject>

- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath;

@end

@interface FTArenaPostsDetailViewController : FTBaseViewController

@property (nonatomic, weak)id<FTArenaDetailDelegate> delegate;

@property (nonatomic ,copy)NSString *webViewUrlString;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;
@property (nonatomic, strong)FTArenaBean *arenaBean;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *favourateView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NSString *webUrlString;

@end
