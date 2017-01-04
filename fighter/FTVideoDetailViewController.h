//
//  FTVideoDetailViewController.h
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

/**
 *  咨询详情和视频详情整合在了一起
 */

typedef NS_ENUM(NSInteger, FTDetailType) {
    /**
     *  新闻类型
     */
    FTDetailTypeNews = 0,
    /**
     *  视频类型
     */
    FTDetailTypeVideo = 1
};

#import "FTBaseViewController.h"
#import "FTNewsBean.h"
#import "FTArenaBean.h"

@protocol FTVideoDetailDelegate <NSObject>

- (void)updateCountWithVideoBean:(FTNewsBean *)videoBean indexPath:(NSIndexPath *)indexPath;


@end


@interface FTVideoDetailViewController : FTBaseViewController

@property (nonatomic, assign) FTDetailType detailType;//类型：视频或咨询（虽然现在webview不区分，但有时候还是要区分：比如，如果是视频，进来之后会增加观看数）

@property (nonatomic, weak)id<FTVideoDetailDelegate> delegate;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, assign)BOOL hasStar;
@property (nonatomic, strong)FTNewsBean *newsBean;
@property (nonatomic, strong) FTArenaBean *arenaBean;
@property (weak, nonatomic) IBOutlet UIView *favourateView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *voteView;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (nonatomic, strong)NSIndexPath *indexPath;
//@property (nonatomic, strong)NSString *webUrlString;
@property (nonatomic ,copy)NSString *objId;//有些界面没有bean，只有objId，则传objId。viewDidLoad后，检查bean，如果不存在，则拿objId去重新加载
@end
