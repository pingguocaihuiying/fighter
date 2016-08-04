//
//  FTFightingTableViewCell.m
//  fighter
//
//  Created by Liyz on 6/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTFightingTableViewCell.h"
#import "FTMatchBean.h"

@interface FTFightingTableViewCell()
@property (nonatomic, copy) NSString *matchID;
@end

@implementation FTFightingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置按钮的二态
    [_goToWatchButton setBackgroundImage:[UIImage imageNamed:@"前去观战pre"] forState:UIControlStateHighlighted];
    [_buyTicketButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-购票pre"] forState:UIControlStateHighlighted];
    [_supportButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-赞助pre"] forState:UIControlStateHighlighted];
//    [_followButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-已关注"] forState:UIControlStateHighlighted];
    [_betButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-下注pre"] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)watchButtonClicked:(id)sender {
    [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionWatch andMatchBean:_matchBean];
}
- (IBAction)buyTicketButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionBuyTicket andMatchBean:_matchBean];
}
- (IBAction)supportButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionSupport andMatchBean:_matchBean];
}
- (IBAction)followButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionFollow andMatchBean:_matchBean];
}
- (IBAction)betButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionBet andMatchBean:_matchBean];
}
- (IBAction)payButtonClicked:(id)sender {
           [_buttonsClickedDelegate buttonClickedWithActionType:FTButtonActionPay andMatchBean:_matchBean];
}

- (void)setWithBean:(FTBaseBean *)bean{
    //转换传过来的baseBean为matchBean
    FTMatchBean *matchBean = (FTMatchBean *)bean;
    
    //比赛的id
        //(模型中matchId虽然声明的是NSString类型，但实际上可能是long型，json解析出来直接赋值了，没有经过处理，所以这这儿赋值的时候进行了格式化转换)
    _matchID = [NSString stringWithFormat:@"%@", matchBean.matchId];
    
    //头像
    [_headerImage1 sd_setImageWithURL:[NSURL URLWithString:matchBean.headUrl1]];
    [_headerImage2 sd_setImageWithURL:[NSURL URLWithString:matchBean.headUrl2]];
    
    //名字
    _nameLabel1.text = matchBean.userName;
    _nameLabel2.text = matchBean.against;
    
    //战绩
    _standingLabel1.text = [NSString stringWithFormat:@"%@胜 %@负 %@平 %@", matchBean.win1, matchBean.fail1, matchBean.draw1, matchBean.knockout1];
    _standingLabel2.text = [NSString stringWithFormat:@"%@胜 %@负 %@平 %@", matchBean.win2, matchBean.fail2, matchBean.draw2, matchBean.knockout2];
    
    //比赛时间和地点
    NSArray *timeStringArray = [matchBean.timeSection componentsSeparatedByString:@"~"];
    NSString *timeString = [timeStringArray firstObject];
    _WhenAndWhereLabel.text = [NSString stringWithFormat:@"%@ %@", timeString, matchBean.corporationName];
    
    //比赛项目
    _raceTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"格斗标签-%@", matchBean.label]];
    
    //可用按钮的显示、比赛状态（因为筛选条件相似，所以放在了一起）
    
    /**
     *  ”关注“按钮 一直显示
     */
    
    /**
     *  statu	值为：
     
     0-对手未迎战，
     1-对手已迎战，
     2-比赛进行中，
     3-比赛结束，
     4- 对手拒绝
     
     payStatu 值为：
     
     0-支付未完成
     1-完成支付
     
     payType:支付方式，0-我支付，1-对方支付，2-赢家支付，3-AA支付，4-输家支付，5-赞助
     //*****************需求改动，封存判断状态和可选按钮的代码##########开始###################
//    if ([matchBean.statu isEqualToString:@"2"]) {//  当比赛已经开始，状态为“正在比赛”，下面显示 ”前去观看“按钮 statu=2
//        
//        /**
//         *  状态显示部分
//         *  状态：正在比赛
//         *  策略：只显示中间的，上下隐藏
//         */
//            //中间(显示)
//        _stateLabelCenter.text = @"正在比赛";
//        _stateLabelCenter.hidden = NO;
//        _stateBackgroundImageCenter.hidden = NO;
//        _RMBImageViewCenter.hidden = YES;
//            //上下(隐藏)
//        _stateLabelCenterTop.hidden = YES;
//        _stateBackgroundImageTop.hidden = YES;
//        _RMBImageViewTop.hidden = YES;
//        
//        _stateLabelCenterBottom.hidden = YES;
//        _stateBackgroundImageBottom.hidden = YES;
//        _RMBImageViewBottom.hidden = YES;
//        
//        
//        /**
//         *  底部按钮显示
//         */
//        _goToWatchButton.hidden = NO;
//        _supportButton.hidden = YES;
//        _buyTicketButton.hidden = YES;
//        _betButton.hidden = YES;
//        _payButton.hidden = YES;
//    } else if ([matchBean.statu isEqualToString:@"2"]&& [matchBean.payStatu isEqualToString:@"1"]){//当匹配到对手，支付完成，状态显示“即将开赛”，显示“购票”、“下注”按钮 statu=1，payStatu=1
//
//        
//        /**
//         *  状态显示部分
//         *  状态：即将开赛
//         *  策略：只显示中间的，上下隐藏
//         */
//        //中间(显示)
//        _stateLabelCenter.text = @"即将开赛";
//        _stateLabelCenter.hidden = NO;
//        _stateBackgroundImageCenter.hidden = NO;
//        _RMBImageViewCenter.hidden = YES;
//        //上下(隐藏)
//        _stateLabelCenterTop.hidden = YES;
//        _stateBackgroundImageTop.hidden = YES;
//        _RMBImageViewTop.hidden = YES;
//        
//        _stateLabelCenterBottom.hidden = YES;
//        _stateBackgroundImageBottom.hidden = YES;
//        _RMBImageViewBottom.hidden = YES;
//        
//        
//        /**
//         *  底部按钮显示
//         */
//        _goToWatchButton.hidden = YES;
//        _supportButton.hidden = YES;
//        _buyTicketButton.hidden = YES;
//        _betButton.hidden = YES;
//        _payButton.hidden = NO;
//    } else if ([matchBean.needPay isEqualToString:@"1"]){//如果需要当前用户支付（赞助不算）
//        NSLog(@"pay");
//        /**
//         *  状态显示部分
//         *  状态：比赛筹备中
//         *  策略：只显示中间的，上下隐藏
//         */
//        //中间(显示)
//        _stateLabelCenter.text = @"比赛筹备中";
//        _stateLabelCenter.hidden = NO;
//        _stateBackgroundImageCenter.hidden = NO;
//        _RMBImageViewCenter.hidden = YES;
//        //上下(隐藏)
//        _stateLabelCenterTop.hidden = YES;
//        _stateBackgroundImageTop.hidden = YES;
//        _RMBImageViewTop.hidden = YES;
//        
//        _stateLabelCenterBottom.hidden = YES;
//        _stateBackgroundImageBottom.hidden = YES;
//        _RMBImageViewBottom.hidden = YES;
//        
//        
//        /**
//         *  底部按钮显示
//         */
//        _goToWatchButton.hidden = YES;
//        _supportButton.hidden = YES;
//        _buyTicketButton.hidden = YES;
//        _betButton.hidden = YES;
//        _payButton.hidden = NO;
//    }else if ([matchBean.payType isEqualToString:@"5"] && [matchBean.payStatu isEqualToString:@"0"]){//当①支付尚未完成②支付方式为赞助支付，而且，显示“赞助”按钮
//        
//
//        if([matchBean.statu isEqualToString:@"1"]){//statu = 1,找到对手；statu = 0,未找到对手
//            /**
//             *  状态显示部分1⃣️如果找到对手
//             *  状态：等待赞助
//             *  策略：只显示中间的，上下隐藏
//             */
//            //中间(显示)
//            _stateLabelCenter.text = @"等待赞助";
//            _stateLabelCenter.hidden = NO;
//            _stateBackgroundImageCenter.hidden = NO;
//            _RMBImageViewCenter.hidden = NO;
//            //上下(隐藏)
//            _stateLabelCenterTop.hidden = YES;
//            _stateBackgroundImageTop.hidden = YES;
//            _RMBImageViewTop.hidden = YES;
//            
//            _stateLabelCenterBottom.hidden = YES;
//            _stateBackgroundImageBottom.hidden = YES;
//            _RMBImageViewBottom.hidden = YES;
//            _payButton.hidden = YES;
//        }else if([matchBean.statu isEqualToString:@"0"]){
//            /**
//             *  状态显示部分2⃣️如果没有找到对手
//             *  状态：等待对手、等待赞助
//             *  策略：显示上下，中间的隐藏
//             */
//            
//            //中间(隐藏)
//            _stateLabelCenter.hidden = YES;
//            _stateBackgroundImageCenter.hidden = YES;
//            _RMBImageViewCenter.hidden = YES;
//            
//            //上下(显示)
//            _stateLabelCenterTop.text = @"等待对手";
//            _stateLabelCenterTop.hidden = NO;
//            _stateBackgroundImageTop.hidden = NO;
//            _RMBImageViewTop.hidden = YES;
//            
//            _stateLabelCenterBottom.text = @"等待赞助";
//            _stateLabelCenterBottom.hidden = NO;
//            _stateBackgroundImageBottom.hidden = NO;
//            _RMBImageViewBottom.hidden = NO;
//        }
//    
//        /**
//         *  底部按钮显示
//         */
//        _goToWatchButton.hidden = YES;
//        _supportButton.hidden = YES;
//        _buyTicketButton.hidden = YES;
//        _betButton.hidden = YES;
//        _payButton.hidden = YES;
//    }else{
//        
//        /**
//         *  状态显示部分
//         *  状态：正在比赛
//         *  策略：只显示中间的，上下隐藏
//         */
//        //中间(显示)
//        _stateLabelCenter.text = @"其他";
//        _stateLabelCenter.hidden = NO;
//        _stateBackgroundImageCenter.hidden = NO;
//        _RMBImageViewCenter.hidden = YES;
//        //上下(隐藏)
//        _stateLabelCenterTop.hidden = YES;
//        _stateBackgroundImageTop.hidden = YES;
//        _RMBImageViewTop.hidden = YES;
//        
//        _stateLabelCenterBottom.hidden = YES;
//        _stateBackgroundImageBottom.hidden = YES;
//        _RMBImageViewBottom.hidden = YES;
//        
//        
//        /**
//         *  底部按钮显示
//         */
//        _goToWatchButton.hidden = YES;
//        _supportButton.hidden = YES;
//        _buyTicketButton.hidden = YES;
//        _betButton.hidden = YES;
//    }
     //*****************需求改动，封存判断状态和可选按钮的代码##########结束###################
    
            /**
             *  底部按钮显示
             */
            _goToWatchButton.hidden = NO;
            _supportButton.hidden = YES;
            _buyTicketButton.hidden = YES;
            _betButton.hidden = YES;
    
}

@end
