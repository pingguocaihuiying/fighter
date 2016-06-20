//
//  FTFightingTableViewCell.h
//  fighter
//
//  Created by Liyz on 6/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@protocol FTFightingTableViewCellButtonsClickedDelegate <NSObject>

- (void)buttonClickedWithIdentifycation:(NSString *)identifycationString andRaceId:(NSString *)raceId ;

@end

@interface FTFightingTableViewCell : FTBaseTableViewCell
    @property (weak, nonatomic) id<FTFightingTableViewCellButtonsClickedDelegate> buttonsClickedDelegate;
    @property (weak, nonatomic) IBOutlet UIButton *goToWatchButton;
    @property (weak, nonatomic) IBOutlet UIButton *buTicketButton;
    @property (weak, nonatomic) IBOutlet UIButton *supportButton;
    @property (weak, nonatomic) IBOutlet UIButton *followButton;
    @property (weak, nonatomic) IBOutlet UIButton *betButton;
    @property (weak, nonatomic) IBOutlet UIImageView *headerImage1;
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
    @property (weak, nonatomic) IBOutlet UILabel *standingLabel1;
    @property (weak, nonatomic) IBOutlet UIImageView *headerImage2;
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
    @property (weak, nonatomic) IBOutlet UILabel *standingLabel2;
    @property (weak, nonatomic) IBOutlet UILabel *WhenAndWhereLabel;
    @property (weak, nonatomic) IBOutlet UILabel *stateLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *raceTypeImage;

@end
