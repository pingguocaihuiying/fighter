//
//  FTRecordRankTableViewCell.h
//  fighter
//
//  Created by Liyz on 6/2/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTRecordRankTableViewCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *competitionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *curRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestRankLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorIndexView;
@end
