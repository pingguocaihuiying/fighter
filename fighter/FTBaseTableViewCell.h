//
//  FTBaseTableViewCell.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseBean.h"

@interface FTBaseTableViewCell : UITableViewCell



- (void)setWithBean:(FTBaseBean *)bean;

@end

@protocol baseTableViewCellDelegate <NSObject>

//- (void)cellClickedWith

@end