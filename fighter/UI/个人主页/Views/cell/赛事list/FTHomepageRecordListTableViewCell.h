//
//  FTHomepageRecordListTableViewCell.h
//  fighter
//
//  Created by Liyz on 6/2/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTHomepageRecordListTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *raceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *opponentNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *raceResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *theTimelabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

- (void)setWithDic:(NSDictionary *)dic;

@end
