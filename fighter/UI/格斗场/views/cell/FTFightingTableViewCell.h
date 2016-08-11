//
//  FTFightingTableViewCell.h
//  fighter
//
//  Created by Liyz on 6/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"
#import "FTMatchBean.h"
#import "FTMatchBean.h"

//定义按钮动作的类型
typedef NS_ENUM(int, FTMatchListButtonActionType){
    FTButtonActionWatch = 0,//前去观战
    FTButtonActionBuyTicket = 1,//购票
    FTButtonActionSupport = 2,//赞助
    FTButtonActionFollow = 3,//关注
    FTButtonActionBet = 4,//下注
    FTButtonActionPay = 5,//支付
};

@protocol FTFightingTableViewCellButtonsClickedDelegate <NSObject>

- (void)buttonClickedWithActionType:(FTMatchListButtonActionType)actionType andMatchBean:(FTMatchBean *)matchBean andButton:(UIButton *) button;

@end

@interface FTFightingTableViewCell : FTBaseTableViewCell

    @property (nonatomic, strong) FTMatchBean *matchBean;

    @property (weak, nonatomic) id<FTFightingTableViewCellButtonsClickedDelegate> buttonsClickedDelegate;

    @property (weak, nonatomic) IBOutlet UIButton *goToWatchButton;//前去观看
    @property (weak, nonatomic) IBOutlet UIButton *buyTicketButton;//购票
    @property (weak, nonatomic) IBOutlet UIButton *supportButton;//赞助
    @property (weak, nonatomic) IBOutlet UIButton *followButton;//关注
    @property (weak, nonatomic) IBOutlet UIButton *betButton;//下注
@property (strong, nonatomic) IBOutlet UIButton *payButton;

    @property (weak, nonatomic) IBOutlet UIImageView *headerImage1;//发起人头像
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel1;//发起人名字label
    @property (weak, nonatomic) IBOutlet UILabel *standingLabel1;//发起人战绩label

    @property (weak, nonatomic) IBOutlet UIImageView *headerImage2;//对手头像
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel2;//对手名字
    @property (weak, nonatomic) IBOutlet UILabel *standingLabel2;//对手战绩

    @property (weak, nonatomic) IBOutlet UILabel *WhenAndWhereLabel;//比赛开始时间、比赛拳馆的名字

    @property (weak, nonatomic) IBOutlet UIImageView *raceTypeImage;//比赛项目类型


    //比赛状态控件，有上中下三组，可以根据比赛具体的状态，使用、隐藏

        //中间的
    @property (weak, nonatomic) IBOutlet UIImageView *stateBackgroundImageCenter;
    @property (weak, nonatomic) IBOutlet UILabel *stateLabelCenter;
    @property (weak, nonatomic) IBOutlet UIImageView *RMBImageViewCenter;

        //上方的
    @property (weak, nonatomic) IBOutlet UIImageView *stateBackgroundImageTop;
    @property (weak, nonatomic) IBOutlet UILabel *stateLabelCenterTop;
    @property (weak, nonatomic) IBOutlet UIImageView *RMBImageViewTop;
        //下方的
    @property (weak, nonatomic) IBOutlet UIImageView *stateBackgroundImageBottom;
    @property (weak, nonatomic) IBOutlet UILabel *stateLabelCenterBottom;
    @property (weak, nonatomic) IBOutlet UIImageView *RMBImageViewBottom;
@end
