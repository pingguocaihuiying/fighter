//
//  FTDefaultFullMatchingTableViewCell.h
//  fighter
//
//  Created by Liyz on 7/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"


@protocol FTDefaultFullyMatchingCellSelected <NSObject>

- (void)defaultFullyMatchingSelected;

@end
@interface FTDefaultFullMatchingTableViewCell : FTBaseTableViewCell
@property (nonatomic, weak)id<FTDefaultFullyMatchingCellSelected> delegate;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end
