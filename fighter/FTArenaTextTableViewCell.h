//
//  FTArenaTextTableViewCell.h
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTArenaTextTableViewCell : FTBaseTableViewCell
- (void)setWithBean:(FTNewsBean *)bean;
@property (weak, nonatomic) IBOutlet UILabel *sumupLabel;
@end
