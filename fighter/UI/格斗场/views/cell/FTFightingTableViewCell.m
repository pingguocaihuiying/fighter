//
//  FTFightingTableViewCell.m
//  fighter
//
//  Created by Liyz on 6/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTFightingTableViewCell.h"

@implementation FTFightingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置按钮的二态
    [_goToWatchButton setBackgroundImage:[UIImage imageNamed:@"前去观战pre"] forState:UIControlStateHighlighted];
    [_buTicketButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-购票pre"] forState:UIControlStateHighlighted];
    [_supportButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-赞助pre"] forState:UIControlStateHighlighted];
//    [_followButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-已关注"] forState:UIControlStateHighlighted];
    [_betButton setBackgroundImage:[UIImage imageNamed:@"列表3按钮-下注pre"] forState:UIControlStateHighlighted];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)watchButtonClicked:(id)sender {
    [_buttonsClickedDelegate buttonClickedWithIdentifycation:@"watch" andRaceId:@"foo raceId"];
}
- (IBAction)buyTicketButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithIdentifycation:@"buyTicket" andRaceId:@"foo raceId"];
}
- (IBAction)supportButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithIdentifycation:@"support" andRaceId:@"foo raceId"];
}
- (IBAction)followButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithIdentifycation:@"follow" andRaceId:@"foo raceId"];
}
- (IBAction)betButtonClicked:(id)sender {
        [_buttonsClickedDelegate buttonClickedWithIdentifycation:@"bet" andRaceId:@"foo raceId"];
}

@end
