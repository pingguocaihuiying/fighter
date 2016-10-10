//
//  FTCoachHistoryCourseTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTCoachHistoryCourseTableViewCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeSectionLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
