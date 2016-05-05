//
//  FTVideoDetailViewController.h
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTVideoBean.h"

@interface FTVideoDetailViewController : FTBaseViewController
@property (nonatomic ,copy)NSString *webViewUrlString;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;
@property (nonatomic, strong)FTVideoBean *videoBean;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *favourateView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@end
